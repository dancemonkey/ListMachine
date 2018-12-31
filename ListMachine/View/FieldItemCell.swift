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
      valueView = UISwitch()
      let checked: Bool? = Bool(value ?? "false")
      (valueView as! UISwitch).isOn = checked ?? false
      (valueView as! UISwitch).isUserInteractionEnabled = true
      (valueView as! UISwitch).addTarget(self, action: #selector(switched(_:)), for: .valueChanged)
      self.addSubview(valueView as! UISwitch)
    case .date:
      valueView = UIButton() // SUBCLASS THIS
      if value != nil && value != "" {
        (valueView as! UIButton).setTitle(value!, for: .normal)
      } else {
        (valueView as! UIButton).setTitle("Select Date", for: .normal)
      }
      (valueView as! UIButton).isUserInteractionEnabled = true
      (valueView as! UIButton).setTitleColor(.blue, for: .normal)
      (valueView as! UIButton).setTitleColor(.gray, for: .highlighted)
      self.addSubview(valueView as! UIButton)
    case .memo:
      valueView = UITextView()
      (valueView as! UITextView).text = value ?? ""
      (valueView as! UITextView).backgroundColor = .lightGray
      self.addSubview(valueView as! UITextView)
    case .text, .number:
      valueView = UITextField()
      (valueView as! UITextField).text = value ?? ""
      (valueView as! UITextField).borderStyle = .roundedRect
      if type == .number {
        (valueView as! UITextField).keyboardType = .numberPad
      }
      self.addSubview(valueView as! UITextField)
    default:
      valueView = nil
      valueView?.isHidden = true
    }
    if valueView != nil {
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
  
}
