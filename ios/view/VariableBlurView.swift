//
//  VariableBlurView.swift
//  react-native-blur-view
//
//  Created by Kirill Gudkov on 08.08.2024.
//

import UIKit
import CoreImage.CIFilterBuiltins

class VariableBlurView: BaseBlurView {
  // MARK: - Properties
  
  private var requestedBlurIntensity: CGFloat = 0
  private var requestedFeather: CGFloat = 0
  private var appliedFeather: CGFloat = 0
  private var gradientPoints: NSArray?
  private var lastKnownBounds: CGRect = .zero
  
  private let gradient = CIFilter.linearGradient()
  private lazy var clampFilter = CIFilter.affineClamp()
  private lazy var featherFilter = CIFilter.gaussianBlur()
  
  // MARK: - Initialization
  
  init(
    _ frame: CGRect,
    _ blurIntensity: CGFloat,
    _ saturationIntensity: CGFloat,
    _ initialGradientPoints: NSArray?,
    _ initialFeather: CGFloat
  ) {
    self.requestedBlurIntensity = blurIntensity
    self.requestedFeather = initialFeather
    self.gradientPoints = initialGradientPoints
    
    super.init(
      frame,
      blurIntensity,
      saturationIntensity,
      .variable,
      .regular
    )
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View Lifecycle
  
  override func setupView() {
    gradient.color0 = .black
    gradient.color1 = .clear
    
    effectView?.subviews.dropFirst().forEach { $0.isHidden = true }
    super.setupView()
    
    if bounds.width > 0, bounds.height > 0 {
      applyDimensionClamps()
      buildGradientMask()
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    guard bounds.width > 0, bounds.height > 0 else { return }
    
    if bounds != lastKnownBounds {
      lastKnownBounds = bounds
      applyDimensionClamps()
      buildGradientMask()
    }
  }
  
  // MARK: - Public Methods
  
  override func setBlurIntensity(_ intensity: CGFloat) {
    requestedBlurIntensity = intensity
    applyDimensionClamps()
    buildGradientMask()
  }
  
  func setFeather(_ value: CGFloat) {
    if abs(value - requestedFeather) > 0.0001 {
      requestedFeather = value
      applyDimensionClamps()
      buildGradientMask()
    }
  }
  
  func setGradientPoints(_ array: NSArray?) {
    if !areArraysEqual(gradientPoints, array) {
      gradientPoints = array
      applyDimensionClamps()
      buildGradientMask()
    }
  }
  
  // MARK: - Private Methods
  
  private func buildGradientMask() {
    guard bounds.width > 0, bounds.height > 0 else { return }
    
    let (maskRect, croppedImage) = computeGradientMask()
    
    let context = CIContextManager.shared
    guard let cgMask = context.createCGImage(croppedImage, from: maskRect) else {
      return
    }
    
    blurFilter?.setValue(cgMask, forKey: gradientKeyStr.base64Decoded())
    refreshView()
  }
  
  private func computeGradientMask() -> (CGRect, CIImage) {
    let (p0, p1) = parsePoints(gradientPoints)
    
    let dx = p1.x - p0.x
    let dy = p1.y - p0.y
    let epsilon: CGFloat = 1e-7
    let length = hypot(dx, dy)
    let dirX = length == 0 ? 0 : (dx / length)
    let dirY = length == 0 ? 0 : (dy / length)
    
    gradient.point0 = p0
    gradient.point1 = p1
    
    if abs(p0.x - p1.x) < epsilon, abs(p0.y - p1.y) < epsilon {
      gradient.color0 = .clear
      gradient.color1 = .clear
    } else {
      gradient.color0 = .black
      gradient.color1 = .clear
    }
    
    guard let gradientImage = gradient.outputImage else {
      return (.zero, CIImage())
    }
    
    var extendedRect = bounds.integral
    let preciseExtension = round(appliedFeather * 1.25)
    let widthExtension = round(abs(dirX * preciseExtension))
    let heightExtension = round(abs(dirY * preciseExtension))
    
    if dirX >= 0 {
      extendedRect.size.width += widthExtension
    } else {
      extendedRect.origin.x -= widthExtension
    }
    
    if dirY >= 0 {
      extendedRect.size.height += heightExtension
    } else {
      extendedRect.origin.y -= heightExtension
    }
    
    clampFilter.inputImage = gradientImage
    clampFilter.transform = .identity
    
    guard let clampedImage = clampFilter.outputImage else {
      return (.zero, CIImage())
    }
    
    featherFilter.inputImage = clampedImage
    featherFilter.radius = Float(appliedFeather)
    
    guard let blurredImage = featherFilter.outputImage else {
      return (.zero, CIImage())
    }
    
    let finalImage = blurredImage.cropped(to: extendedRect.integral)
    return (extendedRect, finalImage)
  }
  
  private func parsePoints(_ array: NSArray?) -> (CGPoint, CGPoint) {
    var p0 = CGPoint(x: bounds.width / 2, y: 0)
    var p1 = CGPoint(x: bounds.width / 2, y: bounds.height)
    
    if let arr = array as? [[String: CGFloat]], arr.count >= 2 {
      if let x0 = arr[1]["x"], let y0 = arr[1]["y"],
         let x1 = arr[0]["x"], let y1 = arr[0]["y"] {
        p0 = CGPoint(
          x: (1 - x0) * bounds.width,
          y: (1 - y0) * bounds.height
        )
        p1 = CGPoint(
          x: (1 - x1) * bounds.width,
          y: (1 - y1) * bounds.height
        )
      }
    }
    return (p0, p1)
  }
  
  private func relevantDimension() -> CGFloat {
    let (p0, p1) = parsePoints(gradientPoints)
    let dx = abs(p1.x - p0.x)
    let dy = abs(p1.y - p0.y)
    return (dx >= dy) ? bounds.width : bounds.height
  }
  
  private func applyDimensionClamps() {
    let halfDim = relevantDimension() / 3
    
    var newBlur = requestedBlurIntensity
    var newFeather = requestedFeather
    
    if newBlur > halfDim {
      newBlur = halfDim
    }
    
    let sum = newBlur + newFeather
    if sum > halfDim {
      let excess = sum - halfDim
      if newFeather >= excess {
        newFeather -= excess
      } else {
        let leftover = excess - newFeather
        newFeather = 0
        newBlur -= leftover
        if newBlur < 0 { newBlur = 0 }
      }
    }
    
    if abs(newBlur - super.currentBlurIntensity) > 0.0001 {
      super.setBlurIntensity(newBlur)
    }
    appliedFeather = newFeather
  }
  
  private func areArraysEqual(_ array1: NSArray?, _ array2: NSArray?) -> Bool {
    guard let arr1 = array1, let arr2 = array2 else {
      return array1 == nil && array2 == nil
    }
    return arr1.isEqual(arr2)
  }
}

let gradientKeyStr = "aW5wdXRNYXNrSW1hZ2U="
