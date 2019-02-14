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

