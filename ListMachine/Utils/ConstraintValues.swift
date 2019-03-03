//
//  ConstraintValues.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/28/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import Foundation

struct ListItemCellConstraints {
  var horizontal: String {
    return "|[view]|"
  }
  var vertical: String {
    return "V:|[view]|"
  }
}

struct FieldTypeConstraints {
  var type: FieldType
  
  var horizontal: String {
    switch type {
    case .number, .text, .date, .dateAndTime, .checkBox, .memo:
      return "|-16-[valueView]-16-|"
    default:
      return "|-16-[valueView]-16-|"
    }
  }
  
  var vertical: String {
    switch type {
    case .checkBox, .date, .number, .text, .dateAndTime:
      return "V:|-8-[title]-8-[valueView(45)]-8-|"
    case .memo:
      return "V:|-8-[title]-8-[valueView(200)]-8-|"
    default:
      return "V:|-8-[title]-8-[valueView(45)]-8-|"
    }
  }
}
