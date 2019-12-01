//
//  UIView+Style.swift
//  MemeMaker
//
//  Created by Oscar Alvarez Hidalgo on 11/28/19.
//  Copyright © 2019 Oscar Alvarez Hidalgo. All rights reserved.
//

import UIKit

extension UIView {
  static var playerContainer: UIView {
    let playerContainer: UIView = UIView().aspectRation(9/16)
    playerContainer.contentMode = .scaleAspectFill
    playerContainer.backgroundColor = .secondaryLabel
    return playerContainer
  }
}
