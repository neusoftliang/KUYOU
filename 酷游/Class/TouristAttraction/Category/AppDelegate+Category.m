//
//  AppDelegate+Category.m
//  BaseProject
//
//  Created by tarena on 15/12/16.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "AppDelegate+Category.h"

@implementation AppDelegate (Category)

- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"000000000000000000");
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}
-(void)initializeWithApplication:(UIApplication *)application
{
    // Override point for customization after application launch.
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    //能够检测当前网络是WiFi，蜂窝网络，没有网络
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
                MYLog(@"wifi");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                MYLog(@"当前无网络");
                break;
            case AFNetworkReachabilityStatusUnknown:
                MYLog(@"当前网络未知");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                MYLog(@"当前是蜂窝网络");
                break;
            default:
                break;
        }
    }];
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
}
@end











