//
//  UIView+Stack.swift
//  MemeMaker
//
//  Created by Oscar Alvarez Hidalgo on 11/30/19.
//  Copyright © 2019 Oscar Alvarez Hidalgo. All rights reserved.
//

import UIKit

extension UIView {
  @discardableResult
  func addVStack(_ views: UIView...,
                   spacing: CGFloat = 16,
                   alignment: UIStackView.Alignment = .center,
                   distribution: UIStackView.Distribution = .fill) -> UIStackView {
    let stackView = UIStackView(arrangedSubviews: views)
    stackView.axis = .vertical
    stackView.spacing = spacing
    stackView.alignment = alignment
    stackView.distribution = distribution
    addSubview(stackView)
    stackView.fillSuperView()
    return stackView
  }
}
