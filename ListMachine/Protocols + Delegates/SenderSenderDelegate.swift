//
//  SenderDelegate.swift
//  ListMachine
//
//  Created by Drew Lanning on 1/3/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import Foundation

protocol SegueSenderDelegate: AnyObject {
  func receivePayload(_ value: Date) 
}
