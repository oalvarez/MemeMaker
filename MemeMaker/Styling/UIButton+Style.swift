//
//  UIButton.swift
//  MemeMaker
//
//  Created by Oscar Alvarez Hidalgo on 11/28/19.
//  Copyright © 2019 Oscar Alvarez Hidalgo. All rights reserved.
//

import UIKit

extension UIButton {
  static func myButton(withTitle title: String) -> UIButton {
      return UIButton()
        .buttonStyle()
        .title(title)
        .with(height: 60, width: 200)
  }
  
  func buttonStyle() -> UIButton {
    layer.borderColor = UIColor.secondaryLabel.cgColor
    layer.borderWidth = 2
    layer.cornerRadius = 10
    titleLabel?.font = UIFont(name: "TeluguSangamMN-Bold", size: 20)
    backgroundColor = .systemBlue
    layer.masksToBounds = true
    return self
  }
  
  func title(_ text: String) -> UIButton {
    setTitle(text, for: .normal)
    return self
  }
}
