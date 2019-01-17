//
//  FieldType.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/29/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

enum FieldType: String {
  case text, memo, number, date, dateAndTime, checkBox, noType
  
  func getSegueID() -> SegueID? {
    switch self {
    case .date, .dateAndTime:
      return .showDatePicker
    default:
      return nil
    }
  }
}
