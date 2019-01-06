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
  
  func configure(withValue value: String, andTitle title: String) {
    valueLbl.text = value
    fieldTitleLbl.text = title
  }
}
