class BlurView : UIView {
  
  @objc var gradientPoints: NSArray? { didSet {
    if let view = viewWithTag(VIEW_TAG) as? VariableBlurView, let points = gradientPoints {
      view.setGradientPoints(points)
    }
  }}
  
  @objc var blurStyle: NSString = DEFAULT_BLUR_STYLE { didSet {
    if let view = viewWithTag(VIEW_TAG) {
      view.removeFromSuperview()
    }
    addSubview(createBlurView(blurStyle))
  }}
  
  @objc var blurIntensity = DEFAULT_BLUR_INTENSITY { didSet {
    if let view = viewWithTag(VIEW_TAG) as? BaseBlurView {
      view.setBlurIntensity(
        clamp(blurIntensity, min: MIN_BLUR_INTENSITY, max: MAX_BLUR_INTENSITY)
      )
    }
  }}
  
  @objc var saturationIntensity: CGFloat = DEFAULT_SATURATION_INTENSITY { didSet {
    if let view = viewWithTag(VIEW_TAG) as? BaseBlurView {
      view.setSaturationIntensity(
        clamp(saturationIntensity, min: MIN_SATURATION_INTENSITY, max: MAX_SATURATION_INTENSITY)
      )
    }
  }}
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(createBlurView(blurStyle))
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func createBlurView(_ type: NSString) -> BaseBlurView {
    let clampedBlur = clamp(blurIntensity, min: MIN_BLUR_INTENSITY, max: MAX_BLUR_INTENSITY)
    let clampedSaturation = clamp(saturationIntensity, min: MIN_SATURATION_INTENSITY, max: MAX_SATURATION_INTENSITY)
    
    let blur = if type == PLAIN_BLUR_STYLE {
      PlainBlurView(frame, clampedBlur, clampedSaturation)
    } else if type == VARIABLE_BLUR_STYLE {
      VariableBlurView(frame, clampedBlur, clampedSaturation, gradientPoints)
    } else {
      RegularBlurView(frame, clampedBlur, clampedSaturation, UIBlurEffect.Style.from(string: type))
    }
    
    blur.tag = VIEW_TAG
    blur.frame = bounds
    blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    return blur
  }
}
