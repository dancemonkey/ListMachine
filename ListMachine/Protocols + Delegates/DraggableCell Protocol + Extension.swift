//
//  DraggableCell Protocol + Extension.swift
//  ListMachine
//
//  Created by Drew Lanning on 1/10/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import UIKit

protocol DraggableCell {
  var snapshot: UIView? { get set }
  var tableView: UITableView! { get set }
  func customSnapshotFromView(inputView: UIView) -> UIView
  func longPressStarted(sender: UILongPressGestureRecognizer)
}

extension DraggableCell {
  func customSnapshotFromView(inputView: UIView) -> UIView {
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
    inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    let snapshot = UIImageView.init(image: image)
    snapshot.layer.masksToBounds = false
    snapshot.layer.cornerRadius = 0.0
    snapshot.layer.shadowRadius = 5.0
    snapshot.layer.shadowOffset = CGSize(width: -5, height: -0)
    snapshot.layer.shadowOpacity = 0.4
    
    return snapshot
  }
}
