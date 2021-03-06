//
//  ItemFieldTextView.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/31/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class ItemFieldTextView: UITextView, CustomFieldUIViewProtocol {
  
  var fieldSave: ((_: String) -> ())?

  var reportValue: String {
    return self.text
  }

  internal func configure(with field: ItemField, and value: String?) {
    self.text = value ?? ""
    backgroundColor = .clear
    textColor = Stylesheet.getColor(.black)
    font = Stylesheet.uiElementFont(for: .textField)
    self.autocapitalizationType = .sentences
    self.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
  }
  
  convenience init() {
    self.init(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
  }
  
  required convenience init(with field: ItemField, and value: String?) {
    self.init()
    self.configure(with: field, and: value)
  }
  
  override init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame, textContainer: textContainer)
    self.layer.borderColor = UIColor.lightGray.cgColor
    self.layer.borderWidth = 0.2
    self.layer.cornerRadius = 4.0
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func resignFirstResponder() -> Bool {
    fieldSave?(self.text)
    return super.resignFirstResponder()
  }
}
