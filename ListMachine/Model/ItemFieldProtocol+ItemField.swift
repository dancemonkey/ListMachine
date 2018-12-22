//
//  ListFieldProtocol.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/19/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import Foundation

enum FieldType: String {
  case text, memo, number, date, checkBox, noType
}

protocol ItemFieldProtocol {
  typealias FieldID = Int
  typealias FieldValue = Any
  var name: String { get set }
  var type: FieldType { get set }
  var value: FieldValue? { get set }
  var fieldID: FieldID? { get set }
  func set(value: FieldValue, forType type: FieldType)
  func getValueAndType() -> (value: FieldValue?, type: FieldType?)
}

class ItemField: ItemFieldProtocol, CustomStringConvertible {
  var name: String
  var type: FieldType
  var value: FieldValue?
  var fieldID: FieldID?
  var description: String {
    return "\(name), \(type)"
  }
  
  init(name: String, type: FieldType, value: FieldValue?, fieldID: FieldID) {
    self.name = name
    self.type = type
    self.value = value
    self.fieldID = fieldID
  }
  
  func set(value: FieldValue, forType type: FieldType) {
    self.value = value
  }
  
  func getValueAndType() -> (value: FieldValue?, type: FieldType?) {
    return (self.value, self.type)
  }
}

