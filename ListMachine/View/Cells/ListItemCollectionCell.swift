//
//  ListItemCollectionCell.swift
//  ListMachine
//
//  Created by Drew Lanning on 1/5/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class ListItemCollectionCell: UICollectionViewCell {
  
  @IBOutlet weak var valueLbl: UILabel!
  @IBOutlet weak var fieldTitleLbl: UILabel!
  @IBOutlet weak var booleanBtn: BooleanFieldBtn!
  var closure: (() -> ())?
  
  func configure(withValue value: String, andTitle title: String, forType type: FieldType, runOnTap closure: (() -> ())?) {
    if type == .checkBox {
      valueLbl.isHidden = true
      booleanBtn.isHidden = false
      booleanBtn.configure(as: Bool(value) ?? false)
    } else {
      booleanBtn.isHidden = true
      valueLbl.isHidden = false
      if type == .dateAndTime {
        let date = Stylesheet.dateAndTime(from: value)
        valueLbl.text = Stylesheet.labelDateAndTimeString(from: date) ?? "No date"
      } else {
        valueLbl.text = value
      }
    }
    fieldTitleLbl.text = title
    self.closure = closure
    styleViews()
  }
  
  func styleViews() {
    valueLbl.textColor = Stylesheet.getColor(.primary)
    valueLbl.font = Stylesheet.userContentFont(for: .itemCollectionCellData)
    fieldTitleLbl.font = Stylesheet.userContentFont(for: .itemCollectionCellTitle)
    fieldTitleLbl.textColor = Stylesheet.getColor(.primary)
    backgroundColor = .clear
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  @IBAction func buttonTapped(sender: BooleanFieldBtn) {
    closure?()
  }
}
