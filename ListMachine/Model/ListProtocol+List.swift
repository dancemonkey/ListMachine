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
  let sortKey = RealmOptional<Int>()
  
  convenience init(name: String) {
    self.init()
    self.name = name
    templateItem = TemplateItem(name: name, with: [])
    sortKey.value = nil
  }
  
  override static func primaryKey() -> String? {
    return "listID"
  }
  
  func setTemplate(_ template: TemplateItem) {
    self.templateItem = template
    for item in listedItems {
      item.setNewTemplate(template)
    }
  }
  
  func add(item: Item) {
    listedItems.append(item)
  }
  
  func remove(itemAt index: Int) {
    listedItems.remove(at: index)
  }
  
  func update(itemAt index: Int, with item: Item) {
    listedItems[index] = item
  }
  
  func getListSorted(by fieldIndex: Int?) -> Array<Item> {
    if let index = fieldIndex {
      setSortKey(to: index)
      return Array(listedItems).sorted(by: { (itemOne, itemTwo) -> Bool in
        return itemOne.itemFields[index].value! < itemTwo.itemFields[index].value!
      })
    }
    return Array(listedItems)
  }
  
  func setSortKey(to index: Int) {
    DataStore()?.run {
      self.sortKey.value = index
    }
  }

}
