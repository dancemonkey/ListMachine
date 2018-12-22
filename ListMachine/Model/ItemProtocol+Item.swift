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
  func setValues(_ values: [FieldID: Any?])
}

class Item: ItemProtocol, CustomStringConvertible {
  typealias FieldID = Int
  var itemFields: [ItemFieldProtocol]
  var templateItem: TemplateItem
  var itemListTitle: String {
    return (itemFields[0].value ?? "NO TITLE") as! String
  }
  var description: String {
    get {
      return "Item is a template of \(String(describing: templateItem)), and contains these fields: \(itemFields)"
    }
  }
  
  init(from template: TemplateItem) {
    self.itemFields = template.defaultFields
    self.templateItem = template
  }
  
  func setNewTemplate(_ template: TemplateItem) {
    self.templateItem = template
    // update item fieldIDs with possible new names and value types
    var newFields = templateItem.defaultFields
    for data in itemFields {
      let target = newFields.firstIndex { (field) -> Bool in
        data.fieldID == field.fieldID
      }
      if target != nil {
        newFields[target!].value = data.value
      }
    }
    self.itemFields = newFields
  }
  
  func setValues(_ payload: [FieldID : Any?]) {
    for data in payload {
      let target = itemFields.firstIndex { (field) -> Bool in
        field.fieldID == data.key
      }
      if target == nil {
        print("invalid fieldID")
        return
      }
      itemFields[target!].value = data.value
    }
  }
}
