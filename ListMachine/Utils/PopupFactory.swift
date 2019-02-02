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
  
  static func newPmAlert(completion: @escaping () -> ()) -> PMAlertController {
    let controller = PMAlertController(title: "Name your list", description: "", image: nil, style: .alert)
    controller.addTextField { (nameField) in
      nameField?.placeholder = "Enter list name"
      nameField?.font = Stylesheet.uiElementFont(for: .textField)
      let heightConstraint = NSLayoutConstraint(item: nameField!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 35.0)
      nameField?.addConstraint(heightConstraint)
    }
    let doneAction = PMAlertAction(title: "DONE", style: .default, action: {
      guard let text = controller.textFields[0].text else {
        controller.dismiss(animated: true, completion: nil)
        return
      }
      DataStore()?.save(object: List(name: text), andRun: nil)
      completion()
      controller.dismiss(animated: true, completion: nil)
    })
    
    // styling
    doneAction.titleLabel?.font = Stylesheet.uiElementFont(for: .buttonLabel)
    doneAction.titleLabel?.textColor = Stylesheet.getColor(.black)
    controller.alertView.backgroundColor = Stylesheet.getColor(.white)
    controller.alertTitle.font = Stylesheet.uiElementFont(for: .alertTitle)
    controller.alertTitle.textColor = Stylesheet.getColor(.black)
    for field in controller.textFields {
      field.font = Stylesheet.uiElementFont(for: .textField)
      field.textColor = Stylesheet.getColor(.black)
    }
    controller.addAction(doneAction)
    controller.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: {
      controller.dismiss(animated: true, completion: nil)
    }))
    return controller
  }
  
//  internal func style(popup: PMAlertController) {
//    popup.view.backgroundColor = Stylesheet.getColor(.white)
//    popup.alertTitle.font = Stylesheet.uiElementFont(for: .alertTitle)
//    for field in popup.textFields {
//      field.font = Stylesheet.uiElementFont(for: .textField)
//      field.textColor = Stylesheet.getColor(.black)
//    }
//  }
  
//  static func newListNamePopup(completion: @escaping () -> ()) -> NewListNameAlert {
//    let controller = NewListNameAlert(title: "Name your list", message: nil, preferredStyle: .alert)
//    controller.addTextField { (nameField) in
//      nameField.placeholder = "Enter list name"
//      nameField.font = Stylesheet.uiElementFont(for: .textField)
//      let heightConstraint = NSLayoutConstraint(item: nameField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 35.0)
//      nameField.addConstraint(heightConstraint)
//    }
//
//    let doneAction = UIAlertAction(title: "DONE", style: .default) { (action) in
//      guard let text = controller.textFields![0].text else {
//        controller.dismiss(animated: true, completion: nil)
//        return
//      }
//      DataStore()?.save(object: List(name: text), andRun: nil)
//      completion()
//      controller.dismiss(animated: true, completion: nil)
//    }
//    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
//      controller.dismiss(animated: true, completion: nil)
//    }
//
//    controller.addAction(doneAction)
//    controller.addAction(cancelAction)
//    controller.modalPresentationStyle = .overFullScreen
//    controller.modalPresentationCapturesStatusBarAppearance = true
//    controller.setNeedsStatusBarAppearanceUpdate()
//
//    return controller
//  }
  
}
