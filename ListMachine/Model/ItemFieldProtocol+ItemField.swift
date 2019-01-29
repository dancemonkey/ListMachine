//
//  ListFieldProtocol.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/19/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import Foundation
import RealmSwift

protocol ItemFieldProtocol {
  typealias FieldID = Int
  typealias FieldValue = String
  var name: String { get set }
  var type: String { get set }
  var value: FieldValue? { get set }
  var fieldID: RealmOptional<Int> { get }
  func set(value: FieldValue, forType type: FieldType)
  func getValueAndType() -> (value: FieldValue?, type: FieldType?)
}

enum CheckboxSetError: Error {
  case notCheckboxType
  case nonBooleanValue
}

class ItemField: Object, ItemFieldProtocol {
  @objc dynamic var name: String = ""
  @objc dynamic var type: String = FieldType.noType.rawValue
  @objc dynamic var value: FieldValue? = ""
  let fieldID = RealmOptional<Int>()
  @objc dynamic var fieldPrimaryKey: String = ""
  
  convenience init(name: String, type: FieldType, value: FieldValue?, id: Int?) {
    self.init()
    self.name = name
    self.type = type.rawValue
    if type == .checkBox {
      self.value = "false"
    } else {
      self.value = value
    }
    self.fieldID.value = id
    fieldPrimaryKey = UUID().uuidString
  }
  
  override static func primaryKey() -> String? {
    return "fieldPrimaryKey"
  }
  
  func set(value: FieldValue, forType type: FieldType) {
    self.value = value
  }
  
  func flipBoolean() throws {
    guard let fieldType = FieldType(rawValue: self.type), fieldType == .checkBox else {
      throw CheckboxSetError.notCheckboxType
    }
    if let boolValue = Bool(self.value ?? "") {
      self.value = (!boolValue).description
    } else {
      throw CheckboxSetError.nonBooleanValue
    }
  }
  
  func getValueAndType() -> (value: FieldValue?, type: FieldType?) {
    return (self.value, FieldType(rawValue: self.type))
  }
}

