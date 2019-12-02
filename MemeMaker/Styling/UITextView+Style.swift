//
//  UITextView.swift
//  MemeMaker
//
//  Created by Oscar Alvarez Hidalgo on 11/28/19.
//  Copyright © 2019 Oscar Alvarez Hidalgo. All rights reserved.
//

import UIKit

extension UITextView {
  static func memeText(withTitle title: String) -> UITextView {
    let textView = UITextView()
    textView.textAlignment = .center
    textView.text = title
    textView.backgroundColor = .clear
    textView.textColor = .white
    textView.isScrollEnabled = false
    textView.sizeToFit()
    return textView
  }
  
  func font(named fontName: String, withSize size: CGFloat) -> UITextView {
    font = UIFont(name: fontName, size: size)
    return self
  }
}
