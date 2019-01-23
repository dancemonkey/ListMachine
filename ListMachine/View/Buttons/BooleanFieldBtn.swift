//
//  BooleanFieldBtn.swift
//  ListMachine
//
//  Created by Drew Lanning on 1/23/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class BooleanFieldBtn: UIButton {
    
  func configure(as initialValue: Bool) {
    self.setImage(ImageFactory.booleanForItemCell(value: initialValue), for: .normal)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    if isTouchInside {
      print("running closure")
    }
  }

}
