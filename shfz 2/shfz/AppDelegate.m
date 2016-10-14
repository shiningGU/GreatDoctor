//
//  AppDelegate.m
//  shfz
//
//  Created by shanghaifuzhong on 15/7/30.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "AppDelegate.h"
#import "RootTabBarController.h"
#import "ViewController.h"
#import "DarkView.h"
#import "APIKey.h"

#import <SMS_SDK/SMSSDK.h>
#import <MAMapKit/MAMapKit.h>

// 短信验证码key
#define appKey @"5b2655c71290"
#define appSecret @"55988074b9a3faadffa6f74cd3ae7845"

// shareSDK key
#define shareKey @"ba292c8adf10"
#define shareSecret @"9ce38c89c3464e80660b03b6008c67a2"

@interface AppDelegate ()
{
    RootTabBarController *rootVC;
    DarkView *_grayBackView;
}

@end

@implementation AppDelegate

- (void)configureAPIKey
{
    if ([APIKey length] == 0)
    {
        NSString *reason = [NSString stringWithFormat:@"apiKey为空，请检查key是否正确设置。"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:reason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
    [MAMapServices sharedServices].apiKey = (NSString *)APIKey;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //短信验证码 初始化应用，appKey和appSecret从后台申请得到
    [SMSSDK registerApp:appKey
              withSecret:appSecret];
    
    //高德地图
    [self configureAPIKey];
    
    // 设置状态栏字体颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // 判断网络
    [shfz_AFNetworking netWorkStatus];
    
    // 调暗背景色通知
    NSNotificationCenter *getDarkCenter = [NSNotificationCenter defaultCenter];
    [getDarkCenter addObserver:self selector:@selector(getDarkNotification:) name:@"getDark" object:nil];
    
    return YES;
}

#pragma mark - 调暗背景色通知
- (void)getDarkNotification:(NSNotification *)noti
{
    if ([noti.object isEqualToString:@"dark"]) {
        
        // 背景view
        _grayBackView = [[DarkView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.window addSubview:_grayBackView];
        
    }else if ([noti.object isEqualToString:@"light"]){
        
        [_grayBackView removeFromSuperview];
    }
}

#pragma mark - 设置禁止横屏
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - application协议方法
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
