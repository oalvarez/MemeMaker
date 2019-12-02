//
//  ControlsView.swift
//  MemeMaker
//
//  Created by Oscar Alvarez Hidalgo on 12/1/19.
//  Copyright © 2019 Oscar Alvarez Hidalgo. All rights reserved.
//

import UIKit

class ControlsView: UIView {
  var delegate: ControlsHandler?
  let playButton = UIButton().playButton()
  
  func setupPlayButton() {
    addSubview(playButton)
    playButton.translatesAutoresizingMaskIntoConstraints = false
    playButton
      .centerInSuperview()
      .with(height: 100, width: 100)
    playButton.addTarget(self, action: #selector(playPauseHandler), for: .touchUpInside)
  }
  
  @objc func playPauseHandler() {
    delegate?.playPauseTapped()
  }
  
  init() {
    super.init(frame: .zero)
    backgroundColor = .init(white: 0, alpha: 0.3)
    setupPlayButton()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
