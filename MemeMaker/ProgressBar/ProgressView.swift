//
//  ProgressBar.swift
//  MemeMaker
//
//  Created by Oscar Alvarez Hidalgo on 11/29/19.
//  Copyright © 2019 Oscar Alvarez Hidalgo. All rights reserved.
//

import UIKit

class ProgressBar: UIView {

  let completed = UIView()
  let titleLabel = UILabel()
  let progressLabel = UILabel()
  
  init(with title: String) {
    super.init(frame: .zero)
    addSubview(completed)
    completed.completeSectionStyle()
    addSubview(titleLabel)
    titleLabel.progressTitleStyle(with: title)
    addSubview(progressLabel)
    progressLabel.progressValueStyle()
    progressBarStyle()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func update(with progress: Float) {
    completed.update(width: frame.width * CGFloat(progress))
    UIView.animate(withDuration: 0.3) {
      self.layoutIfNeeded()
    }
    let percentage = Int(progress*100)
    progressLabel.text = "\(percentage)%"
  }
}
