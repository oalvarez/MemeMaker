//
//  ViewController+ImagePicker.swift
//  MemeMaker
//
//  Created by Oscar Alvarez Hidalgo on 11/27/19.
//  Copyright © 2019 Oscar Alvarez Hidalgo. All rights reserved.
//

import UIKit
import MobileCoreServices
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func getMedia() {
    let mediaPicker = UIImagePickerController()
    mediaPicker.delegate = self
    mediaPicker.mediaTypes = [kUTTypeMovie as String]
    present(mediaPicker, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let url = info[.mediaURL] as? URL else { return }
    self.dismiss(animated: true) {
      self.mediaURL = url
    }
  }
}
