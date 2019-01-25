//
//  MasterListCell.swift
//  ListMachine
//
//  Created by Drew Lanning on 1/7/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class MasterListCell: UITableViewCell {
  
  @IBOutlet weak var listNameLbl: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    styleViews()
  }
  
  func styleViews() {
    listNameLbl.font = Stylesheet.userContentFont(for: .mainListCell)
    listNameLbl.textColor = Stylesheet.getColor(.primary)
    backgroundColor = .clear
  }
  
  func configure(with list: List?) {
    listNameLbl.text = list?.name ?? "No List"
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
