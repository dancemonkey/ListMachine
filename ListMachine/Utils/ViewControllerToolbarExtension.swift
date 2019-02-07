//
//  ViewControllerToolbarExtension.swift
//  ListMachine
//
//  Created by Drew Lanning on 1/31/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

extension UIViewController {

  weak var toolBar: UIToolbar! {
    get {
      return navigationController?.toolbar
    }
  }

  func setupToolbar(with newItemButton: UIButton?, and secondButton: UIButton?) {
    toolBar.backgroundColor = Stylesheet.getColor(.white)
    toolBar.barTintColor = Stylesheet.getColor(.white)
    toolBar.isTranslucent = true
    var items: [UIBarButtonItem] = []
    if let button1 = newItemButton {
      let item = UIBarButtonItem(customView: button1)
      let itemWidth = item.customView?.widthAnchor.constraint(equalToConstant: 35.0)
      let itemHeight = item.customView?.heightAnchor.constraint(equalToConstant: 35.0)
      itemWidth?.isActive = true
      itemHeight?.isActive = true
      let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
      items.append(spacer)
      items.append(item)
    }
    if let button2 = secondButton {
      let item = UIBarButtonItem(customView: button2)
      let itemWidth = item.customView?.widthAnchor.constraint(equalToConstant: 35.0)
      let itemHeight = item.customView?.heightAnchor.constraint(equalToConstant: 35.0)
      itemWidth?.isActive = true
      itemHeight?.isActive = true
      items.insert(item, at: 0)
    }
    self.setToolbarItems(items, animated: true)
  }
  
}
