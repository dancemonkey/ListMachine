//
//  TemplateItem.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/22/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import Foundation

class TemplateItem: CustomStringConvertible {
  typealias FieldID = Int
  var name: String
  var defaultFields: [ItemFieldProtocol]
  private var nextFieldID: FieldID = 0
  var description: String {
    return "Template \(name), has \(defaultFields.count) fields, and the next FieldID is \(nextFieldID)."
  }
  
  convenience init(name: String) {
    self.init(name: name, with: [])
    self.name = name
  }
  
  init(name: String, with fields: [ItemFieldProtocol]) {
    self.name = name
    self.defaultFields = fields
    setAllFieldIDs()
  }
  
  func add(field: ItemFieldProtocol) {
    defaultFields.append(field)
    defaultFields[defaultFields.count - 1].fieldID = nextFieldID
    nextFieldID = nextFieldID + 1
  }
  
  func update(field: ItemFieldProtocol, at index: Int) {
    defaultFields[index] = field
    defaultFields[index].fieldID = index
  }
  
  func setAllFieldIDs() {
    for (index, _) in defaultFields.enumerated() {
      defaultFields[index].fieldID = index
      nextFieldID = index + 1
    }
  }
}
