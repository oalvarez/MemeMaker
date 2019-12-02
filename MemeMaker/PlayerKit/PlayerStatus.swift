//
//  PlayerStatus.swift
//  MemeMaker
//
//  Created by Oscar Alvarez Hidalgo on 12/1/19.
//  Copyright © 2019 Oscar Alvarez Hidalgo. All rights reserved.
//

import Foundation

enum PlayerStatus {
  case playing
  case paused
  
  mutating func toggle() {
    switch self {
    case .playing: self = .paused
    case .paused: self = .playing
    }
  }
}
