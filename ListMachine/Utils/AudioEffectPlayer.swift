//
//  AudioEffectPlayer.swift
//  ListMachine
//
//  Created by Drew Lanning on 2/21/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import AVFoundation

enum EffectType: String {
  case delete, check, save, buttonTap
}

class AudioEffectPlayer {
  
  private var player: AVAudioPlayer?
  
  init() {
    do {
      try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .mixWithOthers)
      try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func play(effect type: EffectType) {
    guard let url = Bundle.main.url(forResource: type.rawValue, withExtension: "wav") else { return }
    do {
      try player = AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
    } catch {
      print(error.localizedDescription)
    }
    guard let aPlayer = player else { return }
    aPlayer.play()
  }
  
}
