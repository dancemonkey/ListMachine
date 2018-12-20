//
//  ItemListVC.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/20/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class ItemListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ItemSaveDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  var items: [Item]?
  var defaultFields: FieldListProtocol?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    if items == nil {
      items = [Item]()
    } else {
      defaultFields = items![0].fields
    }
    
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  // MARK: Tableview Methods
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TableCellID.listItemCell.rawValue)
    cell?.textLabel?.text = items![indexPath.row].fields.name
    return cell!
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: SegueID.showFieldList.rawValue, sender: indexPath)
  }
  
  // MARK: Actions
  @IBAction func newItemPressed(sender: UIBarButtonItem) {
    performSegue(withIdentifier: SegueID.showFieldList.rawValue, sender: self)
  }
  
  // MARK: Item Save Delegate
  func saveItem(_ item: Item) {
    items?.append(item)
    defaultFields = item.fields
    tableView.reloadData()
  }
  
  func updateItem(_ item: Item, at index: Int) {
    items![index] = item
    defaultFields = item.fields
    tableView.reloadData()
  }
  
  // MARK: Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == SegueID.showFieldList.rawValue {
      let destVC = segue.destination as! FieldListViewVC
      destVC.itemSaveDelegate = self
      destVC.fieldList = defaultFields
      destVC.item = nil
      if let indexPath = (sender as? IndexPath) {
        destVC.item = items?[indexPath.row] ?? nil
        destVC.itemIndex = indexPath.row
      }
    }
  }
  
}
