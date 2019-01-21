//
//  Stylesheet.swift
//  ListMachine
//
//  Created by Drew Lanning on 1/3/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

enum UserContentFeature {
  case mainListCell, itemListCellTitle, itemListCellData, fieldListCell, userInput
}

enum SystemContentFeature {
  case buttonLabel, navigationHeading, alertTitle, alertMessage, fieldLabel, pickerItem, segmentItem
}

enum ColorCategory {
  case primary, secondary, accent, white, black
}

struct Stylesheet {
  
  // MARK: Colors
  static func getColor(for category: ColorCategory) -> UIColor {
    switch category {
    case .accent:
      return UIColor.init(red: 122/255, green: 59/255, blue: 105/255, alpha: 1.0)
    case .black:
      return UIColor.init(red: 41/255, green: 31/255, blue: 30/255, alpha: 1.0)
    case .primary:
      return UIColor.init(red: 71/255, green: 121/255, blue: 152/255, alpha: 1.0)
    case .secondary:
      return UIColor.init(red: 128/255, green: 155/255, blue: 206/255, alpha: 1.0)
    case .white:
      return UIColor.init(red: 234/255, green: 234/255, blue: 234/255, alpha: 1.0)
    }
  }
  
  // MARK: Fonts
  static var systemFontName: String = "Montserrat"
  static var systemFontBoldName: String = "Montserrat-Bold"
  static var userFontName: String = "Open Sans"
  
  static func uiElementFont(for feature: SystemContentFeature) -> UIFont {
    let size = getSize(for: feature)
    let fontName: String
    if feature == .navigationHeading {
      fontName = systemFontBoldName
    } else {
      fontName = systemFontName
    }
    return UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size)
  }
  
  static func userContentFont(for feature: UserContentFeature) -> UIFont {
    let size = getSize(for: feature)
    return UIFont(name: userFontName, size: size) ?? UIFont.systemFont(ofSize: size)
  }
  
  private static func getSize(for feature: UserContentFeature) -> CGFloat {
    switch feature {
    case .mainListCell:
      return 20.0
    case .itemListCellTitle:
      return 18.0
    case .itemListCellData:
      return 14.0
    case .fieldListCell:
      return 20.0
    case .userInput:
      return 16.0
    }
  }
  
  private static func getSize(for feature: SystemContentFeature) -> CGFloat {
    switch feature {
    case .buttonLabel:
      return 17.0
    case .navigationHeading:
      return 34.0
    case .alertTitle:
      return 18.0
    case .alertMessage:
      return 14.0
    case .pickerItem:
      return 23.0
    case .segmentItem:
      return 13.0
    case .fieldLabel:
      return 13.0
    }
  }
  
  // MARK: Date and time string formatting
  
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
