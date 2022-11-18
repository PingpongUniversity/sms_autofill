#import "SmsAutoFillPlugin.h"

@implementation OTPPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"sms_autofill_channel"
            binaryMessenger:[registrar messenger]];
  OTPPlugin* instance = [[OTPPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  result(nil);
}

@end
