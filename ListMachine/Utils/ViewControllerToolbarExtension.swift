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

  func setupToolbar(with newItemButton: UIButton?, and secondButton: UIButton?, and thirdButton: UIButton?) {
    toolBar.backgroundColor = Stylesheet.getColor(.white)
    toolBar.barTintColor = Stylesheet.getColor(.white)
    toolBar.isTranslucent = true
    let width: CGFloat = 45.0
    let height: CGFloat = 35.0
    var items: [UIBarButtonItem] = []
    if let button1 = newItemButton {
      let item = UIBarButtonItem(customView: button1)
      let itemWidth = item.customView?.widthAnchor.constraint(equalToConstant: width)
      let itemHeight = item.customView?.heightAnchor.constraint(equalToConstant: height)
      itemWidth?.isActive = true
      itemHeight?.isActive = true
      let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
      items.append(spacer)
      items.append(item)
    }
    if let button3 = thirdButton {
      let item = UIBarButtonItem(customView: button3)
      let itemWidth = item.customView?.widthAnchor.constraint(equalToConstant: width)
      let itemHeight = item.customView?.heightAnchor.constraint(equalToConstant: height)
      itemWidth?.isActive = true
      itemHeight?.isActive = true
      let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
      items.insert(item, at: 0)
      items.insert(spacer, at: 0)
    }
    if let button2 = secondButton {
      let item = UIBarButtonItem(customView: button2)
      let itemWidth = item.customView?.widthAnchor.constraint(equalToConstant: width)
      let itemHeight = item.customView?.heightAnchor.constraint(equalToConstant: height)
      itemWidth?.isActive = true
      itemHeight?.isActive = true
      items.insert(item, at: 0)
    }
    self.setToolbarItems(items, animated: true)
  }
  
}
