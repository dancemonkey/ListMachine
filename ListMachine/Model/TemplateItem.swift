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
  var description: String {
    return "Template \(name)"
  }
  
  init(name: String, with fields: [ItemFieldProtocol]) {
    self.name = name
    self.defaultFields = fields
  }
}
