//
//  BaseBlurView.swift
//  react-native-blur-view
//
//  Created by Kirill Gudkov on 08.08.2024.
//

class BaseBlurView: UIView {
  
  var blurFilter: NSObject?
  var saturationFilter: NSObject?
  var effectView: UIVisualEffectView?
  
  private var blurIntensity: CGFloat
  private var saturationIntensity: CGFloat
  private var backdropLayer: CALayer?
  
  init(
    _ frame: CGRect,
    _ blurIntensity: CGFloat,
    _ saturationIntensity: CGFloat,
    _ filterType: CAFilterType,
    _ style: UIBlurEffect.Style
  ) {
    self.blurIntensity = blurIntensity
    self.saturationIntensity = saturationIntensity

    super.init(frame: frame)
    
    effectView = UIVisualEffectView(effect: UIBlurEffect(style: style))
    effectView!.frame = bounds
    effectView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    addSubview(effectView!)

    backdropLayer = effectView!.subviews.first?.layer
    blurFilter = getBlurFilter(type: filterType)
    saturationFilter = getSaturationFilter()
    
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func tintColorDidChange() {
    super.tintColorDidChange()
    refreshView()
  }
  
  open override func didMoveToWindow() {
    backdropLayer?.setValue(window?.screen.scale, forKey: "scale")
  }
  
  func setBlurIntensity(_ intensity: CGFloat) {
    self.blurIntensity = intensity
    refreshView()
  }
  
  func setSaturationIntensity(_ intensity: CGFloat) {
    self.saturationIntensity = intensity
    refreshView()
  }
  
  func setupView() {
    refreshView()
  }
  
  func refreshView() {
    blurFilter?.setValue(blurIntensity, forKey: "inputRadius")
    saturationFilter?.setValue(saturationIntensity, forKey: "inputAmount")

    backdropLayer?.filters = []
    backdropLayer?.filters = [blurFilter!, saturationFilter!]
  }
  
  private func getBlurFilter(type: CAFilterType) -> NSObject? {
    guard let CAFilter = NSClassFromString("CAFilter") as? NSObject.Type else {
      return .none
    }
    
    guard let filter = CAFilter.perform(
      NSSelectorFromString("filterWithType:"), with: type.rawValue
    )?.takeUnretainedValue() as? NSObject else {
      return .none
    }
    
    filter.setValue(true, forKey: "inputNormalizeEdges")
    
    return filter
  }

  private func getSaturationFilter() -> NSObject? {
    guard let CAFilter = NSClassFromString("CAFilter") as? NSObject.Type else {
      return .none
    }
    
    guard let filter = CAFilter.perform(
      NSSelectorFromString("filterWithType:"), with: CAFilterType.saturate.rawValue
    )?.takeUnretainedValue() as? NSObject else {
      return .none
    }
    
    return filter
  }
}
