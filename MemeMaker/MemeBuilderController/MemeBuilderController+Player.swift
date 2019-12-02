//
//  MemeBuilderController+Player.swift
//  MemeMaker
//
//  Created by Oscar Alvarez Hidalgo on 12/1/19.
//  Copyright © 2019 Oscar Alvarez Hidalgo. All rights reserved.
//

import AVKit

extension MemeBuilderController {
  
  func preparePlayer(with url: URL) {
    let videoWidth = composer.getVideoWidth(ofVideoFrom: url,
                                            andPlayerFrame: playerContainer.frame)
    textView.with(width: videoWidth)
    playerView.preparePlayer(for: url)
    playerContainer.bringSubviewToFront(textView)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    for layer in playerContainer.layer.sublayers ?? [] {
      if layer is AVPlayerLayer {
        layer.frame = playerContainer.bounds
      }
    }
  }
}
