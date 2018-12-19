//
//  ListProtocol.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/19/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import Foundation

protocol ListProtocol {
  var name: String { get set }
  var items: [ListFieldProtocol]? { get set }
  mutating func add(newField: ListFieldProtocol)
  mutating func removeItem(at index: Int)
}
