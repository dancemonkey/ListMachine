//
//  FieldItemButton.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/31/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class ItemFieldButton: UIButton, CustomFieldUIViewProtocol {

//  var save: ((String) -> ())?
  var segueDelegate: SegueProtocol?
  var segueID: SegueID? {
    didSet {
      self.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
    }
  }
  var reportValue: String {
    return self.titleLabel?.text ?? ""
  }

  internal func configure(with field: ItemField, and value: String?) {
    if value != nil && value != "" {
      self.setTitle(value!, for: .normal)
    } else {
      self.setTitle("Select Date", for: .normal)
    }
    self.setTitleColor(.blue, for: .normal)
    self.setTitleColor(.gray, for: .highlighted)
  }
  
  @objc private func buttonTapped(sender: UIButton) {
    segueDelegate?.segueRequested(to: self.segueID)
  }

}
