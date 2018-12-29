//
//  ConstraintValues.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/28/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import Foundation

struct VFLConstraints {
  var type: FieldType
  var horizontalVFL: String {
    switch type {
    case .checkBox:
      return "[title]-[valueView(45@1000)]-16-|"
    case .number, .text, .memo, .date:
      return "[title]-[valueView]-16-|"
    default:
      return "[title]-[valueView]-16-|"
    }
  }
  var verticalVFL: String {
    switch type {
    case .memo, .checkBox, .date, .number, .text:
      return "V:[valueView(45@1000)]"
    default:
      return "V:[valueView(45)]"
    }
  }
}
