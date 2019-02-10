//
//  ExportBuilder.swift
//  ListMachine
//
//  Created by Drew Lanning on 2/9/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import Foundation
import UIKit

class ExportBuilder {
  enum Object {
    case list, item, unassigned
  }
  
  var objectType: Object = .unassigned
  var path: URL
  var list: List?
  var item: Item?
  
  init?(with list: List?) {
    guard let list = list else { return nil }
    self.objectType = .list
    self.list = list
    let filename: String = "\(list.name) - \(list.listedItems.count) items"
    self.path = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename + ".csv")
  }
  
  init?(with item: Item?) {
    guard let item = item else { return nil }
    self.objectType = .item
    self.item = item
    let filename: String = "\(item.itemListTitle) item"
    self.path = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename + ".csv")
  }
  
  func getListText() -> String? {
    guard let list = self.list else { return nil }
    return buildListFile(for: list)
  }
  
  func getItemText() -> String? {
    guard let item = self.item else { return nil }
    return buildItem(item: item)
  }
  
  func share(text: String) -> UIActivityViewController {
    do {
      try text.write(to: self.path, atomically: true, encoding: .utf8)
    } catch {
      print("failed to write text to path")
    }
    let popup = UIActivityViewController(activityItems: [path], applicationActivities: [])
    popup.excludedActivityTypes = [
      UIActivity.ActivityType.assignToContact,
      UIActivity.ActivityType.saveToCameraRoll,
      UIActivity.ActivityType.postToVimeo,
      UIActivity.ActivityType.postToWeibo,
      UIActivity.ActivityType.postToFlickr,
      UIActivity.ActivityType.postToTwitter,
      UIActivity.ActivityType.postToFacebook,
      UIActivity.ActivityType.postToTencentWeibo,
      UIActivity.ActivityType.openInIBooks
    ]
    return popup
  }
  
  private func buildItem(item: Item) -> String {
    var csv: String = ""
    if objectType == .item {
      for (idx, field) in item.templateItem!.defaultFields.enumerated() {
        csv.append("\"\(field.name)\"")
        if idx < item.templateItem!.defaultFields.count - 1 {
          csv.append(",")
        } else {
          csv.append("\n")
        }
      }
    }
    for (idx, field) in item.itemFields.enumerated() {
      let value = field.value ?? ""
      csv.append("\"\(value)\"")
      if idx < item.itemFields.count - 1 {
        csv.append(",")
      } else {
        csv.append("\n")
      }
    }
    return csv
  }
  
  private func buildHeadings(for list: List) -> String {
    var csvText: String = "List: \(list.name)\n"
    for (idx, field) in list.templateItem!.defaultFields.enumerated() {
      csvText.append("\"\(field.name)\"")
      if idx < list.templateItem!.defaultFields.count - 1 {
        csvText.append(",")
      } else {
        csvText.append("\n")
      }
    }
    return csvText
  }
  
  private func buildListFile(for list: List) -> String {
    var csvText: String = buildHeadings(for: list)
    for item in list.listedItems {
      csvText.append(buildItem(item: item))
    }
    return csvText
  }
  
}
