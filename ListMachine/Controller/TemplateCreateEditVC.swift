//
//  CreateEditTemplateVC.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/22/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class TemplateCreateEditVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  var itemTemplate: TemplateItem!
  
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
    cell?.detailTextLabel?.text = itemTemplate.defaultFields[indexPath.row].type.rawValue
    return cell!
  }
  
  // MARK: Actions
  @IBAction func savePressed(sender: UIButton) {
    // save back to list
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func addNewFieldPressed(sender: UIBarButtonItem) {
    // add the new field
  }
  
}
