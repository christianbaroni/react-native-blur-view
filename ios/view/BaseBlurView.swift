//
//  BaseBlurView.swift
//  react-native-blur-view
//
//  Created by Kirill Gudkov on 08.08.2024.
//

// MARK: - BaseBlurView.swift

import UIKit

class BaseBlurView: UIView {
  
  var blurFilter: NSObject?
  var saturationFilter: NSObject?
  var effectView: UIVisualEffectView?
  var currentBlurIntensity: CGFloat
  
  private var currentSaturationIntensity: CGFloat
  private static let backdropLayerClass: AnyClass? = NSClassFromString("Q0FCYWNrZHJvcExheWVy".base64Decoded())
  
  // MARK: - Init
  
  init(
    _ frame: CGRect,
    _ blurIntensity: CGFloat,
    _ saturationIntensity: CGFloat,
    _ filterType: FilterType,
    _ style: UIBlurEffect.Style
  ) {
    self.currentBlurIntensity        = blurIntensity
    self.currentSaturationIntensity = saturationIntensity
    
    super.init(frame: frame)
    
    effectView = UIVisualEffectView(effect: UIBlurEffect(style: style))
    effectView?.frame = bounds
    effectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    if let ev = effectView {
      addSubview(ev)
    }
    effectView?.clipsToBounds = false
    
    blurFilter       = createFilter(type: filterType)
    saturationFilter = createFilter(type: .saturate)
    
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  // MARK: - Lifecycle
  
  override func tintColorDidChange() {
    super.tintColorDidChange()
    refreshView()
  }
  
  override func didMoveToWindow() {
    super.didMoveToWindow()
    let notifications = NotificationCenter.default
    notifications.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    guard window != nil else { return }

    notifications.addObserver(
      self,
      selector: #selector(applicationDidBecomeActive),
      name: UIApplication.didBecomeActiveNotification,
      object: nil
    )
    refreshView()
  }
  
  // MARK: - Public Methods
  
  func setBlurIntensity(_ intensity: CGFloat) {
    if abs(intensity - currentBlurIntensity) > 0.0001 {
      currentBlurIntensity = intensity
      refreshView()
    }
  }
  
  func setSaturationIntensity(_ intensity: CGFloat) {
    if abs(intensity - currentSaturationIntensity) > 0.0001 {
      currentSaturationIntensity = intensity
      refreshView()
    }
  }
  
  /// Overridden by subclasses for additional setup
  func setupView() {
    refreshView()
  }
  
  // MARK: - Refresh Logic
  
  func refreshView() {
    guard let effectView, let backdropLayer = findBackdropLayer(in: effectView) else { return }
    if let screen = window?.screen {
      backdropLayer.setValue(screen.scale, forKey: "scale")
    }

    // Re-apply the blur and saturation filters
    blurFilter?.setValue(currentBlurIntensity, forKey: radiusKeyStr.base64Decoded())
    saturationFilter?.setValue(currentSaturationIntensity, forKey: satKeyStr.base64Decoded())
    
    if let b = blurFilter, let s = saturationFilter {
      applyFilters([b, s], to: backdropLayer)
    } else {
      applyFilters([], to: backdropLayer)
    }
  }

  func applyFilters(_ filters: [NSObject], to backdropLayer: CALayer) {
    backdropLayer.filters = []
    backdropLayer.filters = filters
  }
  
  // MARK: - Private Helpers
  
  @objc private func applicationDidBecomeActive(_ notification: Notification) {
    // UIKit can replace our filters while restoring its visual effect views.
    refreshView()
  }

  private func findBackdropLayer(in view: UIView) -> CALayer? {
    guard let backdropLayerClass = Self.backdropLayerClass else { return nil }
    if view.layer.isKind(of: backdropLayerClass) { return view.layer }
    for subview in view.subviews {
      if let layer = findBackdropLayer(in: subview) { return layer }
    }
    return nil
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
    
    if (type == .gaussian || type == .variable) {
      filter.setValue(true, forKey: normalizeKeyStr.base64Decoded())
    }
      
    return filter
  }
}

let filterStr = "Q0FGaWx0ZXI="
let propStr = "ZmlsdGVyV2l0aFR5cGU6"
let radiusKeyStr = "aW5wdXRSYWRpdXM="
let satKeyStr = "aW5wdXRBbW91bnQ="
let normalizeKeyStr = "aW5wdXROb3JtYWxpemVFZGdlcw=="
