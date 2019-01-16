//
//  ItemValueEditVC.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/23/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class FieldValueEditVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
  
  @IBOutlet weak var nameFld: UITextField!
  @IBOutlet weak var typePicker: UIPickerView!
  @IBOutlet weak var valueFld: UITextField!
  var currentField: ItemFieldProtocol?
  var currentFieldIdx: Int?
  var saveDelegate: FieldSaveDelegate?
  
  private var fieldTypes: [FieldType] = [.text, .memo, .number, .date, .checkBox]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    typePicker.delegate = self
    typePicker.dataSource = self
    
    if let field = currentField {
      nameFld.text = field.name
      valueFld.text = (field.value) ?? ""
      let typeIndex = fieldTypes.firstIndex(of: FieldType(rawValue: field.type)!)
      typePicker.selectRow(typeIndex ?? 0, inComponent: 0, animated: true)
    }
    
    print("current field index = \(self.currentFieldIdx)")
  }
  
  // MARK: Actions
  @IBAction func savePressed(sender: UIButton) {
    // save values back to item
    let type = FieldType(rawValue: currentField?.type ?? "")
    let field = ItemField(name: currentField?.name ?? "Unnamed", type: type ?? FieldType.noType, value: valueFld.text ?? "", id: currentField?.fieldID.value)
    saveDelegate?.update(field, at: currentFieldIdx ?? 0)
    print("updating field at: \(currentFieldIdx)")
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
