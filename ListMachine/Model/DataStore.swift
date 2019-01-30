//
//  DataStore.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/26/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import Foundation
import RealmSwift


class DataStore {
  private var realm: Realm?
  
  init?() {
    do {
      self.realm = try Realm()
    } catch let error as NSError {
      print(error)
      return nil
    }
  }
  
  func getRealm() -> Realm? {
    return self.realm
  }
  
  func getAllLists() -> Results<List>? {
    // add keypath parameter to master list can be sorted
    // - name, last modified, created
    return realm?.objects(List.self).sorted(byKeyPath: "name", ascending: true)
  }
  
  func save(object: Object, andRun closure: (() -> ())?) {
    do {
      try realm?.write {
        realm?.add(object, update: true)
        if let runBlock = closure {
          runBlock()
        }
      }
    } catch let error as NSError {
      print(error)
    }
  }
  
  func run(closure: () -> ()) {
    do {
      try realm?.write {
        closure()
      }
    } catch let error as NSError {
      print(error)
    }
  }
  
  func delete(list: List) {
    
  }
  
  func delete(item: Item) {
    
  }
  
  func delete(object: Object) {
    do {
      try realm?.write {
        realm?.delete(object)
      }
    } catch let error as NSError {
      print(error)
    }
  }
  
}
