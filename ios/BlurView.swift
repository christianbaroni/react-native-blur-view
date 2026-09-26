// MARK: - BlurView.swift

import UIKit

class BlurView: UIView {
  
  private lazy var blurView: UIView = createBlurView()
  
  @objc var feather: CGFloat = 8.0 {
    didSet {
      let clamped = clamp(feather, min: 0.0, max: 50.0)
      if abs(clamped - oldValue) > 0.0001,
         let variableView = blurView as? VariableBlurView {
        variableView.setFeather(clamped)
      }
    }
  }
  
  @objc var gradientPoints: NSArray? {
    didSet {
      (blurView as? VariableBlurView)?.setGradientPoints(gradientPoints)
    }
  }
  
  @objc var blurStyle: NSString = "regular" {
    didSet {
      if blurStyle.lowercased != oldValue.lowercased {
        blurView.removeFromSuperview()
        blurView = createBlurView()
        addSubview(blurView)
      }
    }
  }
  
  @objc var blurIntensity: CGFloat = 10.0 {
    didSet {
      let clamped = clamp(blurIntensity, min: 0.0, max: 100.0)
      if abs(clamped - oldValue) > 0.0001,
         let baseView = blurView as? BaseBlurView {
        baseView.setBlurIntensity(clamped)
      }
    }
  }
  
  @objc var saturationIntensity: CGFloat = 1.0 {
    didSet {
      let clamped = clamp(saturationIntensity, min: 0.0, max: 3.0)
      if abs(clamped - oldValue) > 0.0001,
         let baseView = blurView as? BaseBlurView {
        baseView.setSaturationIntensity(clamped)
      }
    }
  }
  
  // MARK: - Init
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(blurView)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Private
  
  private func createBlurView() -> UIView {
    let clampedBlur       = clamp(blurIntensity,      min: 0.0, max: 100.0)
    let clampedSaturation = clamp(saturationIntensity, min: 0.0, max: 3.0)
    let clampedFeather    = clamp(feather,            min: 0.0, max: 50.0)
    
    let lower = blurStyle.lowercased
    let isSystemMaterial = lower.contains("material")
    
    let blurSubview: UIView
    if blurStyle == "plain" {
      blurSubview = PlainBlurView(bounds, clampedBlur, clampedSaturation)
    } else if blurStyle == "variable" {
      blurSubview = VariableBlurView(bounds, clampedBlur, clampedSaturation, gradientPoints, clampedFeather)
    } else if isSystemMaterial {
      blurSubview = SystemBlurView(bounds, UIBlurEffect.Style.from(string: blurStyle))
    } else {
      blurSubview = RegularBlurView(bounds, clampedBlur, clampedSaturation, UIBlurEffect.Style.from(string: blurStyle))
    }
    
    blurSubview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    return blurSubview
  }
}
