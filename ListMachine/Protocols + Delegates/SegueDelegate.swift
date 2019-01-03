//
//  SegueProtocol.swift
//  ListMachine
//
//  Created by Drew Lanning on 1/2/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

protocol SegueDelegate {
  func segueRequested(to segue: SegueID?, sender: Any?)
}
