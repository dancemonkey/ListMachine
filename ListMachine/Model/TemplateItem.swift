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
//  typealias FieldID = Int
//  var name: String
//  var defaultFields: [ItemFieldProtocol]
//  private var nextFieldID: FieldID = 0
//  var description: String {
//    return "Template \(name), has \(defaultFields.count) fields, and the next FieldID is \(nextFieldID)."
//  }
  @objc dynamic var name: String = ""
  @objc dynamic var nextFieldID: Int = 0
  let defaultFields = RealmSwift.List<ItemField>()
  
  // MARK: Realm Changes
  
  convenience init(name: String, with fields: [ItemField]) {
    self.init()
    self.name = name
    self.defaultFields.append(objectsIn: fields)
    setAllFieldIDs()
  }
  
  func add(field: ItemField) {
    defaultFields.append(field)
    defaultFields[defaultFields.count - 1].fieldID.value = nextFieldID
    nextFieldID = nextFieldID + 1
  }
  
  func update(field: ItemField, at index: Int) {
    defaultFields[index] = field
  }
  
  func setAllFieldIDs() {
    for (index, _) in defaultFields.enumerated() {
      defaultFields[index].fieldID.value = index
      nextFieldID = index + 1
    }
  }
}
