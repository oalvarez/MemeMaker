//
//  UIView.swift
//  MemeMaker
//
//  Created by Oscar Alvarez Hidalgo on 11/25/19.
//  Copyright © 2019 Oscar Alvarez Hidalgo. All rights reserved.
//

import UIKit



extension UIView {
  
  @discardableResult
  open func with<T: UIView>(height: CGFloat? = nil, width:CGFloat? = nil) -> T {
    translatesAutoresizingMaskIntoConstraints = false
    if let height = height {
      heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    if let width = width {
      widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    return self as! T
  }
  
  @discardableResult
  func fillSuperView<T: UIView>(safely: Bool = false) -> T {
    anchorToSuperview(safely: safely, top: 0, leading: 0, bottom: 0, trailing: 0)
  }
  
  
  @discardableResult
  func anchorToSuperview<T: UIView>(safely: Bool = false,
                      top: CGFloat? = nil,
                      leading: CGFloat? = nil,
                      bottom: CGFloat? = nil,
                      trailing: CGFloat? = nil) -> T {
    guard let superview = superview else { return self as! T }
    translatesAutoresizingMaskIntoConstraints = false
    if let top = top {
      if #available(iOS 11.0, *) {
        topAnchor.constraint(equalTo: safely ? superview.safeAreaLayoutGuide.topAnchor : superview.topAnchor, constant: top).isActive = true
      } else {
        topAnchor.constraint(equalTo: safely ? superview.topAnchor : superview.topAnchor, constant: top).isActive = true
      }
    }
    if let leading = leading {
      if #available(iOS 11.0, *) {
        leadingAnchor.constraint(equalTo: safely ? superview.safeAreaLayoutGuide.leadingAnchor : superview.leadingAnchor, constant: leading).isActive = true
      } else {
        leadingAnchor.constraint(equalTo: safely ? superview.leadingAnchor : superview.leadingAnchor, constant: leading).isActive = true
      }
    }
    if let bottom = bottom {
      if #available(iOS 11.0, *) {
        bottomAnchor.constraint(equalTo: safely ? superview.safeAreaLayoutGuide.bottomAnchor : superview.bottomAnchor, constant: -bottom).isActive = true
      } else {
        bottomAnchor.constraint(equalTo: safely ? superview.bottomAnchor : superview.bottomAnchor, constant: -bottom).isActive = true
      }
    }
    if let trailing = trailing {
      if #available(iOS 11.0, *) {
        trailingAnchor.constraint(equalTo: safely ? superview.safeAreaLayoutGuide.trailingAnchor : superview.trailingAnchor, constant: -trailing).isActive = true
      } else {
        trailingAnchor.constraint(equalTo: safely ? superview.trailingAnchor : superview.trailingAnchor, constant: -trailing).isActive = true
      }
    }
    return self as! T
  }
  
  @discardableResult
  func centerInSuperview<T: UIView>() -> T {
    guard let superview = superview else { return self as! T }
    translatesAutoresizingMaskIntoConstraints = false
    centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
    centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
    return self as! T
  }
  
  func aspectRation<T: UIView>(_ ratio: CGFloat) -> T {
    let constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width, multiplier: ratio, constant: 0)
    translatesAutoresizingMaskIntoConstraints = false
    constraint.isActive = true
    return self as! T
  }
}

