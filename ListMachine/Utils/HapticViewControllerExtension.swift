//
//  HapticViewControllerExtension.swift
//  ListMachine
//
//  Created by Drew Lanning on 2/10/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

extension UIView {
  var feedbackGen: UINotificationFeedbackGenerator {
    get {
      return UINotificationFeedbackGenerator()
    }
  }
  
  var impactGen: UIImpactFeedbackGenerator {
    get {
      return UIImpactFeedbackGenerator(style: .light)
    }
  }
  
  internal func tapFeedback() {
    impactGen.impactOccurred()
  }
  
  internal func successFeedback() {
    feedbackGen.notificationOccurred(.success)
  }
}
