//
//  ItemListVC.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/20/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit
import RealmSwift
import Hero

struct ItemListHeroIDs {
  var navTitle: String
  var tableView: String
}

class ItemListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ItemSaveDelegate, TemplateSaveDelegate {
  
  // MARK: Properties
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var searchBtn: UIBarButtonItem!
  @IBOutlet weak var sortBtn: UIBarButtonItem!
  @IBOutlet weak var searchBarHeight: NSLayoutConstraint!
  @IBOutlet weak var hiddenNavTitleLbl: UILabel!
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  var newItemButton: NewItemButton!
  var editTemplateButton: EditTemplateButton!
  
  var itemList: List!
  var store: DataStore?
  var sortKey: Int?
  var filterString: String = "" {
    didSet {
      tableView.reloadData()
    }
  }
  var isSearching = false
  var masterListDelegate: MasterListUpdate?
  var ascending: Bool = true
  var heroIDs: ItemListHeroIDs?
  var player: AudioEffectPlayer?
  
  let revealedSearchHeight: CGFloat = 56.0
  
  // MARK: View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.store = DataStore()
    
    self.title = itemList.name
    
    setupSort()
    
    tableView.delegate = self
    tableView.dataSource = self
    searchBar.delegate = self
    
    setupButtons()
    styleViews()
    setupHero()
    player = AudioEffectPlayer()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if itemList.templateItem!.defaultFields.count <= 1 {
      sortBtn.isEnabled = false
    } else {
      sortBtn.isEnabled = true
    }
  }
  
  // MARK: Setup and styling
  func setupButtons() {
    newItemButton = NewItemButton()
    newItemButton.setImageAndFrame()
    newItemButton.addTarget(self, action: #selector(newItemPressed(sender:)), for: .touchUpInside)
    
    editTemplateButton = EditTemplateButton()
    editTemplateButton.setImage(UIImage(named: "editTemplateButtonAlt"), for: .normal)
    editTemplateButton.frame = CGRect(x: 0, y: 0, width: 44.0, height: 44.0)
    editTemplateButton.addTarget(self, action: #selector(editTemplatePressed(sender:)), for: .touchUpInside)
  }
  
  func styleViews() {
    setupToolbar(with: newItemButton, and: editTemplateButton)
    view.backgroundColor = .white
    tableView.backgroundColor = .white
    searchBar.showsCancelButton = true
    searchBarHeight.constant = 0.0
    searchBar.alpha = 0.0
  }
  
  func setupHero() {
    if let IDs = heroIDs {
      hiddenNavTitleLbl.hero.id = IDs.navTitle
      tableView.hero.id = IDs.tableView
    }
  }
  
  func setupSort() {
    self.sortKey = itemList.sortKey.value
    self.ascending = itemList.sortAscending
    if sortKey != nil {
      sortList(by: sortKey!)
    } else {
      sortList(by: 0)
    }
  }
  
  func sortList(by sortKey: Int) {
    self.sortKey = sortKey
    store?.run(closure: { [weak self] in
      self?.itemList.sortKey.value = self?.sortKey
      self?.itemList.sortAscending = self?.ascending ?? true
    }, completion: nil)
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
    cell.setHeroId(for: indexPath.row)
    return cell
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let tableViewCell = cell as? ListItemCell else { return }
    tableViewCell.setCollectionViewDataSourceDelegate(delegate: self, forRow: indexPath.row)
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.tapFeedback()
    performSegue(withIdentifier: SegueID.showItemCreator.rawValue, sender: indexPath)
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let delete = UIContextualAction(style: .destructive, title: nil) { (_, _, success: (Bool) -> ()) in
      let item = self.itemList.getListSorted(by: self.sortKey ?? 0, andFilteredBy: self.filterString, ascending: self.ascending)[indexPath.row]
      item.prepareForDelete()
      self.store?.delete(object: item)
      tableView.deleteRows(at: [indexPath], with: .fade)
      success(true)
      self.masterListDelegate?.updateMasterList()
      self.view.successFeedback()
      self.player?.play(effect: .delete)
    }
    let share = UIContextualAction(style: .normal, title: nil) { [weak self] (_, _, _) in
      guard let item = self?.itemList.getListSorted(by: self?.sortKey ?? 0, andFilteredBy: self?.filterString, ascending: self?.ascending ?? false)[indexPath.row] else { return }
      DispatchQueue.main.async {
        guard let builder = ExportBuilder(with: item) else { return }
        let popup = builder.share(text: builder.getItemText() ?? "")
        self?.view.tapFeedback()
        self?.present(popup, animated: true, completion: nil)
      }
    }
    delete.image = UIImage(named: "delete")
    share.backgroundColor = Stylesheet.getColor(.accent)
    share.image = UIImage(named: "Share")
    return UISwipeActionsConfiguration(actions: [delete, share])
  }
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
      let item = self.itemList.getListSorted(by: self.sortKey ?? 0, andFilteredBy: self.filterString, ascending: self.ascending)[indexPath.row]
      item.prepareForDelete()
      self.store?.delete(object: item)
      tableView.deleteRows(at: [indexPath], with: .fade)
      self.masterListDelegate?.updateMasterList()
      self.view.successFeedback()
      self.player?.play(effect: .delete)
    }
    let share = UITableViewRowAction(style: .default, title: "Share") { [weak self] (_, indexPath) in
      guard let item = self?.itemList.getListSorted(by: self?.sortKey ?? 0, andFilteredBy: self?.filterString, ascending: self?.ascending ?? false)[indexPath.row] else { return }
      DispatchQueue.main.async {
        guard let builder = ExportBuilder(with: item) else { return }
        let popup = builder.share(text: builder.getItemText() ?? "")
        self?.view.tapFeedback()
        self?.present(popup, animated: true, completion: nil)
      }
    }
    share.backgroundColor = Stylesheet.getColor(.primary)
    return [delete, share]
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 75.0
  }
  
  // MARK: Actions
  @objc func newItemPressed(sender: NewItemButton) {
    self.player?.play(effect: .buttonTap)
    performSegue(withIdentifier: SegueID.showItemCreator.rawValue, sender: nil)
  }
  
  @objc func editTemplatePressed(sender: EditTemplateButton) {
    self.player?.play(effect: .buttonTap)
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
    guard itemList.templateItem!.defaultFields.count > 1 else {
      return
    }
    var fieldTitles: [String] = []
    for field in itemList.templateItem!.defaultFields {
      fieldTitles.append(field.name)
    }
    let popup: UIAlertController = PopupFactory.sortActionSheet(with: fieldTitles, sortedBy: self.sortKey, ascending: self.ascending) { (fieldIndex) in
      if self.sortKey! == fieldIndex {
        self.ascending = !self.ascending
      }
      self.sortList(by: fieldIndex)
    }
    self.present(popup, animated: true, completion: nil)
  }
  
  @IBAction func sharePressed(sender: UIBarButtonItem!) {
    DispatchQueue.main.async {
      guard let builder = ExportBuilder(with: self.itemList) else { return }
      let popup = builder.share(text: builder.getListText() ?? "")
      self.present(popup, animated: true, completion: nil)
    }
  }
  
  // MARK: Item Save Delegate
  func saveItem(_ item: Item) {
    store?.run(closure: {
      self.itemList.add(item: item)
    }, completion: {
      self.sortList(by: self.sortKey ?? 0)
    })
    masterListDelegate?.updateMasterList()
    tableView.reloadData()
  }
  
  func updateItem(_ item: Item, at row: Int) {
    store?.save(object: item) {
      self.itemList!.setLastUpdated()
    }
//    tableView.reloadRows(at: [IndexPath(item: row, section: 0)], with: .fade)
    masterListDelegate?.updateMasterList()
    tableView.reloadData()
  }
  
  // MARK: Template Save Delegate
  func saveTemplate(_ template: TemplateItem) {
    store?.save(object: itemList, andRun: {
      self.itemList.setTemplate(template)
    })
    setupSort()
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
        destVC.itemIndex = indexPath.row
        destVC.heroIDs = ItemCreateEditHeroIDs(navTitle: "\(HeroIDs.navTitle.rawValue)\(indexPath.row)", tableView: "\(HeroIDs.itemTableCell.rawValue)\(indexPath.row)")
      }
    } else if segue.identifier == SegueID.showTemplateEditor.rawValue {
      Stylesheet.setSlideUpTransition()
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
        self.store?.run(closure: {
          do {
            try field.flipBoolean()
          } catch {
            print(error)
          }
        }, completion: { [weak self] in
          self?.tableView.reloadRows(at: [IndexPath(item: collectionView.tag, section: 0)], with: .fade)
        })
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
