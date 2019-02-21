//
//  ItemFieldSwitch.swift
//  ListMachine
//
//  Created by Drew Lanning on 12/31/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class ItemFieldSwitch: UISwitch, CustomFieldUIViewProtocol {
  
  var fieldSave: ((_: String) -> ())? = nil
  var player: AudioEffectPlayer?

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  var reportValue: String {
    return self.isOn.description
  }
  
  internal func configure(with field: ItemField, and value: String?) {
    let checked: Bool? = Bool(value ?? "false")
    self.isOn = checked ?? false
    self.onTintColor = Stylesheet.getColor(.primary)
    self.addTarget(self, action: #selector(saveField), for: .valueChanged)
    player = AudioEffectPlayer()
  }
  
  @objc func saveField() {
    if let save = fieldSave {
      save(reportValue)
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    player?.play(effect: .check)
  }

}
