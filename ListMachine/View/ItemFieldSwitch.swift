//
//  ItemFieldSwitch.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/31/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class ItemFieldSwitch: UISwitch, CustomFieldUIViewProtocol {

  internal func configure(with field: ItemField, and value: String?) {
    let checked: Bool? = Bool(value ?? "false")
    self.isOn = checked ?? false
  }

}
