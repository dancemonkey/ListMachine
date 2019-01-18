//
//  PopupFactory.swift
//  ListMachine
//
//  Created by Drew Lanning on 1/7/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class PopupFactory {
  
  static func newListNamePopup(completion: @escaping () -> ()) -> UIAlertController {
    let controller = UIAlertController(title: "Name your list", message: nil, preferredStyle: .alert)
    controller.addTextField { (nameField) in
      nameField.placeholder = "Enter list name"
      let heightConstraint = NSLayoutConstraint(item: nameField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 35.0)
      nameField.addConstraint(heightConstraint)
    }
    
    let doneAction = UIAlertAction(title: "DONE", style: .default) { (action) in
      guard let text = controller.textFields![0].text else {
        controller.dismiss(animated: true, completion: nil)
        return
      }
      DataStore()?.save(object: List(name: text), andRun: nil)
      completion()
      controller.dismiss(animated: true, completion: nil)
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
      controller.dismiss(animated: true, completion: nil)
    }
    
    controller.addAction(doneAction)
    controller.addAction(cancelAction)
    
    return controller
  }
  
}
