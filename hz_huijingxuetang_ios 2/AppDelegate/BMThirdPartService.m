//
//  BMThirdPartService.m
//  BM
//
//  Created by txooo on 17/2/28.
//  Copyright © 2017年 张金山. All rights reserved.
//

#import "BMThirdPartService.h"
#import "TXCheckVersion.h"
#import "UserInfoSingleObject.h"
//#import <UMMobClick/MobClick.h>


@implementation BMThirdPartService

+ (void)load {
    
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        [[self class] initParams];
        [[self class] reachableStaus];
        [[self class] setUserInfo];
        [[self class] initKeyBoard];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[self class] checkVersion];
            [[self class] initThirdPartParams];
            [DCURLRouter loadConfigDictFromPlist:@"Router.plist"];
#if DEBUG
         
#endif
        });
    });
}

+ (void)initParams {

}

#pragma mark － 检测网络相关
+ (void)reachableStaus {
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

+ (void)initThirdPartParams{

}

+ (void)setUserInfo {

}



+ (void)reSetCookie {

}

+ (void)checkVersion {
    TXCheckVersion *checkVersion = [TXCheckVersion sharedCheckManager];
    checkVersion.countryAbbreviation = @"cn";
    checkVersion.openAPPStoreInsideAPP = NO;
    checkVersion.debugEnable = YES;
    //是否强制更新
    checkVersion.isForceUpdate = NO;
    [checkVersion checkVersionWithAlertTitle:@"发现新版本" nextTimeTitle:@"下次提示" confimTitle:@"前往更新" skipVersionTitle:@"跳过当前版本"];
}


+ (void)initKeyBoard{
//    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
//    manager.enable = YES;
//    manager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
//    manager.shouldResignOnTouchOutside = YES;
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES; // 控制整个功能是否启用。
    manager.shouldResignOnTouchOutside =YES; // 控制点击背景是否收起键盘
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarByPosition];


}

@end
