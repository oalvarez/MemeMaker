//
//  ViewController.swift
//  MemeMaker
//
//  Created by Oscar Alvarez Hidalgo on 11/25/19.
//  Copyright © 2019 Oscar Alvarez Hidalgo. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {

  enum Status {
    case ready
    case imported
    case composing
    case composed
    case saved
  }
  
  let getVideoButton = UIButton.myButton(withTitle: "Get Video")
  let composeButton = UIButton.myButton(withTitle: "Compose")
  let saveButton = UIButton.myButton(withTitle: "Save to Roll")
  let cancelButton = UIButton.myButton(withTitle: "Cancel")
  let textView = UITextView.memeText(withTitle: "Introduce Text")
  let playerContainer = UIView.playerContainer
  let dismissButton = UIButton()
  let progressBar: ProgressBar = ProgressBar(with: "Composing...")
  
  var status: Status = .ready {
    didSet { updateView(with: status) }
  }
  
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
  
  var composer = Composer()
  
  @objc func requestImage() { getMedia() }
  @objc func compose() {
    guard let mediaURL = mediaURL else { return }
    status = .composing
    
    let textLayer = composer.createTextLayerForVideo(at:           mediaURL,
                                                     text:         textView.text,
                                                     fontName:     "IMPACTED",
                                                     playerSize:   playerContainer.frame.size,
                                                     textViewSize: textView.frame.size)
    
    composer.composeVideo(at: mediaURL,
                          withLayer: textLayer,
                          trackProgress: { progress in
      self.progressBar.update(with: progress)
    }) { result in
      switch result {
      case .success(let url):
        DispatchQueue.main.async {
          self.status = .composed
          self.mediaURL = url
        }
      case .failure(let error):
        DispatchQueue.main.async {
          self.status = .imported
        }
        print(error.localizedDescription)
      }
    }
  }
  
  @objc func saveComposition() {
    guard let mediaURL = mediaURL else { return }
    composer.saveVideo(with: mediaURL) { result in
      switch result {
      case .success:
        DispatchQueue.main.async {
          self.status = .saved
        }
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
  @objc func dismissKeyboard() -> Bool {
    textView.resignFirstResponder()
  }
  @objc func cancelExport() {
    composer.cancelExport()
  }
}

extension ViewController {
  
  func preparePlayer(with url: URL) {
    let videoWidth = getVideoWidth(ofVideoFrom: url, andPlayerFrame: playerContainer.frame)
    let player = AVPlayer(url: url)
    let playerLayer = AVPlayerLayer(player: player)
    
    textView.with(width: videoWidth)
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
