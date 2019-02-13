//
//  ListItemCell.swift
//  ListMachine
//
//  Created by Drew Lanning on 1/4/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class ListItemCell: UITableViewCell {
  
  @IBOutlet weak var titleLbl: UILabel!
  @IBOutlet weak var lastUpdatedLbl: LastUpdatedLabel!
  @IBOutlet weak var collection: UICollectionView!
  
  func configure(withItem item: Item) {
    titleLbl.text = item.itemListTitle
    lastUpdatedLbl.setLastUpdated(with: item.lastUpdated)
    styleViews()
  }
  
  func setCollectionViewDataSourceDelegate(delegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int) {
    collection.delegate = delegate
    collection.dataSource = delegate
    collection.tag = row
    collection.reloadData()
  }
  
  func styleViews() {
    titleLbl.font = Stylesheet.userContentFont(for: .itemListCellTitle)
    titleLbl.textColor = Stylesheet.getColor(.black)
    self.backgroundColor = .clear
    selectionStyle = .none
    
    // temp adding top border
//    let border = CALayer()
//    border.frame = CGRect(x: 0, y: 0, width: collection.layer.frame.width, height: 0.5)
//    border.backgroundColor = Stylesheet.getColor(.accent).withAlphaComponent(0.3).cgColor //UIColor.black.withAlphaComponent(0.2).cgColor
//    collection.layer.addSublayer(border)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
  }
}

