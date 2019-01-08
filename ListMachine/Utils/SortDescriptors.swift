//
//  SortDescriptors.swift
//  ListMachine
//
//  Created by Drew Lanning on 1/7/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import Foundation
import RealmSwift

struct SortDescriptors {
  
  func sortByListName() -> SortDescriptor {
    let sort = SortDescriptor(keyPath: "name")
    return sort
  }
  
}
