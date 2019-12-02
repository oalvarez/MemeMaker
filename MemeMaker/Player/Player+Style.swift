//
//  Player+Style.swift
//  MemeMaker
//
//  Created by Oscar Alvarez Hidalgo on 12/1/19.
//  Copyright © 2019 Oscar Alvarez Hidalgo. All rights reserved.
//

import UIKit

extension UIButton {
  func playButton() -> UIButton {
    setImage(UIImage(named: "play"), for: .normal)
    tintColor = .white
    contentMode = .scaleAspectFill
    with(height: 100, width: 100)
    return self
  }
}
