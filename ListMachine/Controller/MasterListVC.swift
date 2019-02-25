//
//  MasterListVC.swift
//  ListMachine
//
//  Created by Drew Lanning on 1/7/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit
import RealmSwift
import StoreKit
import Hero

class MasterListVC: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  var newButton: NewItemButton!
  var store: DataStore?
  var player: AudioEffectPlayer?
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.store = DataStore()
    player = AudioEffectPlayer()
    tableView.delegate = self
    tableView.dataSource = self
    styleViews()
    checkReviewKey()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  func checkReviewKey() {
    let defaults = UserDefaults()
    if let reviewRequest = defaults.object(forKey: UserDefaultKeys.reviewRequested.rawValue) as? Bool {
      guard reviewRequest == false else { return }
      let lastDate = defaults.value(forKey: UserDefaultKeys.reviewRequestedDate.rawValue) as! Date
      if Date().interval(ofComponent: .day, fromDate: lastDate) > ReviewRequestInterval.firstRequest.rawValue {
        SKStoreReviewController.requestReview()
        defaults.set(true, forKey: UserDefaultKeys.reviewRequested.rawValue)
        defaults.set(Date(), forKey: UserDefaultKeys.reviewRequestedDate.rawValue)
      }
    } else {
      defaults.set(Date(), forKey: UserDefaultKeys.reviewRequestedDate.rawValue)
      defaults.set(false, forKey: UserDefaultKeys.reviewRequested.rawValue)
    }
  }
  
  func styleViews() {
    view.backgroundColor = .white
    tableView.backgroundColor = .white
    setupNewButton()
    setupToolbar(with: newButton, and: nil, and: nil)
  }
  
  func setupNewButton() {
    newButton = NewItemButton()
    newButton.setImageAndFrame()
    newButton.addTarget(self, action: #selector(newListPressed(sender:)), for: .touchUpInside)
  }
  
  @objc func newListPressed(sender: NewItemButton) {
    self.player?.play(effect: .buttonTap)
    let popup = PopupFactory.listTitleAlert(completion: { [weak self] in
      self?.tableView.reloadData()
      self?.player?.play(effect: .save)
      }, forList: nil)
    self.present(popup, animated: true, completion: nil)
  }
  
  // MARK: Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == SegueID.showListView.rawValue {
      let row = (sender as! IndexPath).row
      let dest = segue.destination as! ItemListVC
      dest.itemList = store?.getAllLists()?[row]
      dest.heroIDs = ItemListHeroIDs(navTitle: "\(HeroIDs.navTitle.rawValue)\(row)", tableView: "\(HeroIDs.mainTableCell.rawValue)\(row)")
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
    cell.setHeroId(for: indexPath.row)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.tapFeedback()
    performSegue(withIdentifier: SegueID.showListView.rawValue, sender: indexPath)
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let delete = UIContextualAction(style: .destructive, title: nil) { (_, _, success: @escaping (Bool) -> ()) in
      let confirmation = PopupFactory.confirmationRequest(action: { [weak self] in
        self?.store?.delete(list: (self?.store!.getAllLists()![indexPath.row])!)
        self?.tableView.deleteRows(at: [indexPath], with: .fade)
        self?.view.tapFeedback()
        success(true)
        self?.player?.play(effect: .delete)
      })
      self.present(confirmation, animated: true, completion: nil)
    }
    let edit = UIContextualAction(style: .normal, title: nil) { (_, _, success: (Bool) -> ()) in
      let controller = PopupFactory.listTitleAlert(completion: { [weak self] in
        self?.tableView.reloadData()
        }, forList: self.store!.getAllLists()![indexPath.row])
      self.view.tapFeedback()
      success(true)
      self.present(controller, animated: true, completion: nil)
    }
    let share = UIContextualAction(style: .normal, title: nil) { [weak self] (_, _, success: (Bool) -> ()) in
      guard let builder = ExportBuilder(with: self?.store?.getAllLists()?[indexPath.row]) else { return }
      success(true)
      DispatchQueue.main.async {
        let popup = builder.share(text: builder.getListText() ?? "")
        self?.present(popup, animated: true, completion: nil)
        self?.view.tapFeedback()
      }
    }
    edit.image = UIImage(named: "edit")
    delete.image = UIImage(named: "delete")
    share.backgroundColor = Stylesheet.getColor(.accent)
    share.image = UIImage(named: "Share")
    
    return UISwipeActionsConfiguration(actions: [delete, edit, share])
  }
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
      let confirmation = PopupFactory.confirmationRequest(action: { [weak self] in
        self?.store?.delete(list: (self?.store!.getAllLists()![indexPath.row])!)
        self?.tableView.reloadData()
        self?.view.tapFeedback()
        self?.player?.play(effect: .delete)
      })
      self.present(confirmation, animated: true, completion: nil)
    }
    let edit = UITableViewRowAction(style: .normal, title: "Edit") { (_, indexPath) in
      let controller = PopupFactory.listTitleAlert(completion: { [weak self] in
        self?.tableView.reloadData()
        }, forList: self.store!.getAllLists()![indexPath.row])
      self.view.tapFeedback()
      self.present(controller, animated: true, completion: nil)
    }
    let share = UITableViewRowAction(style: .normal, title: "Share") { [weak self] (_, indexPath) in
      guard let builder = ExportBuilder(with: self?.store?.getAllLists()?[indexPath.row]) else { return }
      DispatchQueue.main.async {
        let popup = builder.share(text: builder.getListText() ?? "")
        self?.present(popup, animated: true, completion: nil)
        self?.view.tapFeedback()
      }
    }
    share.backgroundColor = Stylesheet.getColor(.primary)
    return [delete, edit, share]
  }
}

extension MasterListVC: MasterListUpdate {
  func updateMasterList() {
    self.tableView.reloadData()
  }
}
