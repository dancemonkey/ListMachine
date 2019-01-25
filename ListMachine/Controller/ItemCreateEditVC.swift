//
//  ListViewVC.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/19/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class ItemCreateEditVC: UIViewController, UITableViewDelegate, UITableViewDataSource, FieldSaveDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  var itemTemplate: TemplateItem!
  var item: Item? = nil
  var itemIndex: Int?
  var itemSaveDelegate: ItemSaveDelegate?
  var store: DataStore?
  weak var senderDelegate: SegueSenderDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if item == nil {
      item = Item(from: itemTemplate)
    }
    
    self.title = item?.itemListTitle ?? "Untitled Item"
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(screenTapped(sender:)))
    self.view.addGestureRecognizer(tap)
    
    tableView.delegate = self
    tableView.dataSource = self
    
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    
    styleViews()
  }
  
  func styleViews() {
    view.backgroundColor = Stylesheet.getColor(.white)
    tableView.backgroundColor = .clear
  }
  
  // MARK: Tableview Methods
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemTemplate.defaultFields.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CellID.customFieldItemCell.rawValue) as? FieldItemCell
    cell?.configure(withField: itemTemplate.defaultFields[indexPath.row], andValue: item?.itemFields[indexPath.row].value)
    let type = FieldType(rawValue: itemTemplate.defaultFields[indexPath.row].type)!
    cell?.configureAction(for: type, with: self)
    return cell!
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: SegueID.showFieldValueEntry.rawValue, sender: indexPath)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch itemTemplate.defaultFields[indexPath.row].type {
    case "memo":
      return 125.0
    default:
      return 61.0
    }
  }
  
  // MARK: Nav Actions
  
  @IBAction func savePressed(sender: UIButton) {
    store?.run {
      for (idx, indexPath) in tableView.indexPathsForVisibleRows!.enumerated() {
        let cell = tableView.cellForRow(at: indexPath) as! FieldItemCell
        let field = item!.itemFields[idx]
        field.value = cell.valueView?.getSubviewValue
        item!.setValues(for: field, at: idx)
      }
    }
    if let i = itemIndex {
      itemSaveDelegate?.updateItem(self.item!, at: i)
    } else {
      itemSaveDelegate?.saveItem(item!)
    }
    navigationController?.popViewController(animated: true)
  }
  
  // MARK: Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == SegueID.showFieldValueEntry.rawValue {
      let dest = segue.destination as! FieldValueEditVC
      dest.currentField = item?.itemFields[(sender as! IndexPath).row]
      dest.currentFieldIdx = (sender as! IndexPath).row
      dest.saveDelegate = self
    } else if segue.identifier == SegueID.showDatePicker.rawValue {
      let dest = segue.destination as! DatePickerVC
      if let s = sender, let senderButton = s as? ItemFieldButton {
        switch senderButton.format! {
        case .dateAndTime:
          if let date = Stylesheet.dateAndTime(from: senderButton.titleLabel?.text) {
            dest.date = date
          } else if let date = Stylesheet.simpleDate(fromString: senderButton.titleLabel?.text) {
            dest.date = date
          }
          dest.mode = .dateAndTime
        case .simpleDate:
          if let date = Stylesheet.simpleDate(fromString: senderButton.titleLabel?.text) {
            dest.date = date
          } else if let date = Stylesheet.dateAndTime(from: senderButton.titleLabel?.text) {
            dest.date = date
          }
          dest.mode = .date
        }
        self.senderDelegate = senderButton
      }
      dest.saveDelegate = self
    }
  }
  
  // MARK: Save Protocol
  func saveField(_ field: ItemField) { }
  
  func update(_ field: ItemField, at index: Int) {
    store?.run {
      self.item?.setValues(for: field, at: index)
    }
    tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
  }
  
  // MARK: Keyboard management
  @objc func adjustForKeyboard(notification: Notification) {
    let userInfo = notification.userInfo!
    let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
    
    if notification.name == UIResponder.keyboardWillHideNotification {
      tableView.contentInset = UIEdgeInsets.zero
    } else {
      tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
    }
    tableView.scrollIndicatorInsets = tableView.contentInset
  }
  
  @objc func screenTapped(sender: UITapGestureRecognizer) {
    UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
  }
  
  // MARK: Helper Functions
  
  @objc func dateSelectTapped(sender: UIButton) {
    self.performSegue(withIdentifier: SegueID.showDatePicker.rawValue, sender: self)
  }
}

extension ItemCreateEditVC: SegueDelegate {
  func segueRequested(to segue: SegueID?, sender: Any?) {
    self.performSegue(withIdentifier: segue!.rawValue, sender: sender)
  }
}

extension ItemCreateEditVC: DateSaveDelegate {
  func saveSelectedDate(_ date: Date) {
    senderDelegate?.receivePayload(date)
  }
}
