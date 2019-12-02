//
//  UIView+Stack.swift
//  MemeMaker
//
//  Created by Oscar Alvarez Hidalgo on 11/30/19.
//  Copyright © 2019 Oscar Alvarez Hidalgo. All rights reserved.
//

import UIKit

extension UIStackView {
  @discardableResult
  static func with(_ views: UIView...,
               axis: NSLayoutConstraint.Axis = .vertical,
               spacing: CGFloat = 16,
               alignment: UIStackView.Alignment = .center,
               distribution: UIStackView.Distribution = .fill) -> UIStackView {
    let stackView = UIStackView(arrangedSubviews: views)
    stackView.axis = axis
    stackView.spacing = spacing
    stackView.alignment = alignment
    stackView.distribution = distribution
    return stackView
  }
}
