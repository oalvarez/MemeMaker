//
//  ViewController.swift
//  MemeMaker
//
//  Created by Oscar Alvarez Hidalgo on 11/25/19.
//  Copyright © 2019 Oscar Alvarez Hidalgo. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation
import AVKit

class ViewController: UIViewController {

  let button = ViewFactory.requestVideoButton
  let playerContainer = ViewFactory.playerContainer
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(button)
    button.addTarget(self, action: #selector(requestImage), for: .touchUpInside)
    button.centerInSuperview()
    view.addSubview(playerContainer)
    playerContainer.anchorToSuperview(top: 0, leading: 0, trailing: 0)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    for layer in playerContainer.layer.sublayers ?? [] {
      if layer is AVPlayerLayer {
        layer.frame = playerContainer.bounds
      }
    }
  }

  @objc func requestImage() { getMedia() }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func getMedia() {
    let mediaPicker = UIImagePickerController()
    mediaPicker.delegate = self
    mediaPicker.mediaTypes = ["public.movie"]
    present(mediaPicker, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    guard let mediaURL = info[.mediaURL] as? URL else { return }
    
    self.dismiss(animated: true) {
      let player = AVPlayer(url: mediaURL)
      let playerLayer = AVPlayerLayer(player: player)
      playerLayer.frame = self.playerContainer.bounds
      self.playerContainer.layer.addSublayer(playerLayer)
      player.play()
    }
  }
}

