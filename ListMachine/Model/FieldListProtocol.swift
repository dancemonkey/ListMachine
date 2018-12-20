//
//  ListProtocol.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/19/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import Foundation

protocol FieldListProtocol {
  var name: String { get set }
  var fields: [ListFieldProtocol]? { get set }
  mutating func add(newField: ListFieldProtocol)
  mutating func removeField(at index: Int)
  mutating func updateField(at index: Int, with field: ListFieldProtocol)
  mutating func returnClearedValues() -> [ListFieldProtocol]? 
}
