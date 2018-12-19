//
//  ItemList.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/19/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import Foundation

struct ItemList: ListProtocol {
  var name: String
  var items: [ListFieldProtocol]?
  
  mutating func add(newField: ListFieldProtocol) {
    items?.append(newField)
  }
  
  mutating func removeItem(at index: Int) {
    items?.remove(at: index)
  }
}
