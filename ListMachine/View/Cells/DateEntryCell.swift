//
//  DateEntryCell.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/27/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class DateEntryCell: UITableViewCell {
  
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var dateBtn: UIButton!
  
  func configure(with field: ItemField) {
    self.title.text = field.name
    self.dateBtn.setTitle(field.value ?? "No Date", for: .normal)
    styleViews()
  }
  
  func styleViews() {
    self.backgroundColor = .clear
    selectionStyle = .none
  }
  
  @IBAction func dateButtnPressed(sender: UIButton) {
    // set saveDate delegate as self
    // show date select screen
    // upon return save selected date as dateBtn title
    print("going to select a date yay!")
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
