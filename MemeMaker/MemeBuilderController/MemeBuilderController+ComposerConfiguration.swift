//
//  MemeBuilderController+ComposerConfiguration.swift
//  MemeMaker
//
//  Created by Oscar Alvarez Hidalgo on 12/1/19.
//  Copyright © 2019 Oscar Alvarez Hidalgo. All rights reserved.
//

import Foundation

extension MemeBuilderController {
  func createConfiguration(with url: URL) -> Composer.Configuration {
    Composer.Configuration(mediaURL: url,
                           text: textView.text,
                           fontSize: fontSize,
                           fontName: fontName,
                           playerSize: playerContainer.frame.size,
                           textViewSize: textView.frame.size)
  }
}
