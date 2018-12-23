//
//  Item.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/20/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import Foundation

protocol ItemProtocol {
  typealias FieldID = Int
  var itemFields: [ItemFieldProtocol] { get set }
  var templateItem: TemplateItem { get set }
  var itemListTitle: String { get }
  func setNewTemplate(_ template: TemplateItem)
  func setValues(for field: ItemFieldProtocol)
}

class Item: ItemProtocol, CustomStringConvertible {
  typealias FieldID = Int
  var itemFields: [ItemFieldProtocol]
  var templateItem: TemplateItem
  var itemListTitle: String {
    if itemFields.count > 0 {
      return (itemFields[0].value as? String) ?? "NO TITLE"
    } else {
      return "No Title"
    }
  }
  var description: String {
    get {
      return "Item is a template of \(String(describing: templateItem)), and contains these fields: \(itemFields)"
    }
  }
  
  init(from template: TemplateItem) {
    self.itemFields = template.defaultFields.count > 0 ? template.defaultFields : [ItemFieldProtocol]()
    self.templateItem = template
  }
  
  func setNewTemplate(_ template: TemplateItem) {
    self.templateItem = template

    var newFields = [ItemFieldProtocol]()
    template.defaultFields.forEach { (field) in
      newFields.append(ItemField(name: field.name, type: field.type, value: "", fieldID: field.fieldID!))
    }
    let oldFields = self.itemFields
    for data in oldFields {
      let target = newFields.firstIndex { (field) -> Bool in
        data.fieldID == field.fieldID
      }
      if target != nil {
        newFields[target!].value = data.value
      }
    }
    self.itemFields = newFields
  }
  
  func setValues(for field: ItemFieldProtocol) {
    itemFields[field.fieldID!] = field
//    for data in payload {
//      let target = itemFields.firstIndex { (field) -> Bool in
//        field.fieldID == data.key
//      }
//      if target == nil {
//        print("invalid fieldID")
//        return
//      }
//      itemFields[target!].value = data.value
//    }
  }
}
