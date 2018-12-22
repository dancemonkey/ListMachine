//
//  ListViewVC.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/19/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class ItemCreateEditVC: UIViewController, UITableViewDelegate, UITableViewDataSource, FieldSaveDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  var itemTemplate: TemplateItem!
  var item: ItemProtocol?
  var itemIndex: Int?
  var itemSaveDelegate: ItemSaveDelegate?
  var blankItem: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if item == nil {
      blankItem = true
    }
    self.title = item?.itemListTitle ?? "Untitled Item"
    
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  // MARK: Tableview Methods
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemTemplate.defaultFields.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TableCellID.itemFieldCell.rawValue)
    if blankItem {
      cell?.textLabel?.text = itemTemplate.defaultFields[indexPath.row].name
      cell?.detailTextLabel?.text = itemTemplate.defaultFields[indexPath.row].type.rawValue
    } else {
      cell?.textLabel?.text = itemTemplate.defaultFields[indexPath.row].name
      cell?.detailTextLabel?.text = itemTemplate.defaultFields[indexPath.row].type.rawValue
      if (item?.itemFields.count ?? 0) >= (indexPath.row - 1) {
        cell?.detailTextLabel?.text = "\(itemTemplate.defaultFields[indexPath.row].type.rawValue), \(item?.itemFields[indexPath.row].value ?? "No value entered")"
      }
    }
    return cell!
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    performSegue(withIdentifier: SegueID.showItemEditor.rawValue, sender: indexPath)
  }
  
  // MARK: Nav Actions
  
  @IBAction func savePressed(sender: UIButton) {
    if let i = item {
      itemSaveDelegate?.updateItem(i, at: itemIndex!)
    } else {
      item = Item(from: itemTemplate!)
      itemSaveDelegate?.saveItem(item!)
    }
    navigationController?.popViewController(animated: true)
  }
  
  // MARK: Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

  }
  
  // MARK: Save Protocol
  func saveField(_ field: ItemFieldProtocol) {
    guard let _ = item else {
      tableView.reloadData()
      return
    }

    tableView.reloadData()
  }
  
  func update(_ field: ItemFieldProtocol, at index: Int) {

    tableView.reloadData()
  }
  
}
