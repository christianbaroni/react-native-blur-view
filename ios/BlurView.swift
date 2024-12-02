class BlurView : UIView {
  private let viewTag = 1
  
  @objc var fadePercent: CGFloat = 0 { didSet {
    if let view = viewWithTag(viewTag) as? Blur {
      view.setFadePercent(fadePercent)
    }
  }}
  
  @objc var fadeStyle: NSString = "top" { didSet {
    if let view = viewWithTag(viewTag) as? Blur {
      view.setFadeStyle(FadeStyle.from(style: fadeStyle))
    }
  }}
  
  @objc var blurStyle: NSString = "regular" { didSet {
    if let view = viewWithTag(viewTag) as? Blur {
      view.setEffectViewWith(blurType: blurStyle)
    }
  }}
  
  @objc var blurIntensity = 10.0 { didSet {
    if let view = viewWithTag(viewTag) as? Blur {
      view.setBlurIntensity(blurIntensity)
    }
  }}
  
  @objc var saturationIntensity: CGFloat = 1.0 { didSet {
    if let view = viewWithTag(viewTag) as? Blur {
      view.setSaturationIntensity(saturationIntensity)
    }
  }}
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    let blur = Blur(frame, blurStyle)
    blur.tag = viewTag
    blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    addSubview(blur)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // private func createBlurView(_ type: NSString) -> UIView {
  //   let clampedBlur = clamp(blurIntensity, min: MIN_BLUR_INTENSITY, max: MAX_BLUR_INTENSITY)
  //   let clampedSaturation = clamp(saturationIntensity, min: MIN_SATURATION_INTENSITY, max: MAX_SATURATION_INTENSITY)
    
  //   let style = UIBlurEffect.Style.from(string: type)
  //   let isSystemMaterial = type.lowercased.contains("material")
    
  //   let blur = if type == PLAIN_BLUR_STYLE {
  //     PlainBlurView(frame, clampedBlur, clampedSaturation)
  //   } else if type == VARIABLE_BLUR_STYLE {
  //     VariableBlurView(frame, clampedBlur, clampedSaturation, gradientPoints)
  //   } else if isSystemMaterial {
  //     SystemBlurView(frame, style)
  //   } else {
  //     RegularBlurView(frame, clampedBlur, clampedSaturation, style)
  //   }
    
  //   blur.tag = VIEW_TAG
  //   blur.frame = bounds
  //   blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
  //   return blur
  // }
}
