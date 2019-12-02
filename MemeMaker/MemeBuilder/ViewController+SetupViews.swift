//
//  ViewController+SetupViews.swift
//  MemeMaker
//
//  Created by Oscar Alvarez Hidalgo on 11/28/19.
//  Copyright © 2019 Oscar Alvarez Hidalgo. All rights reserved.
//

import UIKit

extension ViewController {
  func setupViews() {
    status = .ready
    setupStack()
    setupTextView()
    getVideoButton.addTarget(self, action: #selector(requestImage), for: .touchUpInside)
    composeButton.addTarget(self,  action: #selector(compose), for: .touchUpInside)
    saveButton.addTarget(self,     action: #selector(saveComposition), for: .touchUpInside)
    cancelButton.addTarget(self,   action: #selector(cancelExport), for: .touchUpInside)
  }
  
  func setupStack() {
    let stack = UIStackView.with(
      playerContainer,
      progressBar,
      cancelButton,
      getVideoButton,
      composeButton,
      saveButton,
      UIView()
    )
    view.fillView(with: stack)
    let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    stack.addGestureRecognizer(gesture)
    playerContainer.anchorToSuperview(leading: 0)
    progressBar.anchorToSuperview(leading: 40)
    progressBar.with(height: 36)
  }
  
  func setupTextView() {
    playerContainer.addSubview(textView)
    textView
    .font(named: fontName, withSize: fontSize)
      .anchorToSuperview(bottom: 10)
      .centerInSuperview(vertically: false)
  }
  
  func updateView(with status: Status) {
    textView.isHidden = true
    getVideoButton.isHidden = true
    composeButton.isHidden = true
    saveButton.isHidden = true
    progressBar.isHidden = true
    cancelButton.isHidden = true
    
    switch status {
      
    case .ready:
      getVideoButton.isHidden = false
    case .imported:
      textView.isHidden = false
      getVideoButton.isHidden = false
      composeButton.isHidden = false
      /*
       slider for size
       buttons for color
       */
    case .composing:
      progressBar.isHidden = false
      cancelButton.isHidden = false
    case .composed:
      getVideoButton.isHidden = false
      saveButton.isHidden = false
    case .saved:
      getVideoButton.isHidden = false
    }
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
    }
  }
}
