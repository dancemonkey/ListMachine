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
    self.setTitleTextAttributes([NSAttributedString.Key.font : Stylesheet.uiElementFont(for: .segmentItem)], for: .normal)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let currentIndex = selectedSegmentIndex
    super.touchesBegan(touches, with: event)
    
    if currentIndex == selectedSegmentIndex {
      sendActions(for: .touchDown)
    }
  }

}
