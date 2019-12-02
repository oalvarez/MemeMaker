//
//  ProgressBar+Style.swift
//  MemeMaker
//
//  Created by Oscar Alvarez Hidalgo on 11/30/19.
//  Copyright © 2019 Oscar Alvarez Hidalgo. All rights reserved.
//

import UIKit

extension UIView {
  @discardableResult
  func progressBarStyle<T: UIView>() -> T {
    layer.cornerRadius = 18
    backgroundColor = .systemGray
    layer.masksToBounds = true
    return self as! T
  }
  
  @discardableResult
  func completeSectionStyle() -> UIView {
    self.backgroundColor = .systemBlue
    self
      .anchorToSuperview(leading: 0, bottom: 0)
      .with(height: 2, width: 0)
    return self
  }
}

extension UILabel {
  @discardableResult
  func progressTitleStyle(with title: String) -> UILabel {
    text = title
    font = UIFont(name: "TeluguSangamMN-Bold", size: 16)
    anchorToSuperview(top: 0, leading: 20, bottom: 0)
    textColor = .white
    return self
  }
  
  @discardableResult
  func progressValueStyle() -> UILabel {
    text = "0%"
    font = UIFont(name: "TeluguSangamMN-Bold", size: 16)
    anchorToSuperview(top: 0, bottom: 0, trailing: 20)
    textColor = .white
    return self
  }
}
