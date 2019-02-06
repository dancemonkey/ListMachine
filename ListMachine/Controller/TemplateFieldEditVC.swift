//
//  ViewController.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/19/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class TemplateFieldEditVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
  enum EditState {
    case newField, editingExistingField
  }
  @IBOutlet weak var nameFld: UserEntryField!
  @IBOutlet weak var typePicker: FieldTypePicker!
  @IBOutlet weak var titleLbl: UILabel!
  @IBOutlet weak var dataTypeLbl: UILabel!
  private var fieldTypes: [FieldType]!
  var saveDelegate: FieldSaveDelegate?
  var currentField: ItemFieldProtocol?
  var currentFieldIndex: Int?
  var state: EditState = .newField
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    typePicker.delegate = self
    typePicker.dataSource = self
    fieldTypes = FieldType.allCases
    fieldTypes.removeLast()
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(screenTapped(sender:)))
    self.view.addGestureRecognizer(tap)
    
    if currentField != nil {
      populateFields(with: currentField!)
      self.title = currentField!.name
      state = .editingExistingField
    } else {
      self.title = "New Field"
      state = .newField
    }
  
    addDoneAccessory(to: nameFld)
    styleViews()
  }
  
  func styleViews() {
    view.backgroundColor = Stylesheet.getColor(.white)
    titleLbl.textColor = Stylesheet.getColor(.primary)
    dataTypeLbl.textColor = Stylesheet.getColor(.primary)
    titleLbl.font = Stylesheet.uiElementFont(for: .fieldLabel)
    dataTypeLbl.font = Stylesheet.uiElementFont(for: .fieldLabel)
    nameFld.closure = { [weak self] in
      self?.saveField()
    }
    nameFld.becomeFirstResponder()
  }
  
  func populateFields(with existing: ItemFieldProtocol) {
    nameFld.text = existing.name
    let typeIndex = fieldTypes.firstIndex(of: FieldType(rawValue: existing.type)!)
    typePicker.selectRow(typeIndex ?? 0, inComponent: 0, animated: true)
  }
  
  func saveField() {
    let selectedType = fieldTypes[typePicker.selectedRow(inComponent: 0)]
    let field = ItemField(name: nameFld.text ?? "Unnamed", type: selectedType, value: nil, id: nil)
    
    switch state {
    case .newField:
      saveDelegate?.saveField(field)
      state = .editingExistingField
    case .editingExistingField:
      saveDelegate?.update(field, at: currentFieldIndex!)
    }
  }
  
  // MARK: Picker functions
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return fieldTypes.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return fieldTypes[row].getTitle()
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
    let title = fieldTypes[row].getTitle()
    let attributedTitle = NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor : Stylesheet.getColor(.primary)])
    return attributedTitle
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    saveField()
  }
  
  // MARK: Helper Functions
  @objc func screenTapped(sender: UITapGestureRecognizer) {
    UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
  }
  
  func addDoneAccessory(to textField: UITextField?) {
    let toolbar: UIToolbar = UIToolbar()
    toolbar.sizeToFit()
    var items = [UIBarButtonItem]()
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: textField, action: #selector(textField?.endEditing))
    let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    items.append(contentsOf: [spacer, doneButton])
    toolbar.setItems(items, animated: false)
    textField?.inputAccessoryView = toolbar
  }
}
