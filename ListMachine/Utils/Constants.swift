//
//  Constants.swift
//  ListMachine
//
//  Created by Drew Lanning on 2/15/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import Foundation
import Hero

enum UserDefaultKeys: String {
  case reviewRequestedDate
  case reviewRequested
}

enum ReviewRequestInterval: Int {
  case firstRequest = 5
}

enum HeroIDs: String {
  case listEditPopup
  case editTemplateButton
  case newItemButton
  case navTitle
  case templateNameField
  case templateTypePicker
  case hiddenFieldTypeLabel
  case mainTableCell
  case itemTableCell
}
