//
//  Composer.swift
//  MemeMaker
//
//  Created by Oscar Alvarez Hidalgo on 11/27/19.
//  Copyright © 2019 Oscar Alvarez Hidalgo. All rights reserved.
//

import AVFoundation
import UIKit
import Photos

class Composer {
  
  struct Configuration {
    let mediaURL: URL
    let text: String
    let fontSize: CGFloat
    let fontName: String
    let playerSize: CGSize
    let textViewSize: CGSize
  }
  
  enum CompositorError: Error {
    case exporting
    case unknown
  }
  
  ///Compose a video with the layer that is passed
  public func composeVideo(at                 url: URL,
                           withLayer        layer: CALayer,
                           trackProgress progress: @escaping (Float) -> Void,
                           then        completion: @escaping (Result<URL, Error>) -> Void) {
    let composition = createComposition(with: url)
    let layerComposition = prepareLayersForVideo(at: url, withLayer: layer, andComposition: composition)
    let movieDestinationUrl = destinationURL(withFileName: "Composed.mov")
    exportAsset(with:          composition,
                at:            movieDestinationUrl,
                with:          layerComposition,
                trackProgress: progress,
                then:          completion)
  }
  
  ///Create a composition to work with from the video located at the url passed
  private func createComposition(with url: URL) -> AVMutableComposition {
    let composition = AVMutableComposition()
    let vidAsset = AVAsset(url: url)
    
    //Get video track
    let vTrack =  vidAsset.tracks(withMediaType: .video)
    guard let videoTrack = vTrack.first else { return composition }
    let timeRange: CMTimeRange = CMTimeRange(start: .zero, duration: vidAsset.duration)
    let trackID = CMPersistentTrackID(kCMPersistentTrackID_Invalid)
    //Add video track
    let compVideoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: trackID)
    do { try compVideoTrack?.insertTimeRange(timeRange, of: videoTrack, at: .zero) }
    catch { print("error") }
    
    let aTrack =  vidAsset.tracks(withMediaType: .audio)
    guard let audioTrack = aTrack.first else { return composition }
    
    let compAudioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: trackID)
    do { try compAudioTrack?.insertTimeRange(timeRange, of: audioTrack, at: .zero) }
    catch { print("error") }
    //Return errors
    return composition
  }
  
  ///Use the composition and add the layer to the video located at the url
  private func prepareLayersForVideo(at                     url: URL,
                                     withLayer            layer: CALayer,
                                     andComposition composition: AVComposition) -> AVVideoComposition {
    let videoLayer = CALayer()
    let size = getFinalSizeForVideo(at: url)
    videoLayer.frame = CGRect(origin: .zero, size: size)
    
    let parentLayer = CALayer()
    parentLayer.frame = CGRect(origin: .zero, size: size)
    parentLayer.addSublayer(videoLayer)
    parentLayer.addSublayer(layer)
    
    let transform = getPrefferedTransformForVideo(at: url)
    
    let layerComposition = addInstructions(to: composition,
                                           withTransform: transform)
    layerComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
    layerComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
    layerComposition.renderSize = size
    
    return layerComposition
  }
  
  ///Returns the url where the video will be located after composing and exporting
  private func destinationURL(withFileName name: String) -> URL {
    let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let docsDir = dirPaths[0] as NSString
    let movieFilePath = docsDir.appendingPathComponent(name)
    return URL(fileURLWithPath: movieFilePath)
  }
  
  var exportSession: AVAssetExportSession?
  
  ///Creates a session that extorts the final video to a final url
  func exportAsset(with     composition: AVComposition,
                   at               url: URL,
                   with           layer: AVVideoComposition,
                   trackProgress handle: @escaping (Float) -> Void,
                   then      completion: @escaping (Result<URL, Error>) -> Void) {
    exportSession = AVAssetExportSession(asset: composition, presetName:AVAssetExportPresetHighestQuality)
    exportSession?.outputFileType = .mov
    exportSession?.videoComposition = layer
    exportSession?.outputURL = url
    try? FileManager.default.removeItem(at: url)
    
    let progressTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { timer in
      let progress = Float((self.exportSession?.progress)!)
      handle(progress)
    })
    
    exportSession?.exportAsynchronously(completionHandler: {
      progressTimer.invalidate()
      switch self.exportSession!.status {
      case .completed: completion(.success(url))
      default:         completion(.failure(CompositorError.exporting))
      }
    })
  }
  
  func cancelExport() {
    guard exportSession != nil else { return }
    exportSession?.cancelExport()
    exportSession = nil
  }
  
  ///Return the size of the video ar url. It varys from vertical and horizontal
  private func getFinalSizeForVideo(at url: URL) -> CGSize {
    let videoAssetSource = AVAsset(url: url)
    guard let videoTrack = videoAssetSource.tracks(withMediaType: AVMediaType.video).first else { return .zero }
    return Orientation
            .getOrientation(from: videoTrack.preferredTransform)
            .getProperSize(from: videoTrack.naturalSize)
  }
  
  ///Get the preffered transformation fo a video at a URL. It will change with orientation
  private func getPrefferedTransformForVideo(at url: URL) -> CGAffineTransform {
    let videoAssetSource = AVAsset(url: url)
    guard let videoTrack = videoAssetSource.tracks(withMediaType: AVMediaType.video).first else { return .identity }
    return videoTrack.preferredTransform
  }
  
  ///Creates a Text Layer to add to the composition
  func createTextLayerForVideo(with configuration: Configuration) -> CALayer {
    let size = getFinalSizeForVideo(at: configuration.mediaURL)
    let playerVideoRatio = size.height/configuration.playerSize.height

    let textLayer = CATextLayer()
    textLayer.backgroundColor = UIColor.clear.cgColor
    textLayer.string = configuration.text
    textLayer.font = UIFont(name: configuration.fontName, size: configuration.fontSize)
    textLayer.fontSize = playerVideoRatio * configuration.fontSize
    textLayer.isWrapped = true
    textLayer.shadowOpacity = 0.5
    textLayer.foregroundColor = UIColor.white.cgColor
    textLayer.alignmentMode = CATextLayerAlignmentMode.center
    textLayer.frame = CGRect(x: playerVideoRatio * 3,
                             y: playerVideoRatio * 10,
                             width: size.width - playerVideoRatio * 6,
                             height: playerVideoRatio * configuration.textViewSize.height - 8 * playerVideoRatio)
    return textLayer
  }
  
  ///Add the instructions to the composition
  func addInstructions(to          composition: AVComposition,
                       withTransform transform: CGAffineTransform) -> AVMutableVideoComposition {
    let layerComposition = AVMutableVideoComposition()
    //Instructions
    let instruction = AVMutableVideoCompositionInstruction()
    instruction.timeRange = CMTimeRangeMake(start: .zero, duration: composition.duration)
    let videoTrack = composition.tracks(withMediaType: AVMediaType.video)[0] as AVAssetTrack
    let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
    layerInstruction.setTransform(transform, at: .zero)
    instruction.layerInstructions = NSArray(object: layerInstruction) as [AnyObject] as! [AVVideoCompositionLayerInstruction]
    layerComposition.instructions = NSArray(object: instruction) as [AnyObject] as! [AVVideoCompositionInstructionProtocol]
    return layerComposition
  }
  
  ///Save video to the roll
  public func saveVideo(with        url: URL,
                        then completion: @escaping (Result<Void, Error>) -> Void) {
    PHPhotoLibrary.shared().performChanges({
      PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL:url)
    }) { saved, error in
      if error != nil { completion(.failure(error!)) }
      if saved        { completion(.success(())) }
      else            { completion(.failure(CompositorError.unknown)) }
    }
  }
  
  public func getVideoWidth(ofVideoFrom url: URL, andPlayerFrame frame: CGRect) -> CGFloat {
    let videoAssetSource = AVAsset(url: url)
    guard let videoTrack = videoAssetSource.tracks(withMediaType: AVMediaType.video).first else { return 0 }
    let orientation = Orientation.getOrientation(from: videoTrack.preferredTransform)
    let size = videoTrack.naturalSize
    let ratio = size.height/size.width
    if orientation == .vertical { return frame.height * ratio }
    else                        { return frame.width }
  }
}
