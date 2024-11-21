#import <React/RCTViewManager.h>

@interface RCT_EXTERN_MODULE(BlurViewManager, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(blurStyle, NSString)
RCT_EXPORT_VIEW_PROPERTY(blurIntensity, CGFloat)
RCT_EXPORT_VIEW_PROPERTY(saturationIntensity, CGFloat)
RCT_EXPORT_VIEW_PROPERTY(fadeStyle, NSString)
RCT_EXPORT_VIEW_PROPERTY(fadePercent, CGFloat)

@end
