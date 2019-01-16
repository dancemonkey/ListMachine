//
//  ItemListVC.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/20/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit
import RealmSwift

class ItemListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ItemSaveDelegate, TemplateSaveDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var sortSelect: UISegmentedControl!
  var itemList: List!
  var store: DataStore?
  var sortKey: Int?
  var filterString: String = "" {
    didSet {
      print("filterString set, reloading table")
      tableView.reloadData()
    }
  }
  var isSearching = false

  override func viewDidLoad() {
    super.viewDidLoad()
    self.store = DataStore()
    
    self.title = itemList.name
    
    setupSortSelect()
    
    tableView.delegate = self
    tableView.dataSource = self
    searchBar.delegate = self
  }
  
  // MARK: Helper Methods
  func setupSortSelect() {
    sortSelect.removeAllSegments()
    guard itemList.templateItem!.defaultFields.count > 1 else { return }
    for (index, field) in itemList.templateItem!.defaultFields.enumerated() {
      sortSelect.insertSegment(withTitle: field.name, at: index, animated: true)
    }
    if itemList.sortKey.value != nil {
      sortList(by: itemList.sortKey.value!)
      sortSelect.selectedSegmentIndex = itemList.sortKey.value!
    } else {
      sortSelect.selectedSegmentIndex = 0
      sortList(by: sortSelect.selectedSegmentIndex)
    }
  }
  
  func sortList(by sortKey: Int) {
    self.sortKey = sortKey
    tableView.reloadData()
  }
  
  // MARK: Tableview Methods
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemList.getListSorted(by: sortKey ?? 0, andFilteredBy: filterString).count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CellID.listItemCell.rawValue) as! ListItemCell
    cell.configure(withItem: itemList.getListSorted(by: sortKey ?? 0, andFilteredBy: filterString)[indexPath.row])
    return cell
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let tableViewCell = cell as? ListItemCell else { return }
    tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: SegueID.showItemCreator.rawValue, sender: indexPath)
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      store?.delete(object: itemList.getListSorted(by: sortKey ?? 0, andFilteredBy: filterString)[indexPath.row])
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 75.0
  }
  
  // MARK: Actions
  @IBAction func newItemPressed(sender: UIBarButtonItem) {
    performSegue(withIdentifier: SegueID.showItemCreator.rawValue, sender: nil)
  }
  
  @IBAction func editTemplatePressed(sender: UIBarButtonItem) {
    performSegue(withIdentifier: SegueID.showTemplateEditor.rawValue, sender: self.itemList.templateItem)
  }
  
  @IBAction func sortSelected(sender: UISegmentedControl) {
    sortList(by: sender.selectedSegmentIndex)
  }
  
  // MARK: Item Save Delegate
  func saveItem(_ item: Item) {
    store?.save(object: item, andRun: {
      self.itemList.add(item: item)
    })
    tableView.reloadData()
  }
  
  func updateItem(_ item: Item, at index: Int) {
    store?.save(object: item, andRun: nil)
    tableView.reloadData()
  }
  
  // MARK: Template Save Delegate
  func saveTemplate(_ template: TemplateItem) {
    store?.save(object: itemList, andRun: {
      self.itemList.setTemplate(template)
    })
    setupSortSelect()
    tableView.reloadData()
  }
  
  // MARK: Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == SegueID.showItemCreator.rawValue {
      let destVC = segue.destination as! ItemCreateEditVC
      destVC.itemSaveDelegate = self
      destVC.itemTemplate = self.itemList.templateItem
      destVC.store = self.store
      if let indexPath = (sender as? IndexPath) {
        destVC.item = itemList.getListSorted(by: sortKey ?? 0, andFilteredBy: filterString)[indexPath.row]
        destVC.itemIndex = indexPath.row
        print("selected row: \(indexPath.row)")
      }
    } else if segue.identifier == SegueID.showTemplateEditor.rawValue {
      let dest = segue.destination as! TemplateCreateEditVC
      dest.itemTemplate = self.itemList.templateItem
      dest.saveDelegate = self
      dest.store = self.store
    }
  }
}

extension ItemListVC: UICollectionViewDataSource, UICollectionViewDelegate {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return itemList.listedItems[0].itemFields.count - 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.listItemCollectionCell.rawValue, for: indexPath) as! ListItemCollectionCell
    
    let payload = (value: itemList.getListSorted(by: sortKey ?? 0, andFilteredBy: filterString)[collectionView.tag].itemFields[indexPath.item + 1].value ?? "No value set", title: itemList.getListSorted(by: sortKey ?? 0, andFilteredBy: filterString)[collectionView.tag].itemFields[indexPath.item + 1].name)
    cell.configure(withValue: payload.value, andTitle: payload.title)

    return cell
  }
}

extension ItemListVC: UISearchBarDelegate {
  
  func stopSearching() {
    searchBar.resignFirstResponder()
    isSearching = false
    filterString = searchBar.text ?? ""
    tableView.reloadData()
  }
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    isSearching = true
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    stopSearching()
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    stopSearching()
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    stopSearching()
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.count == 0 {
      stopSearching()
    } else {
      filterString = searchText
      print(filterString)
    }
  }
  
  func buildSearchStringFor(field: ItemField, lookingFor string: String) -> String {
    let predicateString = "\(field.name) = '\(string)'"
    return predicateString
  }
  
}
