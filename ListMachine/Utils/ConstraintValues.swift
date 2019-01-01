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
      return "|-[title]-[valueView]-16-|"
    case .number, .text, .date:
      return "|-[title]-[valueView]-16-|"
    case .memo:
      return "|-[title]"
    default:
      return "|-[title]-[valueView]-16-|"
    }
  }
  var verticalVFL: String {
    switch type {
    case .checkBox, .date, .number, .text:
      return "V:|-4@250-[valueView(45@1000)]-4@250-|"
    case .memo:
      return "V:|-[title]-[valueView]-|"
    default:
      return "V:[valueView(45)]"
    }
  }
}
