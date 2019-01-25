//
//  SaveButton.swift
//  ListMachine
//
//  Created by Drew Lanning on 1/22/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class SaveButton: UIButton {

  override func awakeFromNib() {
    super.awakeFromNib()
    self.backgroundColor = Stylesheet.getColor(.primary)
    self.titleLabel?.font = Stylesheet.uiElementFont(for: .buttonLabel)
    self.layer.cornerRadius = 4.0
    self.titleLabel?.textColor = Stylesheet.getColor(.white)
    self.titleLabel?.tintColor = Stylesheet.getColor(.white)
    self.tintColor = Stylesheet.getColor(.white)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    pulsateIn()
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    pulsateOut()
  }

}
