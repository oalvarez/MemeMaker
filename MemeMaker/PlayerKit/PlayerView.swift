//
//  PlayerView.swift
//  MemeMaker
//
//  Created by Oscar Alvarez Hidalgo on 11/30/19.
//  Copyright © 2019 Oscar Alvarez Hidalgo. All rights reserved.
//

import UIKit
import AVKit

class PlayerView: UIView {

  let controlsView = ControlsView()
  let playerLayer = AVPlayerLayer(player: AVPlayer(playerItem: nil))
  var status = PlayerStatus.paused {
    didSet { updatePlayer(with: status) }
  }
  var presentControls = false {
    didSet { showControls(presentControls) }
  }
  var controlsPresenterTimer = Timer()
  
  init() {
    super.init(frame: .zero)
    initializeControls()
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    playerLayer.frame = self.bounds
  }
  
  @objc func handleTap(gesture: UITapGestureRecognizer) {
    guard playerLayer.player?.currentItem != nil else { return }
    presentControls = true
  }
  
  @objc func playerDidFinish(notification: NSNotification) {
    playerLayer.player?.seek(to: .zero)
    status = .paused
  }
  
  func initializeControls() {
    NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinish), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    addGestureRecognizer(tapGesture)
    controlsView.delegate = self
    status = .paused
  }
  
  func preparePlayer(for url: URL) {
    let playerItem = AVPlayerItem(url: url)
    playerLayer.player?.replaceCurrentItem(with: playerItem)
    playerLayer.player?.play()
    status = .playing
    presentControls = true
  }
}

extension PlayerView: ControlsHandler {
  func playPauseTapped() {
    status.toggle()
  }
}
