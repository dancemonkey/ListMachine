//
//  ViewController.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/19/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class TemplateFieldEditVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
  @IBOutlet weak var nameFld: UITextField!
  @IBOutlet weak var typePicker: UIPickerView!
  private var fieldTypes: [FieldType] = [.checkBox, .date, .memo, .number, .text]
  var saveDelegate: FieldSaveDelegate?
  var currentField: ItemFieldProtocol?
  var currentFieldIndex: Int?

  override func viewDidLoad() {
    super.viewDidLoad()
    typePicker.delegate = self
    typePicker.dataSource = self
    
    if currentField != nil {
      populateFields(with: currentField!)
    }
  }
  
  func populateFields(with existing: ItemFieldProtocol) {
    nameFld.text = existing.name
    let typeIndex = fieldTypes.firstIndex(of: FieldType(rawValue: existing.type)!)
    typePicker.selectRow(typeIndex ?? 0, inComponent: 0, animated: true)
  }
  
  @IBAction func donePressed(sender: UIButton) {
    let selectedType = fieldTypes[typePicker.selectedRow(inComponent: 0)]
    let field = ItemField(name: nameFld.text ?? "Unnamed", type: selectedType, value: nil, id: nil)

    if currentField == nil {
      saveDelegate?.saveField(field)
    } else {
      saveDelegate?.update(field, at: currentFieldIndex!)
    }
    navigationController?.popViewController(animated: true)
  }
  
  // MARK: Picker functions
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return fieldTypes.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return fieldTypes[row].rawValue
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
}

