//
//  TemplateItem.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/22/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import Foundation
import RealmSwift

class TemplateItem: Object {

  @objc dynamic var name: String = ""
  @objc dynamic var nextFieldID: Int = 0
  let defaultFields = RealmSwift.List<ItemField>()
  @objc dynamic var templateID: String = UUID().uuidString
  
  // MARK: Realm Changes
  
  convenience init(name: String, with fields: [ItemField]) {
    self.init()
    self.name = name
    self.defaultFields.append(objectsIn: fields)
    setAllFieldIDs()
  }
  
  override static func primaryKey() -> String? {
    return "templateID"
  }
  
  func add(field: ItemField) {
    field.fieldID.value = nextFieldID
    defaultFields.append(field)
    nextFieldID = nextFieldID + 1
  }
  
  func insert(field: ItemField, at index: Int) {
    defaultFields.insert(field, at: index)
  }
  
  func update(field: ItemField, at index: Int) {
    let id = defaultFields[index].fieldID.value
    defaultFields[index] = field
    defaultFields[index].fieldID.value = id
  }
  
  func removeField(at index: Int) -> ItemField {
    let field = defaultFields[index]
    defaultFields.remove(at: index)
    return field
  }
  
  func setAllFieldIDs() {
    for (index, _) in defaultFields.enumerated() {
      defaultFields[index].fieldID.value = index
      nextFieldID = index + 1
    }
  }
  
  func moveField(from sourceIndex: Int, to destinationIndex: Int) {
    let field = defaultFields[sourceIndex]
    defaultFields.remove(at: sourceIndex)
    defaultFields.insert(field, at: destinationIndex)
  }
}
