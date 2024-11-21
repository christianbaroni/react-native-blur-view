//
//  BaseBlurView.swift
//  react-native-blur-view
//
//  Created by Kirill Gudkov on 08.08.2024.
//

import CoreImage.CIFilterBuiltins

class Blur: UIView {
  private let gradient = CIFilter.linearGradient()
  private var blurFilter: NSObject?
  private var saturationFilter: NSObject?
  private var luminanceCurveMap: NSObject?
  private var colorBrightness: NSObject?
  
  private var effectView: UIVisualEffectView?
  private var backdropLayer: CALayer?
  
  private var gradientPercentage: CGFloat = 0.0
  private var blurIntensity: CGFloat = 10.0
  private var saturationIntensity: CGFloat = 1.0
  private var fadeStyle: FadeStyle = .top
  
  init(_ frame: CGRect, _ type: NSString) {
    super.init(frame: frame)
    
    gradient.color0 = CIColor.white
    gradient.color1 = CIColor.clear
    
    setEffectViewWith(blurType: type)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func tintColorDidChange() {
    super.tintColorDidChange()
    updateGradient()
    refreshView()
  }
  
  override func layoutSubviews() {
    updateGradient()
    refreshView()
  }
  
  override func didMoveToWindow() {
    backdropLayer?.setValue(window?.screen.scale, forKey: "scale")
  }
  
  func setBlurIntensity(_ intensity: CGFloat) {
    self.blurIntensity = clamp(intensity, min: 0.0, max: 100.0)
    refreshView()
  }
  
  func setSaturationIntensity(_ intensity: CGFloat) {
    // 0.0 - gray; values above 3.0 make no difference
    self.saturationIntensity = clamp(intensity, min: 0.0, max: 3.0)
    refreshView()
  }
  
  func setFadePercent(_ percentage: CGFloat) {
    self.gradientPercentage = percentage
    updateGradient()
    refreshView()
  }
  
  func setFadeStyle(_ fadeStyle: FadeStyle) {
    self.fadeStyle = fadeStyle
    updateGradient()
    refreshView()
  }
  
  func setEffectViewWith(blurType type: NSString) {
    effectView?.removeFromSuperview()
    
    if type == "plain" {
      effectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
      effectView!.subviews.dropFirst().forEach {
        $0.isHidden = true
      }
    } else {
      effectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.from(string: type)))
    }
    
    effectView!.frame = bounds
    effectView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    addSubview(effectView!)
    
    backdropLayer = effectView?.subviews.first?.layer
    
    blurFilter = createFilter(type: .variable)
    blurFilter?.setValue(true, forKey: normalizeKeyStr.base64Decoded())
    saturationFilter = createFilter(type: .saturate)
    luminanceCurveMap = createFilter(type: .luminance)
    colorBrightness = createFilter(type: .brightness)
    
    updateGradient()
    refreshView()
  }
  
  private func refreshView() {
    blurFilter?.setValue(blurIntensity, forKey: radiusKeyStr.base64Decoded())
    saturationFilter?.setValue(saturationIntensity, forKey: satKeyStr.base64Decoded())
    backdropLayer?.filters = []
    // To support *material styles, we need to insert luminanceCurveMap and colorBrightness filters
    // with properly configured properties which are unknown
    backdropLayer?.filters = [saturationFilter!, blurFilter!]
  }
  
  private func updateGradient() {
    switch self.fadeStyle {
      case .bottom:
        gradient.point0 = CGPoint(x: 0, y: frame.height)
        gradient.point1 = CGPoint(x: 0, y: frame.height * (1 - self.gradientPercentage))
      case .top:
        gradient.point0 = CGPoint(x: 0, y: frame.height * (1 - self.gradientPercentage))
        gradient.point1 = CGPoint(x: 0, y: frame.height)
      case .left:
        gradient.point0 = CGPoint(x: frame.width, y: 0)
        gradient.point1 = CGPoint(x: frame.width * (1 - self.gradientPercentage), y: 0)
      case .right:
        gradient.point0 = CGPoint(x: frame.width * (1 - self.gradientPercentage), y: 0)
        gradient.point1 = CGPoint(x: frame.width, y: 0)
    }
    
    let image = CIContext().createCGImage(gradient.outputImage!, from: frame)
    blurFilter?.setValue(image, forKey: gradientKeyStr.base64Decoded())
    
    effectView?.subviews.dropFirst().forEach {
      $0.fadeView(style: self.fadeStyle, percentage: self.gradientPercentage)
    }
  }
  
  private func createFilter(type: FilterType) -> NSObject? {
    guard let obj = NSClassFromString(filterStr.base64Decoded()) as? NSObject.Type else {
      return .none
    }
    
    guard let filter = obj.perform(
      NSSelectorFromString(propStr.base64Decoded()), with: type.rawValue.base64Decoded()
    )?.takeUnretainedValue() as? NSObject else {
      return .none
    }
    
    return filter
  }
}

let filterStr = "Q0FGaWx0ZXI="
let propStr = "ZmlsdGVyV2l0aFR5cGU6"
let gradientKeyStr = "aW5wdXRNYXNrSW1hZ2U="
let radiusKeyStr = "aW5wdXRSYWRpdXM="
let satKeyStr = "aW5wdXRBbW91bnQ="
let normalizeKeyStr = "aW5wdXROb3JtYWxpemVFZGdlcw=="
