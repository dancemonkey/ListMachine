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
  @IBOutlet weak var sortSelect: SortSelectControl!
  @IBOutlet weak var searchBtn: UIBarButtonItem!
  @IBOutlet weak var sortBtn: UIBarButtonItem!
  @IBOutlet weak var searchBarHeight: NSLayoutConstraint!
  @IBOutlet weak var sortSelectHeight: NSLayoutConstraint!
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  var newItemButton: NewItemButton!
  var editTemplateButton: EditTemplateButton!
  
  var itemList: List!
  var store: DataStore?
  var sortKey: Int?
//  var previousSortKey: Int?
  var filterString: String = "" {
    didSet {
      tableView.reloadData()
    }
  }
  var isSearching = false
  var masterListDelegate: MasterListUpdate?
  var ascending: Bool = true
  
  let revealedSortHeight: CGFloat = 27.0
  let revealedSearchHeight: CGFloat = 56.0

  override func viewDidLoad() {
    super.viewDidLoad()
    self.store = DataStore()
    
    self.title = itemList.name
    
    setupSortSelect()
    
    tableView.delegate = self
    tableView.dataSource = self
    searchBar.delegate = self
    
    setupButtons()
    styleViews()
  }
  
  func setupButtons() {
    newItemButton = NewItemButton()
    newItemButton.setImageAndFrame()
    newItemButton.addTarget(self, action: #selector(newItemPressed(sender:)), for: .touchUpInside)
    
    editTemplateButton = EditTemplateButton()
    editTemplateButton.setImage(UIImage(named: "editTemplateButtonAlt"), for: .normal)
    editTemplateButton.frame = CGRect(x: 0, y: 0, width: 44.0, height: 44.0)
    editTemplateButton.addTarget(self, action: #selector(editTemplatePressed(sender:)), for: .touchUpInside)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if itemList.templateItem!.defaultFields.count <= 1 {
      sortBtn.isEnabled = false
    } else {
      sortBtn.isEnabled = true
    }
  }
  
  func styleViews() {
    setupToolbar(with: newItemButton, and: editTemplateButton)
    view.backgroundColor = .white //Stylesheet.getColor(.white)
    tableView.backgroundColor = .clear
    searchBar.showsCancelButton = true
    searchBarHeight.constant = 0.0
    searchBar.alpha = 0.0
    sortSelectHeight.constant = 0.0
    sortSelect.alpha = 0.0
  }
  
  // MARK: Helper Methods
  func setupSortSelect() {
    sortSelect.removeAllSegments()
    guard itemList.templateItem!.defaultFields.count > 1 else {
      return
    }
    sortSelect.addTarget(self, action: #selector(changeSortDirection(sender:)), for: .touchDown)
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
//    self.previousSortKey = sortKey
    tableView.reloadData()
  }
  
  func showSearchBar() {
    self.searchBarHeight.constant = self.revealedSearchHeight
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
      self.searchBar.alpha = 1.0
    }
  }
  
  func hideSearchBar() {
    self.searchBarHeight.constant = 0
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
      self.searchBar.alpha = 0.0
      self.searchBar.text = ""
      self.stopSearching()
    }
  }
  
  func showSortSelect() {
    guard itemList.templateItem!.defaultFields.count > 1 else { return }
    sortSelectHeight.constant = revealedSortHeight
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
      self.sortSelect.alpha = 1.0
    }
  }
  
  func hideSortSelect() {
    sortSelectHeight.constant = 0
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
      self.sortSelect.alpha = 0.0
    }
  }
  
  // MARK: Tableview Methods
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemList.getListSorted(by: sortKey ?? 0, andFilteredBy: filterString, ascending: ascending).count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CellID.listItemCell.rawValue) as! ListItemCell
    cell.configure(withItem: itemList.getListSorted(by: sortKey ?? 0, andFilteredBy: filterString, ascending: ascending)[indexPath.row])
    return cell
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let tableViewCell = cell as? ListItemCell else { return }
    tableViewCell.setCollectionViewDataSourceDelegate(delegate: self, forRow: indexPath.row)
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: SegueID.showItemCreator.rawValue, sender: indexPath)
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let item = itemList.getListSorted(by: sortKey ?? 0, andFilteredBy: filterString, ascending: ascending)[indexPath.row]
      item.prepareForDelete()
      store?.delete(object: item)
      tableView.deleteRows(at: [indexPath], with: .fade)
      masterListDelegate?.updateMasterList()
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 75.0
  }
  
  // MARK: Actions
  @objc func newItemPressed(sender: NewItemButton) {
    performSegue(withIdentifier: SegueID.showItemCreator.rawValue, sender: nil)
  }
  
  @objc func editTemplatePressed(sender: EditTemplateButton) {
    performSegue(withIdentifier: SegueID.showTemplateEditor.rawValue, sender: self.itemList.templateItem)
  }
  
  @IBAction func sortSelected(sender: SortSelectControl) {
    sortList(by: sender.selectedSegmentIndex)
  }
  
  @objc func changeSortDirection(sender: SortSelectControl) {
    ascending = !ascending
    tableView.reloadData()
  }
  
  @IBAction func searchPressed(sender: UIBarButtonItem!) {
    if searchBarHeight.constant == revealedSearchHeight {
      hideSearchBar()
    } else if searchBarHeight.constant == 0 {
      showSearchBar()
    }
  }
  
  @IBAction func sortPressed(sender: UIBarButtonItem!) {
    if sortSelectHeight.constant == revealedSortHeight {
      hideSortSelect()
    } else if sortSelectHeight.constant == 0 {
      showSortSelect()
    }
  }
  
  // MARK: Item Save Delegate
  func saveItem(_ item: Item) {
    store?.save(object: item, andRun: {
      self.itemList.add(item: item)
    })
    tableView.reloadData()
    masterListDelegate?.updateMasterList()
  }
  
  func updateItem(_ item: Item) {
    store?.save(object: item) {
      self.itemList!.setLastUpdated()
    }
    tableView.reloadData()
    masterListDelegate?.updateMasterList()
  }
  
  // MARK: Template Save Delegate
  func saveTemplate(_ template: TemplateItem) {
    store?.save(object: itemList, andRun: {
      self.itemList.setTemplate(template)
    })
    setupSortSelect()
    tableView.reloadData()
    masterListDelegate?.updateMasterList()
  }
  
  // MARK: Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == SegueID.showItemCreator.rawValue {
      let destVC = segue.destination as! ItemCreateEditVC
      destVC.itemSaveDelegate = self
      destVC.itemTemplate = self.itemList.templateItem
      destVC.store = self.store
      if let indexPath = (sender as? IndexPath) {
        destVC.item = itemList.getListSorted(by: sortKey ?? 0, andFilteredBy: filterString, ascending: ascending)[indexPath.row]
//        destVC.itemIndex = indexPath.row
      }
    } else if segue.identifier == SegueID.showTemplateEditor.rawValue {
      let dest = segue.destination as! TemplateCreateEditVC
      dest.itemTemplate = self.itemList.templateItem
      dest.saveDelegate = self
      dest.store = self.store
      dest.list = self.itemList
    }
  }
}

extension ItemListVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return itemList.listedItems[0].itemFields.count - 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.listItemCollectionCell.rawValue, for: indexPath) as! ListItemCollectionCell
    let item: Item = itemList.getListSorted(by: sortKey ?? 0, andFilteredBy: filterString, ascending: ascending)[collectionView.tag]
    let type: FieldType = FieldType(rawValue: item.itemFields[indexPath.row + 1].type) ?? .noType
    let value = item.itemFields[indexPath.item + 1].value ?? "No value set"
    let title = item.itemFields[indexPath.item + 1].name
    let field = item.itemFields[indexPath.item + 1]
    let payload = (value: value, title: title)
    cell.configure(withValue: payload.value, andTitle: payload.title, forType: type) {
      if type == FieldType.checkBox {
        self.store?.run {
          do {
            try field.flipBoolean()
          } catch {
            print(error)
          }
        }
        self.tableView.reloadData()
      }
    }
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
    searchBar.text = ""
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
    }
  }
  
  func buildSearchStringFor(field: ItemField, lookingFor string: String) -> String {
    let predicateString = "\(field.name) = '\(string)'"
    return predicateString
  }
  
}
