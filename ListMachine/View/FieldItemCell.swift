//
//  FieldItemCell.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/28/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class FieldItemCell: UITableViewCell {

  @IBOutlet weak var title: UILabel!
  var valueView: FieldItemCellValueView?
  var textFieldDelegate: UITextFieldDelegate?
  var textViewDelegate: UITextViewDelegate?
  
  func configure(withField field: ItemField, andValue value: String?, closure save: @escaping (String) -> ()) {
    title.text = field.name
    let type = FieldType(rawValue: field.type) ?? .noType
    valueView = FieldItemCellValueView(as: field, with: value)
    valueView!.save = save
    if valueView != nil {
      self.addSubview(valueView!)
      valueView!.isUserInteractionEnabled = true
      setConstraints(for: type)
    }
  }
  
  func setConstraints(for type: FieldType) {
    valueView!.translatesAutoresizingMaskIntoConstraints = false
    title.translatesAutoresizingMaskIntoConstraints = false
    
    let views: [String: Any] = ["valueView": valueView!, "title": title]
    let hFormat = VFLConstraints(type: type).horizontalVFL
    let vFormat = VFLConstraints(type: type).verticalVFL
    let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: hFormat, options: .alignAllCenterY, metrics: nil, views: views)
    let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: vFormat, options: [], metrics: nil, views: views)
    var allConstraints: [NSLayoutConstraint] = []
    allConstraints = allConstraints + hConstraints
    allConstraints = allConstraints + vConstraints
    if type == .memo {
      let memoTitleConstraint = "|-[valueView]-|"
      allConstraints = allConstraints + NSLayoutConstraint.constraints(withVisualFormat: memoTitleConstraint, options: [], metrics: nil, views: views)
    }
    NSLayoutConstraint.activate(allConstraints)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    valueView?.removeFromSuperview()
    valueView = nil
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  @objc func switched(_ sender: ItemFieldSwitch) {
    sender.save!(sender.isOn.description)
  }
  
  @objc func dateButtonPressed(_ sender: UIButton) {
    // show date picker and save back to model
    // date picker can call existing delegate function to save date to item
  }
}

extension FieldItemCell: UITextViewDelegate {
  func textViewDidEndEditing(_ textView: UITextView) {
    valueView?.save!(valueView!.getSubviewValue)
    print("saved text view text")
  }
}

extension FieldItemCell: UITextFieldDelegate {
  func textFieldDidEndEditing(_ textField: UITextField) {
    valueView?.save!(valueView!.getSubviewValue)
    print("saved text field text")
  }
}
