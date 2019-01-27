//
//  ItemFieldTextField.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/31/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class ItemFieldTextField: UITextField, CustomFieldUIViewProtocol {
  
  var fieldSave: ((_: String) -> ())?

  var reportValue: String {
    return self.text ?? ""
  }

  func configure(with field: ItemField, and value: String?) {
    self.text = value ?? ""
    let type = FieldType(rawValue: field.type) ?? .noType
    if type == .number {
      self.keyboardType = .decimalPad
    }
    backgroundColor = .clear
    textColor = Stylesheet.getColor(.black)
    borderStyle = .roundedRect
  }
  
  convenience init() {
    self.init(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
  }
  
  required convenience init(with field: ItemField, and value: String?) {
    self.init()
    self.configure(with: field, and: value)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.borderStyle = .roundedRect
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func resignFirstResponder() -> Bool {
    fieldSave?(self.text ?? "")
    return super.resignFirstResponder()
  }

}
