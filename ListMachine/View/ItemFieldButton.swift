//
//  FieldItemButton.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/31/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class ItemFieldButton: UIButton, CustomFieldUIViewProtocol {
  
  enum DateFormat {
    case simpleDate, dateAndTime
  }
  
  var segueDelegate: SegueDelegate?
  var segueID: SegueID? {
    didSet {
      self.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
    }
  }
  var reportValue: String {
    return self.titleLabel?.text ?? ""
  }
  var format: DateFormat?
  
  internal func configure(with field: ItemField, and value: String?) {
    guard value != nil && value != "" else {
      self.setTitle("Select Date", for: .normal)
      return
    }
    
    switch FieldType(rawValue: field.type)! {
    case .dateAndTime:
      self.format = DateFormat.dateAndTime
    case .date:
      self.format = DateFormat.simpleDate
    default: break
    }
    
    self.setTitle(value!, for: .normal)
    self.setTitleColor(.blue, for: .normal)
    self.setTitleColor(.gray, for: .highlighted)
  }
  
  @objc private func buttonTapped(sender: UIButton) {
    segueDelegate?.segueRequested(to: self.segueID, sender: self)
  }
}

extension ItemFieldButton: SegueSenderDelegate {
  func receivePayload(_ value: Date) {
    guard let format = self.format else {
      let title = Stylesheet.simpleDateString(fromDate: value)
      self.setTitle(title, for: .normal)
      return
    }
    switch format {
    case .dateAndTime:
      let title = Stylesheet.dateAndTimeString(from: value)
      self.setTitle(title, for: .normal)
    case .simpleDate:
      let title = Stylesheet.simpleDateString(fromDate: value)
      self.setTitle(title, for: .normal)
    }
  }
}
