//
//  ExportBuilder.swift
//  ListMachine
//
//  Created by Drew Lanning on 2/9/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import Foundation

class ExportBuilder {
  enum Object {
    case list, item, unassigned
  }
  
  var objectType: Object = .unassigned
  var path: URL
  
  init(for list: List) {
    self.objectType = .list
    self.path = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(list.listID)
    var listText: String = buildHeadings(for: list)
    for item in list.listedItems {
      listText.append(buildItem(item: item))
    }
    
    // TODO: put text into sharesheet for export
    // TODO: finish item-only export code
    // TODO: write share sheet into MasterList as table swipe action
    // TODO: add share button on item view (and list view? redundant?)
    
    print(listText)
  }
  
  init(for item: Item) {
    self.objectType = .item
    self.path = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(item.itemID)
  }
  
  private func buildItem(item: Item) -> String {
    var csv: String = ""
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
  
}
