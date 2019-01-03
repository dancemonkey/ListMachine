//
//  DatePickerVC.swift
//  ListMachine
//
//  Created by Drew Lanning on 1/2/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class DatePickerVC: UIViewController {
  
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
  
  @IBAction func timeSwitchTapped(sender: UISwitch) {
    defer {
      datePicker.reloadInputViews()
    }
    if sender.isOn {
      datePicker.datePickerMode = .dateAndTime
    } else {
      datePicker.datePickerMode = .date
    }
  }
  
  @IBAction func doneTapped(sender: UIButton) {
    saveDelegate?.saveSelectedDate(datePicker.date)
    navigationController?.popViewController(animated: true)
  }
}

