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
  var newButton: UIButton!
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
    view.backgroundColor = Stylesheet.getColor(.white)
    tableView.backgroundColor = Stylesheet.getColor(.white)
    setupNewButton()
    setupToolbar(with: newButton, and: nil)
  }
  
  func setupNewButton() {
    newButton = NewItemButton()
    newButton.setImage(UIImage(named: "+ New Button"), for: .normal)
    newButton.frame = CGRect(x: 0, y: 0, width: 44.0, height: 44.0)
    newButton.addTarget(self, action: #selector(newListPressed(sender:)), for: .touchUpInside)
  }
    
  @objc func newListPressed(sender: NewItemButton) {
    let popup = PopupFactory.newPmAlert { [weak self] in
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
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      store!.getAllLists()![indexPath.row].removeAllItems()
      store?.delete(object: store!.getAllLists()![indexPath.row])
      tableView.reloadData()
    }
  }
}

extension MasterListVC: MasterListUpdate {
  func updateMasterList() {
    self.tableView.reloadData()
  }
}
