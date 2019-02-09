//
//  CreateEditTemplateVC.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/22/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit
import ViewAnimator

class TemplateCreateEditVC: UIViewController, UITableViewDelegate, UITableViewDataSource, FieldSaveDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  var newFieldBtn: NewItemButton!
  var itemTemplate: TemplateItem!
  var list: List!
  var saveDelegate: TemplateSaveDelegate?
  var store: DataStore?
  var snapshot: UIView?
  var sourceIndexPath: IndexPath? = nil
  var longPress: UILongPressGestureRecognizer?
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = itemTemplate.name + " Template"
    tableView.delegate = self
    tableView.dataSource = self
    longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressStarted(sender:)))
    view.addGestureRecognizer(longPress!)
    
    setupNewButton()
    styleViews()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    UIView.animate(views: tableView.visibleCells, animations: [AnimationType.from(direction: .bottom, offset: 50.0)])
  }
  
  func setupNewButton() {
    newFieldBtn = NewItemButton()
    newFieldBtn.setImageAndFrame()
    newFieldBtn.addTarget(self, action: #selector(addNewFieldPressed(sender:)), for: .touchUpInside)
  }
  
  func styleViews() {
    view.backgroundColor = .white //Stylesheet.getColor(.white)
    tableView.backgroundColor = .clear
    setupToolbar(with: newFieldBtn, and: nil)
  }
  
  // MARK: Tableview Methods
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemTemplate.defaultFields.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CellID.templateFieldCell.rawValue) as! TemplateFieldCell
    cell.configure(with: itemTemplate.defaultFields[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: SegueID.showTemplateEditor.rawValue, sender: indexPath.row)
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
  }
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
      self.store?.delete(object: self.itemTemplate.defaultFields[indexPath.row])
      self.saveDelegate?.saveTemplate(self.itemTemplate)
      self.tableView.deleteRows(at: [indexPath], with: .fade)
    }
    return [delete]
  }
  
  // MARK: Actions
  
  @objc func addNewFieldPressed(sender: NewItemButton) {
    performSegue(withIdentifier: SegueID.showTemplateEditor.rawValue, sender: self)
  }
  
  // MARK: Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == SegueID.showTemplateEditor.rawValue {
      let dest = segue.destination as! TemplateFieldEditVC
      dest.saveDelegate = self
      dest.currentFieldIndex = itemTemplate.defaultFields.count
      if let index = (sender as? Int) {
        dest.currentField = itemTemplate.defaultFields[index]
        dest.currentFieldIndex = index
      }
    }
  }
  
  // MARK: FieldSaveDelegate
  func saveField(_ field: ItemField) {
    store?.save(object: field, andRun: {
      self.itemTemplate.add(field: field)
    })
    saveDelegate?.saveTemplate(itemTemplate)
    tableView.reloadData()
  }
  
  func update(_ field: ItemField, at index: Int) {
    store?.save(object: field, andRun: {
      self.itemTemplate.update(field: field, at: index)
    })
    saveDelegate?.saveTemplate(itemTemplate)
    tableView.reloadData()
  }
}

extension TemplateCreateEditVC: DraggableCell {
  
  @objc func longPressStarted(sender: UILongPressGestureRecognizer) {
    let state = sender.state
    let location = sender.location(in: self.tableView)
    let indexPath = tableView.indexPathForRow(at: location)
    
    switch state {
    case .began:
      if indexPath != nil {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        sourceIndexPath = indexPath
        let cell = self.tableView.cellForRow(at: indexPath!)!
        snapshot = customSnapshotFromView(inputView: cell)
        var center = cell.center
        snapshot!.center = center
        snapshot!.alpha = 0.0
        tableView.addSubview(snapshot!)
        
        UIView.animate(withDuration: 0.25, animations: {
          center.y = location.y
          self.snapshot!.center = center
          self.snapshot!.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
          self.snapshot!.alpha = 0.98
          
          cell.alpha = 0.0
        }, completion: { (finished) in
          cell.isHidden = true
        })
      }
    case .changed:
      var center = snapshot!.center
      center.y = location.y
      snapshot!.center = center
      if indexPath != nil && !(indexPath! == sourceIndexPath!) {
        tableView.moveRow(at: sourceIndexPath!, to: indexPath!)
        store?.run {
          self.itemTemplate.moveField(from: sourceIndexPath!.row, to: indexPath!.row)
        }
        sourceIndexPath = indexPath
      }
      saveDelegate?.saveTemplate(itemTemplate)
    default:
      let cell = tableView.cellForRow(at: sourceIndexPath!)
      cell?.isHidden = false
      cell?.alpha = 0.0
      UIView.animate(withDuration: 0.25, animations: {
        self.snapshot!.center = cell!.center
        self.snapshot!.transform = CGAffineTransform.identity
        self.snapshot!.alpha = 0.0
        cell?.alpha = 1.0
      }, completion: { (finished) in
        self.sourceIndexPath = nil
        self.snapshot?.removeFromSuperview()
        self.snapshot = nil
      })
    }
  }
  
}
