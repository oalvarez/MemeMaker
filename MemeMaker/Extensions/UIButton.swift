//
//  UIButton.swift
//  MemeMaker
//
//  Created by Oscar Alvarez Hidalgo on 11/25/19.
//  Copyright © 2019 Oscar Alvarez Hidalgo. All rights reserved.
//

import UIKit

class ViewFactory {
  static var requestVideoButton: UIButton {
    let button: UIButton = UIButton().with(height: 70, width: 150)
    button.backgroundColor = .gray
    return button
  }
  
  static var playerContainer: UIView {
    let button: UIView = UIView().aspectRation(9/16)
    button.backgroundColor = .systemBlue
    return button
  }
}
