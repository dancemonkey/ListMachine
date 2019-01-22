//
//  TextFieldInputExtension.swift
//  ListMachine
//
//  Created by Drew Lanning on 1/8/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

extension UIViewController {
  func addInputAccessoryForTextFields(textFields: [UITextField]?, textViews: [UITextView]?) {
    if let tf = textFields {
      for field in tf {
        let toolbar: UIToolbar = UIToolbar()
        toolbar.sizeToFit()
        
        var items = [UIBarButtonItem]()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: view, action: #selector(UIView.endEditing))
        items.append(contentsOf: [doneButton])
        
        
        toolbar.setItems(items, animated: false)
        field.inputAccessoryView = toolbar
      }
    }
    if let tv = textViews {
      for textView in tv {
        let toolbar: UIToolbar = UIToolbar()
        toolbar.sizeToFit()
        
        var items = [UIBarButtonItem]()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: view, action: #selector(UIView.endEditing))
        items.append(contentsOf: [doneButton])
        
        toolbar.setItems(items, animated: false)
        textView.inputAccessoryView = toolbar
      }
    }
  }
}
