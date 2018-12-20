//
//  FieldSaveProtocol.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/19/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import Foundation

protocol FieldSaveDelegate {
  func saveField(_ field: ListFieldProtocol)
  func update(_ field: ListFieldProtocol, at index: Int)
}
