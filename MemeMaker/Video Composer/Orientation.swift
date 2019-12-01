//
//  Orientation.swift
//  MemeMaker
//
//  Created by Oscar Alvarez Hidalgo on 11/27/19.
//  Copyright © 2019 Oscar Alvarez Hidalgo. All rights reserved.
//

import CoreGraphics

enum Orientation {
  case vertical
  case horizontal
  
  func getProperSize(from size: CGSize) -> CGSize {
    switch self {
    case .vertical: return CGSize(width: size.height, height: size.width)
    case .horizontal: return size
    }
  }
  
  static func getOrientation(from transform: CGAffineTransform) -> Orientation {
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
}
