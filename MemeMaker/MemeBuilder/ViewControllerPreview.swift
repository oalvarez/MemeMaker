//
//  ViewControllerPreview.swift
//  MemeMaker
//
//  Created by Oscar Alvarez Hidalgo on 11/28/19.
//  Copyright © 2019 Oscar Alvarez Hidalgo. All rights reserved.
//

import SwiftUI

struct ViewController_Previews: PreviewProvider {
  struct ViewControllerRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
      ViewController().view
    }
    
    func updateUIView(_ view: UIView, context: Context) {
      
    }
  }
    static var previews: some View {
      ViewControllerRepresentable()
    }
}
