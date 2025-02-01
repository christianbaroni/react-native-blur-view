// MARK: - BlurView.swift

import UIKit

class BlurView: UIView {
  
  private let VIEW_TAG = 9999
  
  @objc var feather: CGFloat = 8.0 {
    didSet {
      let clamped = clamp(feather, min: 0.0, max: 50.0)
      if abs(clamped - oldValue) > 0.0001,
         let variableView = viewWithTag(VIEW_TAG) as? VariableBlurView {
        variableView.setFeather(clamped)
      }
    }
  }
  
  @objc var gradientPoints: NSArray? {
    didSet {
      guard let variableView = viewWithTag(VIEW_TAG) as? VariableBlurView else {
        return
      }
      if !areArraysEqual(oldValue, gradientPoints) {
        variableView.setGradientPoints(gradientPoints)
      }
    }
  }
  
  @objc var blurStyle: NSString = "regular" {
    didSet {
      if blurStyle.lowercased != oldValue.lowercased {
        if let oldBlurView = viewWithTag(VIEW_TAG) {
          oldBlurView.removeFromSuperview()
        }
        addSubview(createBlurView(blurStyle))
      }
    }
  }
  
  @objc var blurIntensity: CGFloat = 10.0 {
    didSet {
      let clamped = clamp(blurIntensity, min: 0.0, max: 100.0)
      if abs(clamped - oldValue) > 0.0001,
         let baseView = viewWithTag(VIEW_TAG) as? BaseBlurView {
        baseView.setBlurIntensity(clamped)
      }
    }
  }
  
  @objc var saturationIntensity: CGFloat = 1.0 {
    didSet {
      let clamped = clamp(saturationIntensity, min: 0.0, max: 3.0)
      if abs(clamped - oldValue) > 0.0001,
         let baseView = viewWithTag(VIEW_TAG) as? BaseBlurView {
        baseView.setSaturationIntensity(clamped)
      }
    }
  }
  
  // MARK: - Init
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(createBlurView(blurStyle))
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Private
  
  private func createBlurView(_ style: NSString) -> UIView {
    let clampedBlur       = clamp(blurIntensity,      min: 0.0, max: 100.0)
    let clampedSaturation = clamp(saturationIntensity, min: 0.0, max: 3.0)
    let clampedFeather    = clamp(feather,            min: 0.0, max: 50.0)
    
    let lower = style.lowercased
    let isSystemMaterial = lower.contains("material")
    
    let blurSubview: UIView
    if style == "plain" {
      blurSubview = PlainBlurView(frame, clampedBlur, clampedSaturation)
    } else if style == "variable" {
      blurSubview = VariableBlurView(frame, clampedBlur, clampedSaturation, gradientPoints, clampedFeather)
    } else if isSystemMaterial {
      blurSubview = SystemBlurView(frame, UIBlurEffect.Style.from(string: style))
    } else {
      blurSubview = RegularBlurView(frame, clampedBlur, clampedSaturation, UIBlurEffect.Style.from(string: style))
    }
    
    blurSubview.tag = VIEW_TAG
    blurSubview.frame = bounds
    blurSubview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    return blurSubview
  }
}
