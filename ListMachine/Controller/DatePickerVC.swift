//
//  DatePickerVC.swift
//  ListMachine
//
//  Created by Drew Lanning on 1/2/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class DatePickerVC: UIViewController {
  
  enum ShortcutDate: Int {
    case today = 0
    case tomorrow = 1
    case plusDay = 2
    case plusWeek = 3
  }
  
  @IBOutlet weak var timeSwitch: UISwitch!
  @IBOutlet weak var datePicker: UIDatePicker!
  var date: Date?
  var saveDelegate: DateSaveDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    guard let existingDate = date else { return }
    datePicker.setDate(existingDate, animated: true)
    self.title = "Select Date"
  }
  
//  @IBAction func timeSwitchTapped(sender: UISwitch) {
//    defer {
//      datePicker.reloadInputViews()
//    }
//    if sender.isOn {
//      datePicker.datePickerMode = .dateAndTime
//    } else {
//      datePicker.datePickerMode = .date
//    }
//  }
  
  @IBAction func doneTapped(sender: UIButton) {
    saveDelegate?.saveSelectedDate(datePicker.date)
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
      datePicker.setDate(Calendar.current.date(byAdding: .day, value: 1, to: currentPickerValue) ?? Date(), animated: true)
    case .plusDay:
      datePicker.setDate(Calendar.current.date(byAdding: .day, value: 1, to: currentPickerValue) ?? Date(), animated: true)
    case .plusWeek:
      datePicker.setDate(Calendar.current.date(byAdding: .day, value: 7, to: currentPickerValue) ?? Date(), animated: true)
    }
  }
}

