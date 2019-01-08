//
//  MasterListVC.swift
//  ListMachine
//
//  Created by Drew Lanning on 1/7/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit
import RealmSwift

class MasterListVC: UIViewController {
  
  @IBOutlet weak var newListBtn: UIBarButtonItem!
  @IBOutlet weak var tableView: UITableView!
  var store: DataStore?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.store = DataStore()
    tableView.delegate = self
    tableView.dataSource = self
    // Do any additional setup after loading the view.
  }
  
  @IBAction func newListPressed(sender: UIBarButtonItem) {
    let popup = PopupFactory.newListNamePopup { [unowned self] in
      self.tableView.reloadData()
    }
    self.present(popup, animated: true, completion: nil)
  }
  
  // MARK: Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == SegueID.showListView.rawValue {
      let row = (sender as! IndexPath).row
      let dest = segue.destination as! ItemListVC
      dest.itemList = store?.getAllLists()?[row]
    }
  }
  
}

extension MasterListVC: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return store?.getAllLists()?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CellID.masterListCell.rawValue) as! MasterListCell
    cell.textLabel?.text = store?.getAllLists()?[indexPath.row].name
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: SegueID.showListView.rawValue, sender: indexPath)
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      store?.delete(object: store!.getAllLists()![indexPath.row])
      tableView.reloadData()
    }
  }
  
//  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//
//  }
  
}
