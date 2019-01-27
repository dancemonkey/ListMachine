//
//  ItemSaveDelegate.swift
//  ListMachine
//
//  Created by Drew Lanning on 1/27/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import Foundation

protocol ItemFieldSaveDelegate: class {
  func saveFieldContents(_ value: String, toField field: ItemField)
}
