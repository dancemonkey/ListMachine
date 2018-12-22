//
//  ListProtocol + List.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/22/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import Foundation

protocol ListProtocol {
  var name: String { get set }
  var listedItems: [ItemProtocol]? { get set }
  var templateItem: TemplateItem! { get set }
  func add(item: ItemProtocol)
  func remove(itemAt index: Int)
  func update(itemAt index: Int, with item: ItemProtocol)
  func setTemplate(_ template: TemplateItem) 
}

class List: ListProtocol, CustomStringConvertible {
  var name: String
  var listedItems: [ItemProtocol]?
  var templateItem: TemplateItem!
  var description: String {
    get {
      guard let items = listedItems else {
        return "\(name) has no items."
      }
      var message = "\(name) contains these items: \n"
      for item in items {
        message = message + "\(item)\n"
      }
      return message
    }
  }
  
  init(name: String) {
    self.name = name
    templateItem = TemplateItem(name: self.name, with: [ItemField(name: "Name", type: .text, value: nil, fieldID: 0)])
  }
  
  func setTemplate(_ template: TemplateItem) {
    self.templateItem = template
    guard let items = listedItems else {
      return
    }
    for item in items {
      item.setNewTemplate(template)
    }
  }
  
  func add(item: ItemProtocol) {
    if listedItems == nil {
      listedItems = [Item]()
    }
    listedItems?.append(item)
  }
  
  func remove(itemAt index: Int) {
    listedItems?.remove(at: index)
  }
  
  func update(itemAt index: Int, with item: ItemProtocol) {
    listedItems?[index] = item
  }
}
