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
}
