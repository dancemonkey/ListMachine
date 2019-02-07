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
  @IBOutlet weak var listInfoLbl: UILabel!
  @IBOutlet weak var lastUpdatedLbl: LastUpdatedLabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
//    styleViews()
  }
  
  func styleViews() {
    listNameLbl.font = Stylesheet.userContentFont(for: .mainListCell)
    listNameLbl.textColor = Stylesheet.getColor(.black)
    listInfoLbl.font = Stylesheet.userContentFont(for: .mainListInfo)
    listInfoLbl.textColor = Stylesheet.getColor(.black)
    backgroundColor = .clear
    selectionStyle = .none
  }
  
  func configure(with list: List?) {
    listNameLbl.text = list!.name
    listInfoLbl.text = "\(list!.listedItems.count) items"
    lastUpdatedLbl.setLastUpdated(with: list?.lastUpdated)
    styleViews()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
