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

protocol ListFieldProtocol {
  var name: String { get set }
  var type: FieldType { get set }
  var value: FieldValue { get set }
}
