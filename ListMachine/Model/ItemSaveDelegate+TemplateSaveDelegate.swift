//
//  ItemSaveDelegate.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/20/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import Foundation

protocol ItemSaveDelegate {
  func saveItem(_ item: ItemProtocol)
  func updateItem(_ item: ItemProtocol, at index: Int)
}

protocol TemplateSaveDelegate {
  func saveTemplate(_ template: TemplateItem)
}
