//
//  ViewController.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/19/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class ListFieldCreationVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
  @IBOutlet weak var nameFld: UITextField!
  @IBOutlet weak var typePicker: UIPickerView!
  @IBOutlet weak var valueFld: UITextField!
  var fieldTypes: [FieldType] = [.checkBox, .date, .memo, .number, .text]
  var saveDelegate: FieldSaveDelegate?
//  var existingFields: ListFieldProtocol?
//  var existingFieldIndex: Int?

  override func viewDidLoad() {
    super.viewDidLoad()
    typePicker.delegate = self
    typePicker.dataSource = self
    
//    if existingFields != nil {
//      populateFields(with: existingFields!)
//    }
  }
  
  func populateFields(with existing: ItemFieldProtocol) {
//    nameFld.text = existing.name
//    valueFld.text = "\(String(describing: existing.value.data))"
//    let typeIndex = fieldTypes.firstIndex(of: existing.type)
//    typePicker.selectRow(typeIndex ?? 0, inComponent: 0, animated: true)
  }
  
  @IBAction func donePressed(sender: UIButton) {
//    let selectedType = fieldTypes[typePicker.selectedRow(inComponent: 0)]
//    let newField = ListField(name: nameFld.text!, type: selectedType, value: FieldValue(data: valueFld.text!))
//
//    if existingFields == nil {
//      saveDelegate?.saveField(newField)
//    } else {
//      saveDelegate?.update(newField, at: existingFieldIndex!)
//    }
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func cancelPressed(sender: UIButton) {
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

