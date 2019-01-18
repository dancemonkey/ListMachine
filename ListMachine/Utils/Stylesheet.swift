//
//  Stylesheet.swift
//  ListMachine
//
//  Created by Drew Lanning on 1/3/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import Foundation

struct Stylesheet {
  
  static private var simpleDateFormatter: DateFormatter {
    get {
      let formatter = DateFormatter()
      formatter.dateFormat = "EEEE, MMM d"
      return formatter
    }
  }
  
  static func simpleDateString(fromDate date: Date?) -> String? {
    guard let d = date else { return nil }
    return simpleDateFormatter.string(from: d)
  }
  
  static func simpleDate(fromString string: String?) -> Date? {
    guard let s = string else { return nil }
    return simpleDateFormatter.date(from: s)
  }
  
  static private var dateAndTimeFormatter: DateFormatter {
    get {
      let formatter = DateFormatter()
      formatter.dateFormat = "EEEE, MMM d, h:mm a"
      return formatter
    }
  }
  
  static func dateAndTimeString(from date: Date?) -> String? {
    guard let d = date else { return nil }
    return dateAndTimeFormatter.string(from: d)
  }
  
  static func dateAndTime(from string: String?) -> Date? {
    guard let s = string else { return nil }
    return dateAndTimeFormatter.date(from: s)
  }
    
}
