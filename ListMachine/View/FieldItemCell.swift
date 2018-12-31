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
  var valueView: UIView?
  
  func configure(withField field: ItemField, andValue value: String?) {
    title.text = field.name
    let type = FieldType(rawValue: field.type) ?? .noType
    switch type {
    case .checkBox:
      valueView = ItemFieldSwitch(with: field, and: value)
      (valueView as! ItemFieldSwitch).addTarget(self, action: #selector(switched(_:)), for: .valueChanged)
    case .date:
      valueView = ItemFieldButton(with: field, and: value)
      (valueView as! UIButton).addTarget(self, action: #selector(dateButtonPressed(_:)), for: .touchUpInside)
    case .memo:
      valueView = ItemFieldTextView(with: field, and: value)
    case .text, .number:
      valueView = ItemFieldTextField(with: field, and: value)
    default:
      valueView = nil
      valueView?.isHidden = true
    }
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
  
  @objc func switched(_ sender: UISwitch) {
    // change value in model
  }
  
  @objc func dateButtonPressed(_ sender: UIButton) {
    // show date picker and save back to model
  }
  
}
