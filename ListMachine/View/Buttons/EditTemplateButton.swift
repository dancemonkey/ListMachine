//
//  EditTemplateButton.swift
//  ListMachine
//
//  Created by Drew Lanning on 1/24/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class EditTemplateButton: UIButton {

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    tapFeedback()
    pulsateIn()
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    pulsateOut()
  }
  
  func setImageAndFrame() {
    setImage(UIImage(named: "editTemplateButtonAlt"), for: .normal)
    frame = CGRect(x: 0, y: 0, width: 44.0, height: 44.0)
    self.imageView?.contentMode = .scaleAspectFit
  }
  
}
