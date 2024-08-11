@objc(BlurViewManager)
class BlurViewManager: RCTViewManager {
  
  override func view() -> (BlurView) {
    return BlurView()
  }
  
  override static func requiresMainQueueSetup() -> Bool {
    return true
  }
}
