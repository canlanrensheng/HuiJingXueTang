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
#import "HJRootViewController.h"

#import "TXCheckVersion.h"
@implementation AppDelegate (Category)

- (void)setRootViewController:(UIApplication *)application{
    application.statusBarStyle = UIStatusBarStyleLightContent;
    NSString *key = @"CFBundleShortVersionString";
    // 取出沙盒中存储的上次使用软件的版本号
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults stringForKey:key];
    // 获得当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    if ([currentVersion isEqualToString:lastVersion]) {
        //显示状态栏
        application.statusBarHidden = NO;
        HJRootViewController *rootVC = [[HJRootViewController alloc] init];
        BaseNavigationViewController *nav =[[BaseNavigationViewController alloc] initWithRootViewController:rootVC];
        self.window.rootViewController = nav;
    } else {
        // 新版本
        [UIApplication sharedApplication].statusBarHidden = YES;
        self.window.rootViewController = [[WelcomeViewController alloc] init];
    }
}

- (void)setup3DTouch:(UIApplication *)application{

}

- (void)performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem {

}

- (void)initParams {
    [self reachableStaus];
    [self checkVersion];
    [self initKeyBoard];
    [DCURLRouter loadConfigDictFromPlist:@"Router.plist"];
}

#pragma mark － 检测网络相关
- (void)reachableStaus {
    Reachability *reachability = Reachability.reachabilityForInternetConnection;
    // 网络环境监测
    RAC([UserInfoSingleObject shareInstance], networkStatus) = [[[[[NSNotificationCenter defaultCenter]
                                                                   rac_addObserverForName:kReachabilityChangedNotification object:nil]
                                                                  map:^(NSNotification *notification) {
                                                                      return @([notification.object currentReachabilityStatus]);
                                                                  }]
                                                                 startWith:@(reachability.currentReachabilityStatus)]
                                                                distinctUntilChanged];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [reachability startNotifier];
    });
    
    
}

- (void)checkVersion {
    TXCheckVersion *checkVersion = [TXCheckVersion sharedCheckManager];
    [checkVersion checkVersion];
}


- (void)initKeyBoard{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES; // 控制整个功能是否启用。
    manager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarByPosition];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}


@end
