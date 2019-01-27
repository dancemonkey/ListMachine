//
//  FieldItemCellValueView.swift
//  ListMachine
//
//  Created by Drew Lanning on 1/1/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class FieldItemCellValueView: UIView {
  
  var switchSubview: ItemFieldSwitch?
  var buttonSubview: ItemFieldButton?
  var textView: ItemFieldTextView?
  var textField: ItemFieldTextField?
  var getSubviewValue: String {
    if switchSubview != nil {
      return switchSubview!.reportValue
    } else if buttonSubview != nil {
      return buttonSubview!.reportValue
    } else if textView != nil {
      return textView!.reportValue
    } else {
      return textField!.reportValue
    }
  }
  var fieldSave: ((_: String) -> ())? {
    didSet {
      print("closure set in FieldItemCellValueView")
    }
  }

  convenience init?(as field: ItemField, with value: String?) {
    self.init()
    let type = FieldType(rawValue: field.type) ?? .noType
    switch type {
    case .checkBox:
      switchSubview = ItemFieldSwitch(with: field, and: value)
      self.addSubview(switchSubview!)
    case .date, .dateAndTime:
      buttonSubview = ItemFieldButton(with: field, and: value)
      self.addSubview(buttonSubview!)
    case .memo:
      textView = ItemFieldTextView(with: field, and: value)
      self.addSubview(textView!)
    case .number, .text:
      textField = ItemFieldTextField(with: field, and: value)
      self.addSubview(textField!)
    default:
      return nil
    }
    setConstraints(for: type)
  }
  
  func assignSaveAction(for type: FieldType) {
    switch type {
    case .checkBox:
      switchSubview?.addTarget(self, action: #selector(saveField), for: .valueChanged)
    case .date, .dateAndTime:
      buttonSubview?.fieldSave = self.fieldSave
    case .memo:
      textView?.fieldSave = self.fieldSave
    case .number, .text:
      textField?.fieldSave = self.fieldSave
    case .noType:
      print("no type for this field we're screwed")
    }
  }
  
  func styleViews() {
    self.backgroundColor = .clear
  }
  
  @objc func saveField() {
    let workingView: CustomFieldUIViewProtocol
    if switchSubview != nil {
      workingView = switchSubview!
    } else if buttonSubview != nil {
      workingView = buttonSubview!
    } else if textView != nil {
      workingView = textView!
    } else {
      workingView = textField!
    }
    if let save = fieldSave {
      save(workingView.reportValue)
      print("value saved from valueView")
    }
  }
  
  func setConstraints(for type: FieldType) {
    var workingView: UIView
    if switchSubview != nil {
      workingView = switchSubview!
    } else if buttonSubview != nil {
      workingView = buttonSubview!
    } else if textView != nil {
      workingView = textView!
    } else {
      workingView = textField!
    }
    
    workingView.translatesAutoresizingMaskIntoConstraints = false
    let views: [String: Any] = ["workingView": workingView]
    let hFormat = "|[workingView]|"
    var vFormat = "V:|[workingView(45@1000)]|"
    if type == .memo {
      vFormat = "V:|[workingView]|"
    }
    let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: hFormat, options: .alignAllCenterY, metrics: nil, views: views)
    let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: vFormat, options: [], metrics: nil, views: views)
    var allConstraints: [NSLayoutConstraint] = []
    allConstraints = allConstraints + hConstraints
    allConstraints = allConstraints + vConstraints
    NSLayoutConstraint.activate(allConstraints)
  }
  
  func configureButtonAction(for segueID: SegueID, and delegate: SegueDelegate) {
    if buttonSubview != nil {
      buttonSubview?.segueID = segueID
      buttonSubview?.segueDelegate = delegate
    }
  }
}
