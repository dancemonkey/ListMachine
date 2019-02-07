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
  
  @IBOutlet weak var tableView: UITableView!
  var newButton: NewItemButton!
  var store: DataStore?
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.store = DataStore()
    tableView.delegate = self
    tableView.dataSource = self
    styleViews()
  }
  
  func styleViews() {
    view.backgroundColor = .white //Stylesheet.getColor(.white)
    tableView.backgroundColor = .white //Stylesheet.getColor(.white)
    setupNewButton()
    setupToolbar(with: newButton, and: nil)
  }
  
  func setupNewButton() {
    newButton = NewItemButton()
    newButton.setImageAndFrame()
    newButton.addTarget(self, action: #selector(newListPressed(sender:)), for: .touchUpInside)
  }
    
  @objc func newListPressed(sender: NewItemButton) {
    let popup = PopupFactory.newList { [weak self] in
      self?.tableView.reloadData()
    }
    self.present(popup, animated: true, completion: nil)
  }
  
  // MARK: Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == SegueID.showListView.rawValue {
      let row = (sender as! IndexPath).row
      let dest = segue.destination as! ItemListVC
      dest.itemList = store?.getAllLists()?[row]
      dest.masterListDelegate = self
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
    cell.configure(with: store?.getAllLists()?[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: SegueID.showListView.rawValue, sender: indexPath)
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
      self.store?.delete(list: self.store!.getAllLists()![indexPath.row])
      self.tableView.reloadData()
    }
    let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
      // show popup to edit list title, maybe a button to clear all items
      print("editing title yay!")
      let controller = PopupFactory.editTitle(of: self.store!.getAllLists()![indexPath.row]) {
        [weak self] in
        self?.tableView.reloadData()
      }
      self.present(controller, animated: true, completion: nil)
    }
    
    return [edit, delete]
  }
}

extension MasterListVC: MasterListUpdate {
  func updateMasterList() {
    self.tableView.reloadData()
  }
}
