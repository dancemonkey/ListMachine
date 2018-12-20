//
//  Item.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/20/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import Foundation

class Item {
  
  var fields: FieldListProtocol
  
  init(with fields: FieldListProtocol) {
    self.fields = fields
  }
  
  func update(at index: Int, with field: ListFieldProtocol) {
    fields.updateField(at: index, with: field)
  }

}
