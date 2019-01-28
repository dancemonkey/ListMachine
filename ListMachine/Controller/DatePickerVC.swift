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
  
  @IBOutlet weak var datePicker: FieldDatePicker!
  var date: Date?
  var saveDelegate: DateSaveDelegate?
  var mode: UIDatePicker.Mode?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setDateMode(to: mode!)
    datePicker.setDate(date ?? Date(), animated: true)
    self.title = "Select Date"
    
    styleViews()
  }
  
  func styleViews() {
    view.backgroundColor = Stylesheet.getColor(.white)
  }
  
  private func setDateMode(to mode: UIDatePicker.Mode) {
    datePicker.datePickerMode = mode
  }
  
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

extension DatePickerVC: UIPickerViewDelegate {

}

