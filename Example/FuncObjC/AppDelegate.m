//
//  Copyright (c) 2022 Alexey Nazarov. All rights reserved.
//

#import "AppDelegate.h"
@import ModernObjC;
@import FuncObjC;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(nullable NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions {
    NSLog(@"%@", launchOptions);
    return YES;
}

@end
