//
//  AppDelegate+Category.m
//  MK100
//
//  Created by 张金山 on 2018/1/8.
//  Copyright © 2018年 txooo. All rights reserved.
//

#import "AppDelegate+Category.h"
#import "BaseNavigationViewController.h"
#import "LoginViewController.h"
#import "WelcomeViewController.h"
#import "BaseNavigationViewController.h"
#import "CustomTabbarController.h"
@implementation AppDelegate (Category)

- (void)setRootViewController:(UIApplication *)application{
//    application.statusBarStyle = UIStatusBarStyleLightContent;
    NSString *key = @"CFBundleShortVersionString";
    // 取出沙盒中存储的上次使用软件的版本号
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults stringForKey:key];
    // 获得当前软件的版本号
//    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
//    if ([currentVersion isEqualToString:lastVersion]) {
//        if ([[UserInfoSingleObject shareInstance] GetUserInfo] != nil) {
            //显示状态栏
            application.statusBarHidden = NO;
            CustomTabbarController *tabbarVC = [[CustomTabbarController alloc]init];
            self.window.rootViewController = tabbarVC;
//        }else{
//            // 显示状态栏
//            application.statusBarHidden = NO;
//            LoginViewController *logInController = [[LoginViewController alloc] initWithParams:nil];
//            self.window.rootViewController = logInController;
//        }
//    }else {
//        // 新版本
//        [UIApplication sharedApplication].statusBarHidden = YES;
//        self.window.rootViewController = [[WelcomeViewController alloc] init];
//    }
}

- (void)setup3DTouch:(UIApplication *)application{
//    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0){
//        UIApplicationShortcutIcon *accountIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeFavorite];
//        UIApplicationShortcutItem *accountItem = [[UIApplicationShortcutItem alloc] initWithType:@"ACCOUNT" localizedTitle:@"我的账户" localizedSubtitle:@"" icon:accountIcon userInfo:nil];
//        application.shortcutItems = @[accountItem];
//    }
}

- (void)performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem {
//    if ([[BMSingleObject shareInstance] GetUserInfo] != nil) {
//           if ([shortcutItem.type isEqualToString:@"ACCOUNT"]){
//
//           }
//    }
}

@end
