//
//  ViewFactory.swift
//  MemeMaker
//
//  Created by Oscar Alvarez Hidalgo on 11/25/19.
//  Copyright © 2019 Oscar Alvarez Hidalgo. All rights reserved.
//

import UIKit

class ViewFactory {
  static var requestVideoButton: UIButton {
    let button: UIButton = UIButton().with(height: 70, width: 150)
    button.setTitle("Get Video", for: .normal)
    button.backgroundColor = .gray
    return button
  }
  
  static var composeVideoButton: UIButton {
    let button: UIButton = UIButton().with(height: 70)
    button.setTitle("Compose", for: .normal)
    button.backgroundColor = .gray
    return button
  }
  
  static var saveVideoButton: UIButton {
    let button: UIButton = UIButton().with(height: 70)
    button.setTitle("Save", for: .normal)
    button.backgroundColor = .gray
    return button
  }
  
  static var playerContainer: UIView {
    let playerContainer: UIView = UIView().aspectRation(9/16)
    playerContainer.contentMode = .scaleAspectFill
    playerContainer.backgroundColor = .systemBlue
    return playerContainer
  }
  
  static var textView: UITextView {
    let textView = UITextView()
    textView.font = UIFont(name: "IMPACTED", size: 28)
    textView.textAlignment = .center
    textView.text = "Introduce Text"
    textView.backgroundColor = .clear
    textView.isScrollEnabled = false
    textView.sizeToFit()
    return textView
  }
}
