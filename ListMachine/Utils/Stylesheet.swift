//
//  Stylesheet.swift
//  ListMachine
//
//  Created by Drew Lanning on 1/3/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit
import Hero

enum UserContentFeature {
  case mainListCell, mainListInfo, itemListCellTitle, itemCollectionCellData, itemCollectionCellTitle, fieldListCell, userInput, itemEntryFieldTitle, templateFieldListTitle, templateFieldListType
}

enum SystemContentFeature {
  case buttonLabel, smallNavigationHeading, navigationHeading, alertTitle, alertMessage, fieldLabel, pickerItem, segmentItem, textField, barButtonItemLabel
}

enum ColorCategory {
  case primary, secondary, accent, white, black
}

struct Stylesheet {
  
  // MARK: Hero
  static func cellHeroModifiers(for row: Int) -> [HeroModifier] {
    return [.duration(0.125 * Double(row)), .fade]//.scale(0.0), .fade]
  }
  
  static func viewControllerTransitionModifiers() -> [HeroModifier] {
    return [.duration(0.01)]
  }
  
  // MARK: Colors
  static func getColor(_ category: ColorCategory) -> UIColor {
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

  enum Fonts: String {
    case systemFontName = "Montserrat-Regular",
    systemFontBoldName = "Montserrat-Bold",
    systemFontSemiboldName = "Montserrat-SemiBold",
    userFontName = "OpenSans-Regular",
    userFontEmphasisName = "OpenSans-Italic",
    userFontBoldName = "OpenSans-Semibold"
  }
  
  static func uiElementFont(for feature: SystemContentFeature) -> UIFont {
    let size = getSize(for: feature)
    let fontName: String
    switch feature {
    case .navigationHeading:
      fontName = Fonts.systemFontBoldName.rawValue
    case .smallNavigationHeading, .fieldLabel:
      fontName = Fonts.systemFontSemiboldName.rawValue
    default:
      fontName = Fonts.systemFontName.rawValue
    }
    return UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size)
  }
  
  static func userContentFont(for feature: UserContentFeature) -> UIFont {
    let size = getSize(for: feature)
    let fontName: String
    switch feature {
    case .itemCollectionCellTitle, .templateFieldListType, .mainListInfo:
      fontName = Fonts.userFontEmphasisName.rawValue
    case .itemListCellTitle, .templateFieldListTitle, .itemEntryFieldTitle:
      fontName = Fonts.userFontBoldName.rawValue
    default:
      fontName = Fonts.userFontName.rawValue
    }
    return UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size)
  }
  
  private static func getSize(for feature: UserContentFeature) -> CGFloat {
    switch feature {
    case .mainListCell:
      return 20.0
    case .mainListInfo:
      return 14.0
    case .itemListCellTitle:
      return 18.0
    case .itemCollectionCellData:
      return 12.0
    case .itemCollectionCellTitle:
      return 10.0
    case .fieldListCell:
      return 20.0
    case .userInput:
      return 16.0
    case .itemEntryFieldTitle:
      return 16.0
    case .templateFieldListType:
      return 14.0
    case .templateFieldListTitle:
      return 16.0
    }
  }
  
  private static func getSize(for feature: SystemContentFeature) -> CGFloat {
    switch feature {
    case .buttonLabel:
      return 17.0
    case .navigationHeading:
      return 34.0
    case .smallNavigationHeading:
      return 17.0
    case .alertTitle:
      return 18.0
    case .alertMessage:
      return 14.0
    case .pickerItem:
      return 23.0
    case .segmentItem:
      return 13.0
    case .fieldLabel:
      return 16.0
    case .textField:
      return 16.0
    case .barButtonItemLabel:
      return 18.0
    }
  }
  
  // MARK: Date and time string formatting
  static private var labelDateAndTimeFormatter: DateFormatter {
    get {
      let formatter = DateFormatter()
      formatter.setLocalizedDateFormatFromTemplate("MM/dd/yy, h:mm a")
      return formatter
    }
  }
  
  static private var simpleDateFormatter: DateFormatter {
    get {
      let formatter = DateFormatter()
      formatter.setLocalizedDateFormatFromTemplate("E, MMM d, yyyy")
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
      formatter.setLocalizedDateFormatFromTemplate("E, MMM d, yyyy, h:mm a")
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
    
}
