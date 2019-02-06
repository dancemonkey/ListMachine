//
//  LastUpdatedLabel.swift
//  ListMachine
//
//  Created by Drew Lanning on 2/6/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class LastUpdatedLabel: UILabel {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    textColor = Stylesheet.getColor(.primary).withAlphaComponent(0.8)
    font = Stylesheet.userContentFont(for: .itemCollectionCellTitle)
  }

  func setLastUpdated(with date: Date?) {
    if let lastDate = date {
      self.text = "Last Updated: \(Stylesheet.dateAndTimeString(from: lastDate)!)"
    } else {
      self.text = "Last Updated: never"
    }
  }

}
