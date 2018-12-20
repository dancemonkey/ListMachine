//
//  ItemList.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/19/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import Foundation

struct FieldList: FieldListProtocol {
  var name: String
  var fields: [ListFieldProtocol]?
  
  mutating func add(newField: ListFieldProtocol) {
    fields?.append(newField)
  }
  
  mutating func removeField(at index: Int) {
    fields?.remove(at: index)
  }
  
  mutating func updateField(at index: Int, with field: ListFieldProtocol) {
    fields?[index] = field
  }
  
}
