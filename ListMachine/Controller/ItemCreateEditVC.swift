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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
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
    cell?.textLabel?.text = itemTemplate.defaultFields[indexPath.row].name
    cell?.detailTextLabel?.text = "\(itemTemplate.defaultFields[indexPath.row].type.rawValue), \(item?.itemFields[indexPath.row].value ?? "No value entered")"
    return cell!
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: SegueID.showFieldValueEntry.rawValue, sender: indexPath)
  }
  
  // MARK: Nav Actions
  
  @IBAction func savePressed(sender: UIButton) {
    if let i = itemIndex {
      itemSaveDelegate?.updateItem(self.item!, at: i)
    } else {
      itemSaveDelegate?.saveItem(item!)
    }
    navigationController?.popViewController(animated: true)
  }
  
  // MARK: Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == SegueID.showFieldValueEntry.rawValue {
      let dest = segue.destination as! FieldValueEditVC
      dest.currentField = item?.itemFields[(sender as! IndexPath).row]
      dest.currentFieldID = item?.itemFields[(sender as! IndexPath).row].fieldID
      dest.saveDelegate = self
    }
  }
  
  // MARK: Save Protocol
  func saveField(_ field: ItemFieldProtocol) {
    guard let _ = item else {
      tableView.reloadData()
      return
    }
    item?.setValues(for: field)
    tableView.reloadData()
  }
  
  func update(_ field: ItemFieldProtocol, at index: Int) {
    item?.setValues(for: field)
    tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
  }
  
}
