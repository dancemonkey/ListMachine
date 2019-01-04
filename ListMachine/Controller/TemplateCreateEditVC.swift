//
//  CreateEditTemplateVC.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/22/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class TemplateCreateEditVC: UIViewController, UITableViewDelegate, UITableViewDataSource, FieldSaveDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  var itemTemplate: TemplateItem!
  var saveDelegate: TemplateSaveDelegate?
  var store: DataStore?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = itemTemplate.name + " Template"
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
    let cell = tableView.dequeueReusableCell(withIdentifier: CellID.templateFieldCell.rawValue)
    cell?.textLabel?.text = itemTemplate.defaultFields[indexPath.row].name
    cell?.detailTextLabel?.text = itemTemplate.defaultFields[indexPath.row].type
    return cell!
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // call segue and populate editor with current field
    performSegue(withIdentifier: SegueID.showTemplateEditor.rawValue, sender: indexPath.row)
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      store?.delete(object: itemTemplate.defaultFields[indexPath.row])
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }
  
  // MARK: Actions
  @IBAction func savePressed(sender: UIButton) {
    saveDelegate?.saveTemplate(itemTemplate)
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func addNewFieldPressed(sender: UIBarButtonItem) {
    performSegue(withIdentifier: SegueID.showTemplateEditor.rawValue, sender: self)
  }
  
  // MARK: Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == SegueID.showTemplateEditor.rawValue {
      let dest = segue.destination as! TemplateFieldEditVC
      dest.saveDelegate = self
      if let index = (sender as? Int) {
        dest.currentField = itemTemplate.defaultFields[index]
        dest.currentFieldIndex = index
      }
    }
  }
  
  // MARK: FieldSaveDelegate
  func saveField(_ field: ItemField) {
    store?.save(object: field, andRun: {
      self.itemTemplate.add(field: field)
    })
    tableView.reloadData()
  }
  
  func update(_ field: ItemField, at index: Int) {
    store?.save(object: field, andRun: {
      self.itemTemplate.update(field: field, at: index)
    })
    tableView.reloadData()
//    tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .fade)
  }
  
}
