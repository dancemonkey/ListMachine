//
//  DatePickerVC.swift
//  ListMachine
//
//  Created by Drew Lanning on 1/2/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class DatePickerVC: UIViewController {
  
  @IBOutlet var shortcutButtons: [UIButton]!
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  enum ShortcutDate: Int {
    case today = 0
    case tomorrow = 1
    case plusDay = 2
    case plusWeek = 3
  }
  
  @IBOutlet weak var datePicker: FieldDatePicker!
  @IBOutlet weak var clearButton: UIButton!
  var date: Date?
  var saveDelegate: DateSaveDelegate?
  var mode: UIDatePicker.Mode?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setDateMode(to: mode!)
    if self.date == nil {
      self.date = Date()
    }
    datePicker.setDate(date!, animated: true)
    self.title = "Select Date"
    
    styleViews()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    Stylesheet.setSlideUpTransition()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    Stylesheet.setSlideDownTransition()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    Stylesheet.setAutoTransition()
  }
  
  func styleViews() {
    view.backgroundColor = .white //Stylesheet.getColor(.white)
    for button in shortcutButtons {
      button.setTitleColor(Stylesheet.getColor(.accent), for: .normal)
    }
    setupToolbar(with: nil, and: nil, and: nil)
    clearButton.tintColor = Stylesheet.getColor(.primary)
  }
  
  private func setDateMode(to mode: UIDatePicker.Mode) {
    datePicker.datePickerMode = mode
  }
  
  @IBAction func doneTapped(sender: UIButton) {
    saveDelegate?.saveSelectedDate(datePicker.date)
    view.successFeedback()
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func clearTapped(sender: UIButton) {
    saveDelegate?.saveSelectedDate(nil)
    view.successFeedback()
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func shortcutDateBtnTapped(sender: UIButton) {
    guard let shortcut = ShortcutDate(rawValue: sender.tag) else { return }
    let today = Date()
    let currentPickerValue = datePicker.date
    switch shortcut {
    case .today:
      datePicker.setDate(today, animated: true)
    case .tomorrow:
      datePicker.setDate(Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date(), animated: true)
    case .plusDay:
      datePicker.setDate(Calendar.current.date(byAdding: .day, value: 1, to: currentPickerValue) ?? Date(), animated: true)
    case .plusWeek:
      datePicker.setDate(Calendar.current.date(byAdding: .day, value: 7, to: currentPickerValue) ?? Date(), animated: true)
    }
  }
}

extension DatePickerVC: UIPickerViewDelegate {

}

