//
//  NumberEntryCell.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/27/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class NumberEntryCell: UITableViewCell {
  
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var textField: UITextField!
  
  func configure(with field: ItemField) {
    self.title.text = field.name
    self.textField.text = field.value ?? ""
    textField.keyboardType = .numberPad
    styleViews()
  }
  
  func styleViews() {
    self.backgroundColor = .clear
    selectionStyle = .none
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
