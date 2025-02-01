// MARK: - RegularBlurView.swift

import UIKit

class RegularBlurView: BaseBlurView {
  
  init(
    _ frame: CGRect,
    _ blurIntensity: CGFloat,
    _ saturationIntensity: CGFloat,
    _ style: UIBlurEffect.Style
  ) {
    super.init(frame,
               blurIntensity,
               saturationIntensity,
               .gaussian,
               style)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
