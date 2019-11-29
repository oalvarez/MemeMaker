//
//  ViewController+Composition.swift
//  MemeMaker
//
//  Created by Oscar Alvarez Hidalgo on 11/27/19.
//  Copyright © 2019 Oscar Alvarez Hidalgo. All rights reserved.
//

import AVFoundation
import UIKit
import Photos

extension ViewController {
  
  func composeWithText(_ text: String) {
    guard let mediaURL = mediaURL else { return }
    
    let composition = createComposition(with: mediaURL)
    let size = Orientation
                 .getOrientation(from: preferredTransform)
                 .getProperSize(from: composition.naturalSize)
    let textLayer = createTextLayerWith(text, and: size)
    
    let layerComposition = prepareLayers(with: textLayer, composition: composition, andSize: size)
    let movieDestinationUrl = destinationURL(withFileName: "Composed.mov")
  
    exportAsset(composition, with: layerComposition, at: movieDestinationUrl)
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
  
  func prepareLayers(with layer: CALayer, composition: AVComposition, andSize size: CGSize) -> AVVideoComposition {
    let videoLayer = CALayer()
    videoLayer.frame = CGRect(origin: .zero, size: size)
    
    let parentLayer = CALayer()
    parentLayer.frame = CGRect(origin: .zero, size: size)
    parentLayer.addSublayer(videoLayer)
    parentLayer.addSublayer(layer)
    
    let layerComposition = addInstructions(to: composition)
    layerComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
    layerComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
    layerComposition.renderSize = size
    
    return layerComposition
  }
  
  func addInstructions(to composition: AVComposition) -> AVMutableVideoComposition {
    let layerComposition = AVMutableVideoComposition()
    //Instructions
    let instruction = AVMutableVideoCompositionInstruction()
    instruction.timeRange = CMTimeRangeMake(start: .zero, duration: composition.duration)
    let videoTrack = composition.tracks(withMediaType: AVMediaType.video)[0] as AVAssetTrack
    let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
    layerInstruction.setTransform(preferredTransform, at: .zero)
    instruction.layerInstructions = NSArray(object: layerInstruction) as [AnyObject] as! [AVVideoCompositionLayerInstruction]
    layerComposition.instructions = NSArray(object: instruction) as [AnyObject] as! [AVVideoCompositionInstructionProtocol]
    return layerComposition
  }
  
  func destinationURL(withFileName name: String) -> URL {
    let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let docsDir = dirPaths[0] as NSString
    let movieFilePath = docsDir.appendingPathComponent(name)
    return URL(fileURLWithPath: movieFilePath)
  }
  
  func exportAsset(_ composition: AVComposition, with layer: AVVideoComposition, at url: URL) {
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
