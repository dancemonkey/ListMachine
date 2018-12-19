//
//  ListViewVC.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/19/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class ListViewVC: UIViewController, UITableViewDelegate, UITableViewDataSource, FieldSaveDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  var itemList: ItemList?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  // MARK: Tableview Functions
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemList?.items?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TableCellID.listCell.rawValue)
    
    // fill test cell
    cell?.textLabel?.text = itemList!.items![indexPath.row].name
    cell?.detailTextLabel?.text = "\(itemList!.items![indexPath.row].type), \(itemList!.items![indexPath.row].value)"
    return cell!
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: SegueID.showListFieldEditor.rawValue, sender: indexPath)
  }
  
  // MARK: Nav Actions
  @IBAction func addNewItemPressed(sender: UIBarButtonItem) {
    performSegue(withIdentifier: SegueID.showListFieldCreation.rawValue, sender: self)
  }
  
  // MARK: Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == SegueID.showListFieldCreation.rawValue {
      let destVC = segue.destination as! ListFieldCreationVC
      destVC.saveDelegate = self
    } else if segue.identifier == SegueID.showListFieldEditor.rawValue {
      let destVC = segue.destination as! ListFieldCreationVC
      destVC.saveDelegate = self
      destVC.existingField = itemList!.items![(sender as! IndexPath).row]
    }
  }
  
  // MARK: Save Protocol
  func saveField(_ field: ListFieldProtocol) {
    guard let _ = itemList else {
      itemList = ItemList(name: "New List", items: [ListFieldProtocol]())
      itemList?.add(newField: field)
      tableView.reloadData()
      return
    }
    itemList?.add(newField: field)
    tableView.reloadData()
  }
  
}
