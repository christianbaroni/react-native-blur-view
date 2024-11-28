//
//  SystemBlurView.swift
//  react-native-blur-view
//
//  Created by Christian Baroni on 11/16/24.
//

class SystemBlurView: UIView {
  private var blurEffectView: UIVisualEffectView
  private var blurEffect: UIBlurEffect?
  private var style: UIBlurEffect.Style

  init(
    _ frame: CGRect,
    _ style: UIBlurEffect.Style
  ) {
    self.style = style
    self.blurEffectView = UIVisualEffectView(effect: nil)
    self.blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    self.blurEffectView.frame = frame

    super.init(frame: frame)

    self.clipsToBounds = true
    addSubview(blurEffectView)
    updateBlurEffect()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func updateBlurEffect() {
    blurEffectView.effect = nil
    blurEffect = UIBlurEffect(style: style)
    blurEffectView.effect = blurEffect
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    blurEffectView.frame = bounds
  }
}