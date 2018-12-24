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
    let cell = tableView.dequeueReusableCell(withIdentifier: TableCellID.templateFieldCell.rawValue)
    cell?.textLabel?.text = itemTemplate.defaultFields[indexPath.row].name
    cell?.detailTextLabel?.text = itemTemplate.defaultFields[indexPath.row].type
    return cell!
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // call segue and populate editor with current field
    performSegue(withIdentifier: SegueID.showTemplateEditor.rawValue, sender: indexPath.row)
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
    itemTemplate.add(field: field)
    tableView.reloadData()
  }
  
  func update(_ field: ItemField, at index: Int) {
    itemTemplate.update(field: field, at: index)
    tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .fade)
  }
  
}
