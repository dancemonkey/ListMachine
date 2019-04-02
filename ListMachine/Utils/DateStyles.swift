//
//  DateStyles.swift
//  ListMachine
//
//  Created by Drew Lanning on 3/3/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import Foundation

struct DateStyles {
  
  // MARK: Simple Date
  static private var labelDateFormatter: DateFormatter {
    get {
      let formatter = DateFormatter()
      formatter.setLocalizedDateFormatFromTemplate("E, MMM d, yyyy")
      return formatter
    }
  }
  
  static private var simpleDateFormatter: DateFormatter {
    get {
      let formatter = DateFormatter()
      formatter.setLocalizedDateFormatFromTemplate("MM/dd/yy")
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
  
  static func labelDateString(from date: Date?) -> String? {
    guard let d = date else { return nil }
    return labelDateFormatter.string(from: d)
  }
  
  // MARK: Date and time
  static private var labelDateAndTimeFormatter: DateFormatter {
    get {
      let formatter = DateFormatter()
      formatter.setLocalizedDateFormatFromTemplate("E, MMM d, yyyy, h:mm a")
      return formatter
    }
  }
  
  static private var dateAndTimeFormatter: DateFormatter {
    get {
      let formatter = DateFormatter()
      formatter.setLocalizedDateFormatFromTemplate("MM/dd/yy, h:mm a")
      return formatter
    }
  }
  
  static func dateAndTimeString(from date: Date?) -> String? {
    guard let d = date else { return nil }
    return dateAndTimeFormatter.string(from: d)
  }
  
  static func labelDateAndTimeString(from date: Date?) -> String? {
    guard let d = date else { return nil }
    return labelDateAndTimeFormatter.string(from: d)
  }

  static func dateAndTime(from string: String?) -> Date? {
    guard let s = string else { return nil }
    return dateAndTimeFormatter.date(from: s)
  }
  
  // MARK: Full date, time, milliseconds
  static private var saveDateFormatter: DateFormatter {
    get {
      let formatter = DateFormatter()
      formatter.setLocalizedDateFormatFromTemplate("d MMM yyyy HH:mm:ss Z")
      return formatter
    }
  }
  
  static func getFullDate(from string: String?) -> Date? {
    guard let s = string else { return nil }
    return saveDateFormatter.date(from: s)
  }
  
  
}
