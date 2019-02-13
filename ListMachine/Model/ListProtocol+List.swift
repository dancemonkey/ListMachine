//
//  ListProtocol + List.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/22/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import Foundation
import RealmSwift

protocol ListProtocol {
  var name: String { get set }
  var listedItems: RealmSwift.List<Item> { get }
  var templateItem: TemplateItem? { get set }
  func add(item: Item)
  func remove(itemAt index: Int)
  func update(itemAt index: Int, with item: Item)
  func setTemplate(_ template: TemplateItem) 
}

class List: Object, ListProtocol {
  
  @objc dynamic var name: String = ""
  let listedItems = RealmSwift.List<Item>()
  @objc dynamic var templateItem: TemplateItem?
  @objc dynamic var listID: String = UUID().uuidString
  @objc private dynamic var _lastUpdate: Date?
  var lastUpdated: Date? {
    return _lastUpdate ?? nil
  }
  @objc dynamic var creation: Date!
  let sortKey = RealmOptional<Int>()
  @objc dynamic var sortAscending: Bool = true
  
  convenience init(name: String) {
    self.init()
    self.name = name
    templateItem = TemplateItem(name: name, with: [])
    sortKey.value = nil
    setLastUpdated()
    self.creation = Date()
  }
  
  override static func primaryKey() -> String? {
    return "listID"
  }
  
  func setLastUpdated() {
    _lastUpdate = Date()
  }
  
  func setTemplate(_ template: TemplateItem) {
    self.templateItem = template
    for item in listedItems {
      item.setNewTemplate(template)
    }
    setLastUpdated()
  }
  
  func updateTemplate() {
    for item in listedItems {
      item.setNewTemplate(self.templateItem!)
    }
    setLastUpdated()
  }
  
  func add(item: Item) {
    listedItems.append(item)
    setLastUpdated()
  }
  
  func remove(itemAt index: Int) {
    listedItems.remove(at: index)
    setLastUpdated()
  }
  
  func removeAllItems() {
    if let template = templateItem {
      for field in template.defaultFields {
        DataStore()?.delete(object: field)
      }
      DataStore()?.delete(object: template)
    }
    for item in listedItems {
      for field in item.itemFields {
        DataStore()?.delete(object: field)
      }
      DataStore()?.delete(object: item)
    }
    DataStore()?.run {
      setLastUpdated()
    }
  }
  
  func update(itemAt index: Int, with item: Item) {
    listedItems[index] = item
    setLastUpdated()
  }
  
  func getListSorted(by fieldIndex: Int, andFilteredBy filterText: String?, ascending: Bool) -> Array<Item> {
    var results: Array<Item>
    
    setSortKey(to: fieldIndex)
    if ascending {
      results = Array(listedItems).sorted(by: { (itemOne, itemTwo) -> Bool in
        return itemOne.itemFields[fieldIndex].value ?? "" < itemTwo.itemFields[fieldIndex].value ?? ""
      })
    } else {
      results = Array(listedItems).sorted(by: { (itemOne, itemTwo) -> Bool in
        return itemOne.itemFields[fieldIndex].value ?? "" > itemTwo.itemFields[fieldIndex].value ?? ""
      })
    }
    
    
    if let filter = filterText, filter != "" {
      results = results.filter { (item) -> Bool in
        for field in item.itemFields {
          let value = field.value ?? ""
          if value.lowercased().contains(filter.lowercased()) { return true }
        }
        return false
      }
    }
    return results
  }
  
  func setSortKey(to index: Int) {
    DataStore()?.run {
      self.sortKey.value = index
    }
  }
  
}
