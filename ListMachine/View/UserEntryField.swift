//
//  UserEntryField.swift
//  ListMachine
//
//  Created by Drew Lanning on 1/25/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class UserEntryField: UITextField {
  
  var closure: (() -> ())?

  override func awakeFromNib() {
    super.awakeFromNib()
    backgroundColor = .clear
    borderStyle = .roundedRect
    textColor = Stylesheet.getColor(.black)
  }
  
  override func resignFirstResponder() -> Bool {
    closure?()
    return super.resignFirstResponder()
  }

}
