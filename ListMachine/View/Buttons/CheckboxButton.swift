//
//  CheckboxButton.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/27/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class CheckboxButton: UIButton {
  
  func setChecked(_ checked: Bool) {
    if checked {
      setImage(UIImage(named: "checked"), for: .normal)
    } else {
      setImage(UIImage(named: "unchecked"), for: .normal)
    }
  }
  
}
