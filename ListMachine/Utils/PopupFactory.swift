//
//  PopupFactory.swift
//  ListMachine
//
//  Created by Drew Lanning on 1/7/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class PopupFactory {
  
  static func confirmationRequest(action: @escaping () -> ()) -> UIAlertController {
    let controller = UIAlertController(title: "Are you sure?", message: "This cannot be undone.", preferredStyle: .alert)
    let confirm = UIAlertAction(title: "Do it", style: .destructive) { (_) in
      action()
    }
    let cancel = UIAlertAction(title: "Nevermind", style: .cancel, handler: nil)
    controller.addAction(confirm)
    controller.addAction(cancel)
    controller.view.tintColor = Stylesheet.getColor(.primary)
    return controller
  }
  
  static func sortActionSheet(with fields: [String], sortedBy sortIndex: Int?, ascending: Bool, completion: @escaping (Int) -> ()) -> UIAlertController {
    let controller = UIAlertController(title: "Sort by:", message: nil, preferredStyle: .actionSheet)
    for (idx, field) in fields.enumerated() {
      let action = UIAlertAction(title: field, style: .default) { (action) in
        completion(idx)
      }
      if let sort = sortIndex, sort == idx {
        let image = ascending ? UIImage(named: "Ascending") : UIImage(named: "Descending")
        action.setValue(image, forKey: "image")
      }
      controller.addAction(action)
    }
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    controller.addAction(cancel)
    controller.view.tintColor = Stylesheet.getColor(.primary)
    
    return controller
  }
  
  static func listTitleAlert(completion: @escaping () -> (), forList: List?) -> UIAlertController {
    let title: String
    let nameFieldText: String
    if let list = forList {
      title = "Edit list name"
      nameFieldText = list.name
    } else {
      title = "Name your list"
      nameFieldText = ""
    }
    let controller = UIAlertController(title: title, message: nil, preferredStyle: .alert)
    controller.addTextField { (nameField) in
      nameField.placeholder = "Enter list name"
      nameField.text = nameFieldText
      nameField.font = Stylesheet.uiElementFont(for: .textField)
      let heightConstraint = NSLayoutConstraint(item: nameField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 35.0)
      nameField.addConstraint(heightConstraint)
      nameField.becomeFirstResponder()
    }
    let done = UIAlertAction(title: "DONE", style: .default) { (action) in
      controller.view.successFeedback()
      guard let text = controller.textFields?[0].text, text.isEmpty == false else {
        controller.dismiss(animated: true, completion: nil)
        return
      }
      if let list = forList {
        DataStore()?.run {
          list.name = text
        }
      } else {
        DataStore()?.save(object: List(name: text), andRun: nil)
      }
      completion()
      controller.dismiss(animated: true, completion: nil)
    }
    let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
      controller.dismiss(animated: true, completion: nil)
    }
    
    controller.view.tintColor = Stylesheet.getColor(.primary)
    controller.addAction(done)
    controller.addAction(cancel)
    return controller
  }
}
