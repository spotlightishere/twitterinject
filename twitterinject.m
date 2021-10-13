@import Darwin;
@import Foundation;
@import ObjectiveC;

static dispatch_once_t onceToken;

@interface TTACoreAnatomyFeaturesExtended : NSObject
- (bool)isReactionsPrototypeEnabled;
- (bool)isTFNReactionsPickerEnabled;
@end

@implementation TTACoreAnatomyFeaturesExtended
- (bool)isReactionsPrototypeEnabled {
  return YES;
}
- (bool)isTFNReactionsPickerEnabled {
  return YES;
}
@end

//////////////////////////////////////////////////////////////////////

@interface TFNTwitterFeatureSwitchesExtended : NSObject
- (bool)boolForKey:(NSString *)keyName;
@end

@implementation TFNTwitterFeatureSwitchesExtended
- (bool)boolForKey:(NSString *)keyName {
  NSLog(@"Requested key named %@\n", keyName);
  return YES;
}
@end

//////////////////////////////////////////////////////////////////////

@interface TFSFeatureSwitchesExtended : NSObject
- (bool)boolForKey:(NSString *)keyName;
@end

@implementation TFSFeatureSwitchesExtended
- (bool)boolForKey:(NSString *)keyName {
  // -[TFNTwitterDeviceFeatureSwitches
  // isNotificationsAuthorizationBackgroundTaskEnabled]
  if ([keyName isEqualToString:@"_k3i1"]) {
    return NO;
  }

  return YES;
}
@end

//////////////////////////////////////////////////////////////////////

void swizzleMethodName(NSString *className, SEL funcSelector) {
  Class class = NSClassFromString(className);
  Class swizzledClass =
      NSClassFromString([NSString stringWithFormat:@"%@Extended", className]);

  Method originalMethod = class_getInstanceMethod(class, funcSelector);
  Method swizzledMethod = class_getInstanceMethod(swizzledClass, funcSelector);

  // Blue wire, meet red wire
  method_exchangeImplementations(originalMethod, swizzledMethod);
}

__attribute__((constructor)) void hook_all_necessary_funcs() {
  dispatch_once(&onceToken, ^{
    // // Enable reactions
    // swizzleMethodName(@"TTACoreAnatomyFeatures",
    //                   @"isReactionsPrototypeEnabled");
    // swizzleMethodName(@"TTACoreAnatomyFeatures",
    //                   @"isTFNReactionsPickerEnabled");

    // Everything!
    swizzleMethodName(@"TFSFeatureSwitches", @selector(boolForKey:));
  });
}