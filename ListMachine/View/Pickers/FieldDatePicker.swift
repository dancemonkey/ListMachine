//
//  FieldDatePicker.swift
//  ListMachine
//
//  Created by Drew Lanning on 1/28/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class FieldDatePicker: UIDatePicker {

  override func awakeFromNib() {
    super.awakeFromNib()
    self.backgroundColor = .clear
    self.setValue(Stylesheet.getColor(.primary), forKey: "textColor")
  }

}
