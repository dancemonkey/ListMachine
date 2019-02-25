//
//  ShowHideDetailBtn.swift
//  ListMachine
//
//  Created by Drew Lanning on 2/25/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class ShowHideDetailBtn: UIButton {

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    tapFeedback()
    pulsateIn()
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    pulsateOut()
  }
  
  func setVisible(to visible: Bool) {
    self.alpha = visible ? 1.0 : 0.5
  }

}
