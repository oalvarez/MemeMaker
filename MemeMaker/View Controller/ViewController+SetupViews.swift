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
    setupDismissButton()
    view.addVStack(playerContainer,
                   getVideoButton,
                   composeButton,
                   saveButton,
                   UIView())
    
    playerContainer.anchorToSuperview(leading: 0)
    setupTextView()
    
    getVideoButton.addTarget(self, action: #selector(requestImage), for: .touchUpInside)
    composeButton.addTarget(self, action: #selector(compose), for: .touchUpInside)
    saveButton.addTarget(self, action: #selector(saveComposition), for: .touchUpInside)
  }
  
  func setupDismissButton() {
    view.addSubview(dismissButton)
    dismissButton.fillSuperView()
    dismissButton.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
  }
  
  func setupTextView() {
    playerContainer.addSubview(textView)
    textView.anchorToSuperview(bottom: 10)
      .centerInSuperview(vertically: false)
  }
}
