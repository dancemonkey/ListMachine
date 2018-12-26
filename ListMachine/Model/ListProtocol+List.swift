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
  
  convenience init(name: String) {
    self.init()
    self.name = name
    
    // test data, normally when creating list you are asked for a name and the template is given the same name
    templateItem = TemplateItem(name: "Movie Collection", with: [])
  }
  
  override static func primaryKey() -> String? {
    return "listID"
  }
  
  func setTemplate(_ template: TemplateItem) {
    self.templateItem = template
    for item in listedItems {
      item.setNewTemplate(template)
      print("list function setTemplate setting new templates for each item")
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

}
