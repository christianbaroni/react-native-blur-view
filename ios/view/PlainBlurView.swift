//
//  PlainBlurView.swift
//  react-native-blur-view
//
//  Created by Kirill Gudkov on 08.08.2024.
//

// MARK: - PlainBlurView.swift

import UIKit

class PlainBlurView: BaseBlurView {
  
  init(
    _ frame: CGRect,
    _ blurIntensity: CGFloat,
    _ saturationIntensity: CGFloat
  ) {
    super.init(frame,
               blurIntensity,
               saturationIntensity,
               .gaussian,
               .regular)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func setupView() {
    effectView?.subviews.dropFirst().forEach {
      $0.isHidden = true
    }
    super.setupView()
  }
}
