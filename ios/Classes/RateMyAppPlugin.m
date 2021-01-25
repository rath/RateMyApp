#import "RateMyAppPlugin.h"
#import <StoreKit/StoreKit.h>

@implementation RateMyAppPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"rate_my_app"
            binaryMessenger:[registrar messenger]];
  RateMyAppPlugin * instance = [[RateMyAppPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  NSString *m = call.method;
  if ([m isEqualToString:@"launchNativeReviewDialog"]) {
    [SKStoreReviewController requestReview];
    result([NSNumber numberWithBool:YES]);
  } else if ([m isEqualToString:@"isNativeDialogSupported"]) {
    result([NSNumber numberWithBool:YES]);
  } else if ([m isEqualToString:@"launchStore"]) {
    NSString *appId = call.arguments[@"appId"];
    if (appId == nil || appId.length == 0) {
      result(@2);
      return;
    }
    NSString *link = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id/%@?action=write-review", appId];
    NSURL *url = [[NSURL alloc] initWithString:link];
    if ([UIApplication.sharedApplication canOpenURL:url]) {
      [UIApplication.sharedApplication openURL:url options:@{} completionHandler:nil];
      result(@1);
    } else {
      result(@2);
    }
  }
}
@end
