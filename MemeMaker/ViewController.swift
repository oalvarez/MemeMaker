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
import Photos

enum Status {
  case videoNeeded
  case introduceText
  case composed
  case saved
}

class ViewController: UIViewController {

  let getVideoButton = ViewFactory.requestVideoButton
  let composeButton = ViewFactory.composeVideoButton
  let saveButton = ViewFactory.saveVideoButton
  let textView = ViewFactory.textView
  let playerContainer = ViewFactory.playerContainer
  let dismissButton = UIButton()
  
  var preferredTransform = CGAffineTransform.identity
  
  var mediaURL: URL? {
    didSet {
      guard let mediaURL = mediaURL else { return }
      
      let videoWidth = getVideoWidth(ofVideoFrom: mediaURL, andPlayerFrame: playerContainer.frame)
      textView.with(width: videoWidth)
      
      let player = AVPlayer(url: mediaURL)
      let playerLayer = AVPlayerLayer(player: player)
      playerLayer.frame = self.playerContainer.bounds
      self.playerContainer.layer.sublayers?.removeAll(where: { $0 is AVPlayerLayer } )
      self.playerContainer.layer.addSublayer(playerLayer)
      player.play()
      self.playerContainer.bringSubviewToFront(textView)
    }
  }
  
  func getVideoWidth(ofVideoFrom url: URL, andPlayerFrame frame: CGRect) -> CGFloat {
    let videoAssetSource = AVAsset(url: url)
    guard let videoTrack = videoAssetSource.tracks(withMediaType: AVMediaType.video).first else { return 0 }
    let orientation = getOrientation(from: videoTrack.preferredTransform)
    let size = videoTrack.naturalSize
    let ratio = size.height/size.width
    if orientation == .vertical { return frame.height * ratio }
    else                        { return frame.width }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(dismissButton)
    dismissButton.fillSuperView()
    dismissButton.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
    
    view.addSubview(playerContainer)
    playerContainer.anchorToSuperview(top: 0, leading: 0, trailing: 0)
    
    view.addSubview(getVideoButton)
    getVideoButton.addTarget(self, action: #selector(requestImage), for: .touchUpInside)
    getVideoButton.anchorToSuperview(leading: 40, trailing: 40)
      .anchorTop(to: playerContainer.bottomAnchor, by: 20)
    
    view.addSubview(composeButton)
    composeButton.anchorToSuperview(leading: 40, trailing: 40)
      .anchorTop(to: getVideoButton.bottomAnchor, by: 20)
    composeButton.addTarget(self, action: #selector(compose), for: .touchUpInside)
    
    view.addSubview(saveButton)
    saveButton.anchorToSuperview(leading: 40, trailing: 40)
      .anchorTop(to: composeButton.bottomAnchor, by: 20)
    saveButton.addTarget(self, action: #selector(saveComposition), for: .touchUpInside)
    
    playerContainer.addSubview(textView)
    textView.anchorToSuperview(bottom: 10)
      .centerInSuperview(vertically: false)
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
  @objc func compose() { composeWithText(textView.text ?? "") }
  @objc func saveComposition() {
    guard let mediaURL = mediaURL else { return }
    saveVideo(with: mediaURL)
  }
  @objc func dismissKeyboard() -> Bool {
    textView.resignFirstResponder()
  }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func getMedia() {
    let mediaPicker = UIImagePickerController()
    mediaPicker.delegate = self
    mediaPicker.mediaTypes = ["public.movie"]
    present(mediaPicker, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let url = info[.mediaURL] as? URL else { return }
    self.dismiss(animated: true) {
      self.mediaURL = url
    }
  }
}

extension ViewController {
  
  func createTextLayerWith(_ text: String, and size: CGSize) -> CATextLayer {
    let playerVideoRatio = size.height/playerContainer.frame.height

    let textLayer = CATextLayer()
    textLayer.backgroundColor = UIColor.clear.cgColor
    textLayer.string = text
    textLayer.font = UIFont(name: "IMPACTED", size: 28)
    textLayer.fontSize = playerVideoRatio * 28
    textLayer.isWrapped = true
    textLayer.shadowOpacity = 0.5
    textLayer.foregroundColor = UIColor.white.cgColor
    textLayer.alignmentMode = CATextLayerAlignmentMode.center
    textLayer.frame = CGRect(x: 0, y: playerVideoRatio * 10, width: size.width, height: playerVideoRatio * textView.frame.height - 8*playerVideoRatio)
    return textLayer
  }
  
  func createComposition(with url: URL) -> AVMutableComposition {
    let composition = AVMutableComposition()
    let vidAsset = AVAsset(url: url)
    
    //Get video track
    let vTrack =  vidAsset.tracks(withMediaType: .video)
    guard let videoTrack = vTrack.first else { return composition }
    let timeRange: CMTimeRange = CMTimeRange(start: .zero, duration: vidAsset.duration)
    let trackID = CMPersistentTrackID(kCMPersistentTrackID_Invalid)
    preferredTransform = videoTrack.preferredTransform
    //Add video track
    let compVideoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: trackID)
    do { try compVideoTrack?.insertTimeRange(timeRange, of: videoTrack, at: .zero) }
    catch { print("error") }
    
    
    let aTrack =  vidAsset.tracks(withMediaType: .audio)
    guard let audioTrack = aTrack.first else { return composition }
    
    let compAudioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: trackID)
    do { try compAudioTrack?.insertTimeRange(timeRange, of: audioTrack, at: .zero) }
    catch { print("error") }
    
    return composition
  }
  
  func creatCompositionLayer(with composition: AVMutableComposition) -> AVMutableVideoComposition {
    let layerComposition = AVMutableVideoComposition()
    layerComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
    layerComposition.renderSize = composition.naturalSize
    print("Size in composition Layer", composition.naturalSize)

    //Instructions
    let instruction = AVMutableVideoCompositionInstruction()
    instruction.timeRange = CMTimeRangeMake(start: .zero, duration: composition.duration)
    let videotrack = composition.tracks(withMediaType: AVMediaType.video)[0] as AVAssetTrack
    let layerinstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videotrack)
    layerinstruction.setTransform(preferredTransform, at: .zero)
    instruction.layerInstructions = NSArray(object: layerinstruction) as [AnyObject] as! [AVVideoCompositionLayerInstruction]
    layerComposition.instructions = NSArray(object: instruction) as [AnyObject] as! [AVVideoCompositionInstructionProtocol]
    return layerComposition
  }
  
  func destinationURL(withFileName name: String) -> URL {
    let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let docsDir = dirPaths[0] as NSString
    let movieFilePath = docsDir.appendingPathComponent(name)
    return URL(fileURLWithPath: movieFilePath)
  }
  
  func composeWithText(_ text: String) {
    guard let mediaURL = mediaURL else { return }
    
    let composition = createComposition(with: mediaURL)
    let orientation = getOrientation(from: preferredTransform)
    let size = orientation.getProperSize(from: composition.naturalSize)
    let textLayer = createTextLayerWith(text, and: size)
    
    let videoLayer = CALayer()
    videoLayer.frame = CGRect(origin: .zero, size: size)
    
    let parentLayer = CALayer()
    parentLayer.frame = CGRect(origin: .zero, size: size)
    parentLayer.addSublayer(videoLayer)
    parentLayer.addSublayer(textLayer)
    
    let layerComposition = creatCompositionLayer(with: composition)
    layerComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
    layerComposition.renderSize = size
    let movieDestinationUrl = destinationURL(withFileName: "Composed.mov")
  
    exportAsset(composition, with: layerComposition, at: movieDestinationUrl)
  }
  
  func exportAsset(_ composition: AVMutableComposition, with layer: AVMutableVideoComposition, at url: URL) {
    let assetExport = AVAssetExportSession(asset: composition, presetName:AVAssetExportPresetHighestQuality)
    assetExport?.outputFileType = .mov
    assetExport?.videoComposition = layer
    
    try? FileManager.default.removeItem(at: url)
    
    assetExport?.outputURL = url as URL
    assetExport?.exportAsynchronously(completionHandler: {
      switch assetExport!.status {
      case .completed:
        DispatchQueue.main.async {
          self.mediaURL = url
        }
      default:
        print(assetExport?.error ?? "unknown error")
      }
    })
  }
  
  func saveVideo(with url: URL) {
    PHPhotoLibrary.shared().performChanges({
      PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL:url)
    }) { saved, error in
      if saved {
        print("Saved")
      }
    }
  }
}
import SwiftUI

struct ViewController_Previews: PreviewProvider {
  struct ViewControllerRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
      ViewController().view
    }
    
    func updateUIView(_ view: UIView, context: Context) {
      
    }
  }
    static var previews: some View {
      ViewControllerRepresentable()
    }
}

func getOrientation(from transform: CGAffineTransform) -> Orientation {
  if transform.a == 0 && transform.b == 1.0 && transform.c == -1.0 && transform.d == 0 {
    return .vertical
  } else if transform.a == 0 && transform.b == -1.0 && transform.c == 1.0 && transform.d == 0 {
    return .vertical
  } else if transform.a == 1.0 && transform.b == 0 && transform.c == 0 && transform.d == 1.0 {
    return .horizontal
  } else if transform.a == -1.0 && transform.b == 0 && transform.c == 0 && transform.d == -1.0 {
    return .horizontal
  }
  return .horizontal
}

enum Orientation {
  case vertical
  case horizontal
  
  func getProperSize(from size: CGSize) -> CGSize {
    switch self {
    case .vertical: return CGSize(width: size.height, height: size.width)
    case .horizontal: return size
    }
  }
}
