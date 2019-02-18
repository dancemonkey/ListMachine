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
  var fieldSave: ((_: String) -> ())?
  
  func configure(withField field: ItemField, andValue value: String?) {
    title.text = field.name
    let type = FieldType(rawValue: field.type) ?? .noType
    valueView = FieldItemCellValueView(as: field, with: value)
    if valueView != nil {
      valueView?.fieldSave = self.fieldSave
      valueView?.assignSaveAction(for: type)
      self.addSubview(valueView!)
      valueView!.isUserInteractionEnabled = true
      setConstraints(for: type)
//      if type == .text {
//        addDoneAccessory(to: valueView!.textField)
//      } else if type == .memo {
//        addDoneAccessory(to: valueView!.textView)
//      }
    }
    styleViews()
  }
  
  func styleViews() {
    self.backgroundColor = .white
    title.font = Stylesheet.userContentFont(for: .itemEntryFieldTitle)
    title.textColor = Stylesheet.getColor(.black)
    selectionStyle = .none
  }
  
  func setConstraints(for type: FieldType) {
    valueView!.translatesAutoresizingMaskIntoConstraints = false
    title.translatesAutoresizingMaskIntoConstraints = false
    
    let views: [String: Any] = ["valueView": valueView!, "title": title]
    let hFormat = FieldTypeConstraints(type: type).horizontal
    let vFormat = FieldTypeConstraints(type: type).vertical
    let titleHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[title]-|", options: [], metrics: nil, views: views)
    let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: hFormat, options: .alignAllCenterY, metrics: nil, views: views)
    let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: vFormat, options: [], metrics: nil, views: views)
    var allConstraints: [NSLayoutConstraint] = []
    allConstraints = allConstraints + titleHConstraints + hConstraints + vConstraints
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
  
  func configureAction(for type: FieldType, with delegate: SegueDelegate) {
    if let segueID = type.getSegueID() {
      valueView?.configureButtonAction(for: segueID, and: delegate)
    }
  }
  
  func addDoneAccessory(to textField: UITextField?) {
    let toolbar: UIToolbar = UIToolbar()
    toolbar.sizeToFit()
    var items = [UIBarButtonItem]()
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: textField, action: #selector(textField?.endEditing))
    let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    items.append(contentsOf: [spacer, doneButton])
    toolbar.setItems(items, animated: false)
    textField?.inputAccessoryView = toolbar
  }
  
  func addDoneAccessory(to textView: UITextView?) {
    let toolbar: UIToolbar = UIToolbar()
    toolbar.sizeToFit()
    var items = [UIBarButtonItem]()
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: textView, action: #selector(textView?.endEditing))
    let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    items.append(contentsOf: [spacer, doneButton])
    toolbar.setItems(items, animated: false)
    textView?.inputAccessoryView = toolbar
  }
}
