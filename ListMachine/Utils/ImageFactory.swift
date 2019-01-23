//
//  ImageNames.swift
//  ListMachine
//
//  Created by Drew Lanning on 1/23/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

class ImageFactory {
  
  static func booleanForItemCell(value: Bool) -> UIImage {
    let imageName: String = (value == true) ? "trueImage" : "falseImage"
    return UIImage(named: imageName)!
  }
  
}
