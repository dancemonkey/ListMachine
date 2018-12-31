//
//  CustomFieldUIViewProtocol.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/31/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

protocol CustomFieldUIViewProtocol: AnyObject {
  var save: ((_: String)->())? { get set }
  func configure(with field: ItemField, and value: String?)
  init(with field: ItemField, and value: String?)
}

extension CustomFieldUIViewProtocol where Self: UIView {
  init(with field: ItemField, and value: String?) {
    self.init()
    self.configure(with: field, and: value)
  }
}

extension CustomFieldUIViewProtocol where Self: UITextInput { }
extension CustomFieldUIViewProtocol where Self: UITextField { }
