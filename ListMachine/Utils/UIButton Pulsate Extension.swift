//
//  UIButton Pulsate Extension.swift
//  ListMachine
//
//  Created by Drew Lanning on 1/22/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

extension UIButton {
  func pulsateOut() {
    UIView.animate(withDuration: 0.1) {
      self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }
  }
  
  func pulsateIn() {
    UIView.animate(withDuration: 0.1) {
      self.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
    }
  }
}
