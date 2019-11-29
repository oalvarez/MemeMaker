//
//  ViewController.swift
//  MemeMaker
//
//  Created by Oscar Alvarez Hidalgo on 11/25/19.
//  Copyright © 2019 Oscar Alvarez Hidalgo. All rights reserved.
//

import UIKit
import AVKit

enum Status {
  case ready
  case imported
  case composing
  case composed
  case saved
}

class ViewController: UIViewController {

  let getVideoButton = UIButton.myButton(withTitle: "Get Video")
  let composeButton = UIButton.myButton(withTitle: "Compose")
  let saveButton = UIButton.myButton(withTitle: "Save to Roll")
  let textView = UITextView.memeText(withTitle: "Introduce Text")
  let playerContainer = UIView.playerContainer
  let dismissButton = UIButton()
  
  var preferredTransform = CGAffineTransform.identity
  
  var mediaURL: URL? {
    didSet {
      guard let mediaURL = mediaURL else { return }
      preparePlayer(with: mediaURL)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }
  
  @objc func requestImage() { getMedia() }
  @objc func compose() { composeWithText(textView.text ?? "") }
  @objc func saveComposition() {
    guard let mediaURL = mediaURL else { return }
    saveVideo(with: mediaURL)
  }
  @objc func dismissKeyboard() -> Bool {
    textView.resignFirstResponder()
  }
}

extension ViewController {
  
  func preparePlayer(with url: URL) {
    let videoWidth = getVideoWidth(ofVideoFrom: url, andPlayerFrame: playerContainer.frame)
    textView.with(width: videoWidth)
    
    let player = AVPlayer(url: url)
    let playerLayer = AVPlayerLayer(player: player)
    playerLayer.frame = self.playerContainer.bounds
    self.playerContainer.layer.sublayers?.removeAll(where: { $0 is AVPlayerLayer } )
    self.playerContainer.layer.addSublayer(playerLayer)
    player.play()
    self.playerContainer.bringSubviewToFront(textView)
  }
  
  func getVideoWidth(ofVideoFrom url: URL, andPlayerFrame frame: CGRect) -> CGFloat {
    let videoAssetSource = AVAsset(url: url)
    guard let videoTrack = videoAssetSource.tracks(withMediaType: AVMediaType.video).first else { return 0 }
    let orientation = Orientation.getOrientation(from: videoTrack.preferredTransform)
    let size = videoTrack.naturalSize
    let ratio = size.height/size.width
    if orientation == .vertical { return frame.height * ratio }
    else                        { return frame.width }
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
