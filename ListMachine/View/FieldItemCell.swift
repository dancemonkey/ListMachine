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
    case .date:
      valueView = UIButton() // SUBCLASS THIS
      (valueView as! UIButton).setTitle(value ?? "Select Date", for: .normal)
    case .memo:
      valueView = UITextView()
      (valueView as! UITextView).text = value ?? ""
    case .text:
      valueView = UITextField()
      (valueView as! UITextField).text = value ?? ""
    case .number:
      valueView = UITextField()
      (valueView as! UITextField).text = value ?? ""
      (valueView as! UITextField).keyboardType = .numberPad
    default:
      valueView = nil
      valueView?.isHidden = true
    }
    if valueView != nil {
      // using magic numbers for now until I know what the values should be
      valueView!.backgroundColor = .yellow
      valueView!.isUserInteractionEnabled = true
      self.addSubview(valueView!)
      
      valueView!.translatesAutoresizingMaskIntoConstraints = false
      title.translatesAutoresizingMaskIntoConstraints = false
      
      let views = ["valueView": valueView!, "title": title]
      let hFormat = "[title]-[valueView]-16-|"
      let vFormat = "V:|-[valueView]-|"
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
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    if let view = (valueView as? CheckboxButton) {
      print("touched")
      view.setChecked(true)
    }
  }
  
}
