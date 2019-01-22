//
//  NewItemButton.swift
//  ListMachine
//
//  Created by Drew Lanning on 1/22/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class NewItemButton: UIButton {

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    pulsateIn()
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    pulsateOut()
  }

}
