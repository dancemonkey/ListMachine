//
//  SortSelectControl.swift
//  ListMachine
//
//  Created by Drew Lanning on 1/28/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class SortSelectControl: UISegmentedControl {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.tintColor = Stylesheet.getColor(.primary)
  }

}
