//
//  StatusBarExtension.swift
//  ListMachine
//
//  Created by Drew Lanning on 1/31/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

extension UIApplication {
  
  var statusBarView: UIView? {
    return value(forKey: "statusBar") as? UIView
  }
  
}

extension UINavigationController {
  override open var preferredStatusBarStyle : UIStatusBarStyle {
    return topViewController?.preferredStatusBarStyle ?? .default
  }
}
