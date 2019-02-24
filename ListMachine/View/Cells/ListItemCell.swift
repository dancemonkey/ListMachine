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
  @IBOutlet weak var collection: UICollectionView!
  @IBOutlet weak var heroBackground: UIView!
  @IBOutlet weak var booleanBtn: BooleanFieldBtn!
  
  var buttonTapAction: (() -> ())? = nil
  
  func configure(withItem item: Item, withAction action: (() -> ())?) {
    if let type = FieldType(rawValue: item.itemFields[0].type), type == .checkBox {
      booleanBtn.isHidden = false
      booleanBtn.configure(as: Bool(item.itemListTitle) ?? false)
      titleLbl.text = ""//item.itemFields[0].name
      self.buttonTapAction = action
    } else {
      booleanBtn.isHidden = true
      titleLbl.text = item.itemListTitle
    }
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
    self.backgroundColor = .white
    selectionStyle = .none
  }
  
  func setHeroId(for row: Int) {
    titleLbl.hero.id = "\(HeroIDs.navTitle.rawValue)\(row)"
    heroBackground.hero.id = "\(HeroIDs.itemTableCell.rawValue)\(row)"
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
  
  @IBAction func buttonTapped() {
    buttonTapAction?()
  }
}

