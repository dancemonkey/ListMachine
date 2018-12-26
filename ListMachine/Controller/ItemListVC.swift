//
//  ItemListVC.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/20/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit
import RealmSwift

class ItemListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ItemSaveDelegate, TemplateSaveDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  var itemList: List!
  var realm: Realm?
  var store: DataStore?

  override func viewDidLoad() {
    super.viewDidLoad()
    self.store = DataStore()
    self.realm = store?.getRealm()
    
    // TEST DATA, LIST ITSELF WILL BE CREATED FROM PRIOR SCREEN AND NAMED BEFORE ENTRY
    itemList = realm?.objects(List.self).first
//    itemList = List(name: "Movie Collection")
//    store?.save(object: itemList, andRun: nil)
    // will probably do this on prior screen eventually
    
    self.title = itemList.name
    
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  // MARK: Tableview Methods
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemList.listedItems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TableCellID.listItemCell.rawValue)
    cell?.textLabel?.text = itemList.listedItems[indexPath.row].itemListTitle
    return cell!
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: SegueID.showItemCreator.rawValue, sender: indexPath)
  }
  
  // MARK: Actions
  @IBAction func newItemPressed(sender: UIBarButtonItem) {
    performSegue(withIdentifier: SegueID.showItemCreator.rawValue, sender: self)
  }
  
  @IBAction func editTemplatePressed(sender: UIBarButtonItem) {
    performSegue(withIdentifier: SegueID.showTemplateEditor.rawValue, sender: self.itemList.templateItem)
  }
  
  // MARK: Item Save Delegate
  func saveItem(_ item: Item) {
    store?.save(object: item, andRun: {
      self.itemList.add(item: item)
    })
    tableView.reloadData()
  }
  
  func updateItem(_ item: Item, at index: Int) {
    store?.save(object: item, andRun: {
      self.itemList.update(itemAt: index, with: item)
    })
    tableView.reloadData()
  }
  
  // MARK: Template Save Delegate
  func saveTemplate(_ template: TemplateItem) {
    store?.save(object: itemList, andRun: {
      self.itemList.setTemplate(template)
      print("ran save block from list saveTemplate function")
    })
  }
  
  // MARK: Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == SegueID.showItemCreator.rawValue {
      let destVC = segue.destination as! ItemCreateEditVC
      destVC.itemSaveDelegate = self
      destVC.itemTemplate = self.itemList.templateItem
      destVC.item = Item(from: itemList.templateItem!)
      destVC.store = self.store
      if let indexPath = (sender as? IndexPath) {
        destVC.item = itemList.listedItems[indexPath.row]
        destVC.itemIndex = indexPath.row
      }
    } else if segue.identifier == SegueID.showTemplateEditor.rawValue {
      let dest = segue.destination as! TemplateCreateEditVC
      dest.itemTemplate = self.itemList.templateItem
      dest.saveDelegate = self
      dest.store = self.store
    }
  }
  
}
