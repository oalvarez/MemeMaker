//
//  UIView+Autolayout.swift
//  MemeMaker
//
//  Created by Oscar Alvarez Hidalgo on 11/25/19.
//  Copyright © 2019 Oscar Alvarez Hidalgo. All rights reserved.
//

import UIKit

extension UIView {
  
  enum ConstraintId {
    static let aspectRatio = "aspectRatio"
    static let height = "height"
    static let width = "width"
  }
  
  @discardableResult
  open func with<T: UIView>(height: CGFloat? = nil, width:CGFloat? = nil) -> T {
    translatesAutoresizingMaskIntoConstraints = false
    if let height = height {
      removeConstraints(withIdentifier: ConstraintId.height)
      let constraint = heightAnchor.constraint(equalToConstant: height)
      constraint.identifier = ConstraintId.height
      constraint.isActive = true
    }
    if let width = width {
      removeConstraints(withIdentifier: ConstraintId.width)
      let constraint = widthAnchor.constraint(equalToConstant: width)
      constraint.identifier = ConstraintId.width
      constraint.isActive = true
    }
    return self as! T
  }
  
  @discardableResult
  open func update<T: UIView>(height: CGFloat? = nil, width:CGFloat? = nil) -> T {
    if let height = height {
      guard let constraint = constraints.first(where: { $0.identifier == ConstraintId.height })
        else { return self as! T }
      constraint.constant = height
    }
    if let width = width {
      guard let constraint = constraints.first(where: { $0.identifier == ConstraintId.width })
        else { return self as! T }
      constraint.constant = width
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
      anchorTop(to: superview.getTopAnchor(withSafeArea: safely), by: top)
    }
    if let leading = leading {
      anchorLeading(to: superview.getLeadingAnchor(withSafeArea: safely), by: leading)
    }
    if let bottom = bottom {
      anchorBottom(to: superview.getBottomAnchor(withSafeArea: safely), by: bottom)
    }
    if let trailing = trailing {
      anchorTrailing(to: superview.getTrailingAnchor(withSafeArea: safely), by: trailing)
    }
    return self as! T
  }
  
  @discardableResult
  func anchorTop<T: UIView>(to anchor: NSLayoutYAxisAnchor, by constant: CGFloat) -> T {
    translatesAutoresizingMaskIntoConstraints = false
    topAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
    return self as! T
  }
  
  @discardableResult
  func anchorBottom<T: UIView>(to anchor: NSLayoutYAxisAnchor, by constant: CGFloat) -> T {
    translatesAutoresizingMaskIntoConstraints = false
    bottomAnchor.constraint(equalTo: anchor, constant: -constant).isActive = true
    return self as! T
  }
  
  @discardableResult
  func anchorLeading<T: UIView>(to anchor: NSLayoutXAxisAnchor, by constant: CGFloat) -> T {
    translatesAutoresizingMaskIntoConstraints = false
    leadingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
    return self as! T
  }
  
  @discardableResult
  func anchorTrailing<T: UIView>(to anchor: NSLayoutXAxisAnchor, by constant: CGFloat) -> T {
    translatesAutoresizingMaskIntoConstraints = false
    trailingAnchor.constraint(equalTo: anchor, constant: -constant).isActive = true
    return self as! T
  }
  
  @discardableResult
  func centerInSuperview<T: UIView>(vertically: Bool = true, horizontally: Bool = true) -> T {
    guard let superview = superview else { return self as! T }
    translatesAutoresizingMaskIntoConstraints = false
    if horizontally {
    centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
    }
    if vertically {
    centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
    }
    return self as! T
  }
  
  func aspectRation<T: UIView>(_ ratio: CGFloat) -> T {
    removeConstraints(withIdentifier: ConstraintId.aspectRatio)
    let constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width, multiplier: ratio, constant: 0)
    constraint.identifier = ConstraintId.aspectRatio
    translatesAutoresizingMaskIntoConstraints = false
    constraint.isActive = true
    return self as! T
  }
  
  func removeConstraints(withIdentifier identifier: String) {
    self.constraints.filter({ $0.identifier == identifier}).forEach{ $0.isActive = false }
  }
}

extension UIView {
  func getTopAnchor(withSafeArea safeArea: Bool) -> NSLayoutYAxisAnchor {
    safeArea ? safeAreaLayoutGuide.topAnchor : topAnchor
  }
  
  func getBottomAnchor(withSafeArea safeArea: Bool) -> NSLayoutYAxisAnchor {
    safeArea ? safeAreaLayoutGuide.bottomAnchor : bottomAnchor
  }
  
  func getLeadingAnchor(withSafeArea safeArea: Bool) -> NSLayoutXAxisAnchor {
    safeArea ? safeAreaLayoutGuide.leadingAnchor : leadingAnchor
  }
  
  func getTrailingAnchor(withSafeArea safeArea: Bool) -> NSLayoutXAxisAnchor {
    safeArea ? safeAreaLayoutGuide.trailingAnchor : trailingAnchor
  }
}
