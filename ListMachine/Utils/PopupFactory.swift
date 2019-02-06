//
//  PopupFactory.swift
//  ListMachine
//
//  Created by Drew Lanning on 1/7/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit
import PMAlertController

class PopupFactory {
  
  // TODO: consolidate these two functions, DRY
  
  static func newList(completion: @escaping () -> ()) -> PMAlertController {
    let controller = PMAlertController(title: "Name your list", description: "", image: nil, style: .alert)
    controller.addTextField { (nameField) in
      nameField?.placeholder = "Enter list name"
      nameField?.font = Stylesheet.uiElementFont(for: .textField)
      let heightConstraint = NSLayoutConstraint(item: nameField!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 35.0)
      nameField?.addConstraint(heightConstraint)
      nameField?.becomeFirstResponder()
    }
    let doneAction = PMAlertAction(title: "DONE", style: .default, action: {
      guard let text = controller.textFields[0].text, text.isEmpty == false else {
        controller.dismiss(animated: true, completion: nil)
        return
      }
      DataStore()?.save(object: List(name: text), andRun: nil)
      completion()
      controller.dismiss(animated: true, completion: nil)
    })
    let cancelAction = PMAlertAction(title: "Cancel", style: .cancel) {
      controller.dismiss(animated: true, completion: nil)
    }
    
    // styling
    controller.alertView.backgroundColor = Stylesheet.getColor(.white)
    controller.alertTitle.font = Stylesheet.uiElementFont(for: .alertTitle)
    controller.alertTitle.textColor = Stylesheet.getColor(.black)
    for field in controller.textFields {
      field.font = Stylesheet.userContentFont(for: .userInput)
      field.textColor = Stylesheet.getColor(.primary)
    }
    controller.gravityDismissAnimation = false
    controller.dismissWithBackgroudTouch = true
    controller.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    doneAction.titleLabel?.font = Stylesheet.uiElementFont(for: .buttonLabel)
    cancelAction.titleLabel?.font = Stylesheet.uiElementFont(for: .buttonLabel)
    doneAction.setTitleColor(Stylesheet.getColor(.primary), for: .normal)
    
    controller.addAction(doneAction)
    controller.addAction(cancelAction)
    
    return controller
  }
  
  static func editTitle(of list: List, completion: @escaping () -> ()) -> PMAlertController {
    let controller = PMAlertController(title: "Edit List Title", description: "", image: nil, style: .alert)
    controller.addTextField { (nameField) in
      nameField?.placeholder = list.name
      nameField?.font = Stylesheet.uiElementFont(for: .textField)
      let heightConstraint = NSLayoutConstraint(item: nameField!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 35.0)
      nameField?.addConstraint(heightConstraint)
      nameField?.becomeFirstResponder()
    }
    let doneAction = PMAlertAction(title: "DONE", style: .default) {
      guard let text = controller.textFields[0].text, text.isEmpty == false else {
        controller.dismiss(animated: true, completion: nil)
        return
      }
      DataStore()?.run {
        list.name = text
      }
      completion()
      controller.dismiss(animated: true, completion: nil)
    }
    let cancelAction = PMAlertAction(title: "Cancel", style: .cancel) {
      controller.dismiss(animated: true, completion: nil)
    }
    
    // Styling
    controller.alertView.backgroundColor = Stylesheet.getColor(.white)
    controller.alertTitle.font = Stylesheet.uiElementFont(for: .alertTitle)
    controller.alertTitle.textColor = Stylesheet.getColor(.black)
    for field in controller.textFields {
      field.font = Stylesheet.userContentFont(for: .userInput)
      field.textColor = Stylesheet.getColor(.primary)
    }
    controller.gravityDismissAnimation = false
    controller.dismissWithBackgroudTouch = true
    controller.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    doneAction.titleLabel?.font = Stylesheet.uiElementFont(for: .buttonLabel)
    cancelAction.titleLabel?.font = Stylesheet.uiElementFont(for: .buttonLabel)
    doneAction.setTitleColor(Stylesheet.getColor(.primary), for: .normal)
    
    controller.addAction(doneAction)
    controller.addAction(cancelAction)
    
    return controller
  }
  
}
