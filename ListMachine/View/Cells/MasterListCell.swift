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
  @IBOutlet weak var heroBackground: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func styleViews() {
    listNameLbl.font = Stylesheet.userContentFont(for: .mainListCell)
    listNameLbl.textColor = Stylesheet.getColor(.black)
    listInfoLbl.font = Stylesheet.userContentFont(for: .mainListInfo)
    listInfoLbl.textColor = Stylesheet.getColor(.black)
    backgroundColor = .clear
    selectionStyle = .none
    heroBackground.layer.borderWidth = 0.5
    heroBackground.layer.borderColor = Stylesheet.getColor(.accent).cgColor
    heroBackground.layer.cornerRadius = 4
  }
  
  func configure(with list: List?) {
    listNameLbl.text = list!.name
    listInfoLbl.text = "\(list!.listedItems.count) items"
    lastUpdatedLbl.setLastUpdated(with: list?.lastUpdated)
    styleViews()
  }
  
  func setHeroId(for row: Int) {
    listNameLbl.hero.id = "\(HeroIDs.navTitle.rawValue)\(row)"
    heroBackground.hero.id = "\(HeroIDs.mainTableCell.rawValue)\(row)"
  }
}
