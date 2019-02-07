//
//  TemplateFieldCell.swift
//  ListMachine
//
//  Created by Drew Lanning on 1/27/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class TemplateFieldCell: UITableViewCell {
  
  @IBOutlet weak var titleLbl: UILabel!
  @IBOutlet weak var typeLbl: UILabel!
  
  func configure(with field: ItemField) {
    self.titleLbl.text = field.name
    self.typeLbl.text = (FieldType(rawValue: field.type) ?? FieldType.noType).getTitle()
    styleViews()
  }
  
  func styleViews() {
    titleLbl.font = Stylesheet.userContentFont(for: .templateFieldListTitle)
    typeLbl.font = Stylesheet.userContentFont(for: .templateFieldListType)
    titleLbl.textColor = Stylesheet.getColor(.black)
    typeLbl.textColor = Stylesheet.getColor(.black)
    self.backgroundColor = .clear
    self.contentView.backgroundColor = .clear
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
