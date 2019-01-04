//
//  ListItemCell.swift
//  ListMachine
//
//  Created by Drew Lanning on 1/4/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class ListItemCell: UITableViewCell {
  
  @IBOutlet private weak var collection: UICollectionView!
  
  func configure(withItem item: Item) {
//    let label = UILabel()
//    label.text = item.itemFields[0].value ?? "No Value for \(item.itemFields[0].name)"
//    self.addSubview(label)
  }
  
  func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int) {
    collection.delegate = dataSourceDelegate
    collection.dataSource = dataSourceDelegate
    collection.tag = row
    collection.reloadData()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: CellID.listItemCollectionCell.rawValue)
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
}

