//
//  Player+SetupViews.swift
//  MemeMaker
//
//  Created by Oscar Alvarez Hidalgo on 12/1/19.
//  Copyright © 2019 Oscar Alvarez Hidalgo. All rights reserved.
//

import UIKit

extension PlayerView {
  
  
  
  func setupViews() {
    layer.addSublayer(playerLayer)
    fillView(with: controlsView)
    controlsView.isHidden = true
  }
  
  func updatePlayer(with status: PlayerStatus) {
    switch status {
    case .playing:
      playerLayer.player?.play()
      controlsView.playButton.setImage(UIImage(named:"pause"), for: .normal)
    case .paused:
      playerLayer.player?.pause()
      controlsView.playButton.setImage(UIImage(named:"play"), for: .normal)
    }
  }
  
  func showControls(_ show: Bool) {
    controlsPresenterTimer.invalidate()
    if show == true { controlsView.isHidden = false }
    UIView.animate(withDuration: 0.2, animations: {
      self.controlsView.alpha = show ? 1.0 : 0.0
    }, completion: { _ in
      self.controlsView.isHidden = !show
    })
    guard show == true else { return }
    controlsPresenterTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { timer in
      self.showControls(false)
    })
  }
}
