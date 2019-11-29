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
        .myStyle()
        .title(title)
        .with(height: 60, width: 200)
  }
  
  func myStyle() -> UIButton {
    self.layer.borderColor = UIColor.secondaryLabel.cgColor
    self.layer.borderWidth = 2
    self.layer.cornerRadius = 10
    self.titleLabel?.font = UIFont(name: "TeluguSangamMN-Bold", size: 20)
    self.backgroundColor = .systemBlue
    self.layer.masksToBounds = true
    return self
  }
  
  func title(_ text: String) -> UIButton {
    self.setTitle(text, for: .normal)
    return self
  }
}
