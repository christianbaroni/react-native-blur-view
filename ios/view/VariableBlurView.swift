//
//  VariableBlurView.swift
//  react-native-blur-view
//
//  Created by Kirill Gudkov on 09.08.2024.
//

import CoreImage.CIFilterBuiltins

class VariableBlurView: BaseBlurView {
  
  private let gradient = CIFilter.linearGradient()
  private var gradientPoints: GradientPoints?
  
  init(
    _ frame: CGRect,
    _ blurIntensity: CGFloat,
    _ saturationIntensity: CGFloat,
    _ initialGradientPoints: NSArray?
  ) {
    super.init(frame, blurIntensity, saturationIntensity, .variable,  .regular)
    self.gradientPoints = GradientPoints(from: initialGradientPoints)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func setupView() {
    gradient.color0 = CIColor.black
    gradient.color1 = CIColor.clear
    
    effectView?.subviews.dropFirst().forEach {
      $0.isHidden = true
    }
  }
  
  override func layoutSubviews() {
    updateGradient()
    refreshView()
  }
  
  func setGradientPoints(_ array: NSArray?) {
    self.gradientPoints = GradientPoints(from: array)
    updateGradient()
    refreshView()
  }
  
  private func updateGradient() {
    if frame.width == 0 || frame.height == 0 {
      return
    }
    
    guard var points = gradientPoints else {
      return
    }
    
    if points.point0.x == 0 && points.point0.y == 0 && points.point1.x == 0 && points.point1.y == 0 {
      points.point1.y = frame.height
    }
    
    gradient.point0 = points.point0
    gradient.point1 = points.point1
    
    blurFilter?.setValue(CIContext().createCGImage(gradient.outputImage!, from: frame), forKey: "inputMaskImage")
  }
}
