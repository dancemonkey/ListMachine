//
//  Item.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/20/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import Foundation
import RealmSwift

protocol ItemProtocol {
  typealias FieldID = Int
  var itemFields: RealmSwift.List<ItemField> { get }
  var templateItem: TemplateItem? { get set }
  var itemListTitle: String { get }
  func setNewTemplate(_ template: TemplateItem)
  func setValues(for field: ItemField, at index: Int)
}

class Item: Object, ItemProtocol {
  
  typealias FieldID = Int
  
  let itemFields = RealmSwift.List<ItemField>()
  @objc dynamic var itemID: String = UUID().uuidString
  @objc dynamic var templateItem: TemplateItem?
  
  var itemListTitle: String {
    if itemFields.count > 0 {
      return (itemFields[0].value) ?? "NO TITLE"
    } else {
      return "No Title"
    }
  }
  
  override static func primaryKey() -> String? {
    return "itemID"
  }
  
  convenience init(from template: TemplateItem) {
    self.init()
    if template.defaultFields.count > 0 {
      self.itemFields.append(objectsIn: template.defaultFields)
    }
    self.templateItem = template
  }
  
  func setNewTemplate(_ template: TemplateItem) {
    self.templateItem = template
    
    var newFields = [ItemField]()
    
    template.defaultFields.forEach { (field) in
      newFields.append(ItemField(name: field.name, type: FieldType(rawValue: field.type)!, value: "", id: field.fieldID.value))
    }

    let oldFields = self.itemFields
    for data in oldFields {
      let target = newFields.firstIndex { (field) -> Bool in
        return data.fieldID.value == field.fieldID.value
      }
      if target != nil {
        newFields[target!].value = data.value
      }
    }
    self.itemFields.removeAll()
    self.itemFields.append(objectsIn: newFields)
  }
  
  func setValues(for field: ItemField, at index: Int) {
    let id = itemFields[index].fieldID.value
    itemFields[index] = field
    itemFields[index].fieldID.value = id
  }
}
