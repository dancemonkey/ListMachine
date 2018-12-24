//
//  ListFieldProtocol.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/19/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import Foundation
import RealmSwift

enum FieldType: String {
  case text, memo, number, date, checkBox, noType
}

protocol ItemFieldProtocol {
  typealias FieldID = Int
  typealias FieldValue = String
  var name: String { get set }
  var type: String { get set }
  var value: FieldValue? { get set }
//  var fieldID: FieldID? { get set }
  var fieldID: RealmOptional<Int> { get }
  func set(value: FieldValue, forType type: FieldType)
  func getValueAndType() -> (value: FieldValue?, type: FieldType?)
}

class ItemField: Object, ItemFieldProtocol {
//  var name: String
//  var type: FieldType
//  var value: FieldValue?
//  var fieldID: FieldID?
  @objc dynamic var name: String = ""
  @objc dynamic var type: String = FieldType.noType.rawValue
  @objc dynamic var value: FieldValue? = ""
  let fieldID = RealmOptional<Int>()
  
  override static func primaryKey() -> String? {
    return "fieldID"
  }
  
  convenience init(name: String, type: FieldType, value: FieldValue?, fieldID: FieldID) {
    self.init()
    self.name = name
    self.type = type.rawValue
    self.value = value
    self.fieldID.value = fieldID
  }
  
  func set(value: FieldValue, forType type: FieldType) {
    self.value = value
  }
  
  func getValueAndType() -> (value: FieldValue?, type: FieldType?) {
    return (self.value, FieldType(rawValue: self.type))
  }
}

