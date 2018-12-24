//
//  FieldSaveProtocol.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/19/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import Foundation

protocol FieldSaveDelegate {
  func saveField(_ field: ItemField)
  func update(_ field: ItemField, at index: Int)
}
