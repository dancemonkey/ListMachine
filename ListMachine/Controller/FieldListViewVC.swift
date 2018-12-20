//
//  ListViewVC.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/19/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class FieldListViewVC: UIViewController, UITableViewDelegate, UITableViewDataSource, FieldSaveDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  var fieldList: FieldListProtocol?
  var item: Item?
  var itemIndex: Int?
  var itemSaveDelegate: ItemSaveDelegate?
  var blankItem: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if item != nil {
      fieldList = item!.fields
    } else if item == nil && fieldList != nil {
      blankItem = true
    }
    
    // item == nil but fieldList != nil, then do not populate value of field just use name and type
    
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  // MARK: Tableview Methods
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return fieldList?.fields?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TableCellID.listFieldCell.rawValue)
    
    // fill test cell, but if blankItem do not populate values
    cell?.textLabel?.text = fieldList!.fields![indexPath.row].name
    cell?.detailTextLabel?.text = "\(fieldList!.fields![indexPath.row].type), \(fieldList!.fields![indexPath.row].value)"
    return cell!
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: SegueID.showListFieldEditor.rawValue, sender: indexPath)
  }
  
  // MARK: Nav Actions
  @IBAction func addNewItemPressed(sender: UIBarButtonItem) {
    performSegue(withIdentifier: SegueID.showListFieldCreation.rawValue, sender: self)
  }
  
  @IBAction func savePressed(sender: UIButton) {
    if let i = item {
      itemSaveDelegate?.updateItem(i, at: itemIndex!)
    } else {
      item = Item(with: fieldList!)
      itemSaveDelegate?.saveItem(item!)
    }
    navigationController?.popViewController(animated: true)
  }
  
  // MARK: Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == SegueID.showListFieldCreation.rawValue {
      let destVC = segue.destination as! ListFieldCreationVC
      destVC.saveDelegate = self
    } else if segue.identifier == SegueID.showListFieldEditor.rawValue {
      let destVC = segue.destination as! ListFieldCreationVC
      destVC.saveDelegate = self
      destVC.existingFields = fieldList!.fields![(sender as! IndexPath).row]
      destVC.existingFieldIndex = (sender as! IndexPath).row
    }
  }
  
  // MARK: Save Protocol
  func saveField(_ field: ListFieldProtocol) {
    guard let _ = fieldList else {
      fieldList = FieldList(name: "New List Template", fields: [ListFieldProtocol]())
      fieldList?.add(newField: field)
      item?.fields.add(newField: field)
      tableView.reloadData()
      return
    }
    fieldList?.add(newField: field)
    item?.fields.add(newField: field)
    tableView.reloadData()
  }
  
  func update(_ field: ListFieldProtocol, at index: Int) {
    fieldList?.updateField(at: index, with: field)
    item?.update(at: index, with: field)
    tableView.reloadData()
  }
  
}
