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
      valueView = CheckboxButton()
      (valueView as! CheckboxButton).setChecked(Bool(value ?? "false")!)
      (valueView as! CheckboxButton).isUserInteractionEnabled = true
      (valueView as! CheckboxButton).addTarget(self, action: #selector(checkboxBtnPressed(_:)), for: .touchDown)
      self.addSubview(valueView as! CheckboxButton)
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
      self.addSubview(valueView as! UITextView)
    case .text:
      valueView = UITextField()
      (valueView as! UITextField).text = value ?? ""
      self.addSubview(valueView as! UITextField)
    case .number:
      valueView = UITextField()
      (valueView as! UITextField).text = value ?? ""
      (valueView as! UITextField).keyboardType = .numberPad
      self.addSubview(valueView as! UITextField)
    default:
      valueView = nil
      valueView?.isHidden = true
    }
    if valueView != nil {
      // using magic numbers for now until I know what the values should be
      valueView!.isUserInteractionEnabled = true
      
      valueView!.translatesAutoresizingMaskIntoConstraints = false
      title.translatesAutoresizingMaskIntoConstraints = false
      
      let views = ["valueView": valueView!, "title": title]
      let hFormat = VFLConstraints(type: type).horizontalVFL  //"[title]-[valueView]-16-|"
      let vFormat = VFLConstraints(type: type).verticalVFL    //"V:|-[valueView]-|"
      let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: hFormat, options: .alignAllCenterY, metrics: nil, views: views)
      let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: vFormat, options: .alignAllCenterY, metrics: nil, views: views)
      var allConstraints: [NSLayoutConstraint] = []
      allConstraints = allConstraints + hConstraints
      allConstraints = allConstraints + vConstraints
      NSLayoutConstraint.activate(allConstraints)
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    valueView?.isHidden = false
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  @objc func checkboxBtnPressed(_ sender: CheckboxButton) {
    print("button pressed")
    sender.setChecked(true)
  }
  
}
