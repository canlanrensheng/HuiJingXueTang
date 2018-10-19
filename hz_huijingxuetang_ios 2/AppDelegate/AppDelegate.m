//
//  AppDelegate.m
//  HuiJingSchool
//
//  Created by Junier on 2018/1/15.
//  Copyright © 2018年 陈燕军. All rights reserved.
//

#import "AppDelegate.h"
#import <NIMSDK/NIMSDK.h>
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>
#import <UMShare/UMShare.h>

#import "CustomTabbarController.h"
#import "AppDelegate+Category.h"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = white_color;
    [self.window makeKeyAndVisible];
    //设置根试图控制器
    [self setRootViewController:application];
    
    [self autoLogin];
    [self getNIMSDK];
    [self getWXApi];
    [self setUShare];
    
    if (@available(iOS 11.0, *)) {
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
    }
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    // 在此方法中做如下判断，因为还有可能有其他的支付，如支付宝就是@"safepay"
    if ([url.host isEqualToString:@"pay"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}

//-(void)getmain{
//    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    UITabBarController *tb=[[UITabBarController alloc]init];
//    
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    // 2.通过标识符找到对应的页面
//    UIViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"HomePageViewController"];
////    HomePageViewController *vc1 = [[HomePageViewController alloc]init];
//    YAZLNavigationController *nvc1 = [[YAZLNavigationController alloc]initWithRootViewController:vc];
//    nvc1.tabBarItem.title=@"首页";
//    vc.view.backgroundColor=ALLViewBgColor;
//    nvc1.tabBarItem.image = [UIImage imageNamed:@"image1"];
//    nvc1.tabBarItem.selectedImage = [UIImage imageNamed:@"image2"];
//    [vc.navigationController setNavigationBarHidden:YES];
//
//    LivePageViewController *vc2 = [[LivePageViewController alloc]init];
//    YAZLNavigationController *nvc2 = [[YAZLNavigationController alloc]initWithRootViewController:vc2];
//    vc2.view.backgroundColor=ALLViewBgColor;
//    nvc2.tabBarItem.title=@"直播";
//    nvc2.tabBarItem.image = [UIImage imageNamed:@"image3"];
//    nvc2.tabBarItem.selectedImage = [UIImage imageNamed:@"image4"];
//    
//    [vc2.navigationController setNavigationBarHidden:YES];
//
//    
//    
//    SchoolPageViewController *vc3 = [[SchoolPageViewController alloc]init];
//    YAZLNavigationController *nvc3 = [[YAZLNavigationController alloc]initWithRootViewController:vc3];
//    vc3.view.backgroundColor=ALLViewBgColor;
//    nvc3.tabBarItem.title=@"学堂";
//    nvc3.tabBarItem.image = [UIImage imageNamed:@"image5"];
//    nvc3.tabBarItem.selectedImage = [UIImage imageNamed:@"image6"];
//    [vc3.navigationController setNavigationBarHidden:YES];
//
//    // 2.通过标识符找到对应的页面
//    UIViewController *vc4 = [storyBoard instantiateViewControllerWithIdentifier:@"InformationPageViewController"];
//    YAZLNavigationController *nvc4 = [[YAZLNavigationController alloc]initWithRootViewController:vc4];
//    vc4.view.backgroundColor=ALLViewBgColor;
//    nvc4.tabBarItem.title=@"资讯";
//    nvc4.tabBarItem.image = [UIImage imageNamed:@"image7"];
//    nvc4.tabBarItem.selectedImage = [UIImage imageNamed:@"image8"];
//    [vc4.navigationController setNavigationBarHidden:YES];
//
//    
//    MePageViewController *vc5 = [[MePageViewController alloc]init];
//    YAZLNavigationController *nvc5 = [[YAZLNavigationController alloc]initWithRootViewController:vc5];
//    nvc5.tabBarItem.title=@"我的";
//    nvc5.tabBarItem.selectedImage = [UIImage imageNamed:@"image10"];
//    nvc5.tabBarItem.image = [UIImage imageNamed:@"image9"];
//    vc5.navigationItem.title = @"个人中心";
//    vc5.view.backgroundColor = ALLViewBgColor;
//    
//    tb.viewControllers=@[nvc1,nvc2,nvc3,nvc4,nvc5];
//    tb.tabBar.tintColor= NavAndBtnColor;
//    self.window.rootViewController = tb;
//    [self.window makeKeyAndVisible];
//}

-(void)autoLogin{
    if (![[APPUserDataIofo AccessToken]isEqualToString:@""]) {
        [YJAPPNetwork AutoLoginWithAccesstoken:[APPUserDataIofo AccessToken] success:^(NSDictionary *responseObject) {
            NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSDictionary *dic = [responseObject objectForKey:@"data"];
                [APPUserDataIofo writeAccessToken:[dic objectForKey:@"accesstoken"]];
                [APPUserDataIofo getUserID:[dic objectForKey:@"userid"]];

                SVDismiss;
            }else{
            }
        } failure:^(NSString *error) {
            [SVProgressHUD showInfoWithStatus:netError];
        }];
    }
}

-(void)getNIMSDK{
    [[NIMSDK sharedSDK]registerWithAppID:@"2b5791890612603d6bedb3ddef616ea9" cerName:@"developerPush"];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[NIMSDK sharedSDK] updateApnsToken:deviceToken];
}


-(void)getWXApi{
    [WXApi registerApp:@"wx9da5846d2c469754"];
}

-(UIImage *)getnewimage:(UIImage *)image{
    UIImage *image1 = image;
    UIGraphicsBeginImageContext(CGSizeMake(17, 17));
    [image1 drawInRect:CGRectMake(0.0f, 0.0f, 17, 17)];
    image1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image1;
}

// iOS9.0以前调用此方法
- (BOOL)application:(UIApplication *)application  handleOpenURL:(NSURL *)url {
    if ([url.host isEqualToString:@"pay"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}





- (void)onResp:(BaseResp *)resp{
    if ([resp isKindOfClass:[PayResp class]]) {
        // 微信支付
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case 0:
                NSLog(@"支付成功");
                break;
            case -1:
                NSLog(@"支付失败！");
                break;
            case -2:
                NSLog(@"支付失败！");
                break;
            default:
                NSLog(@"支付失败！");
                break;
                  }
              }
          }

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    if (self.isForceLandscape) {
        return UIInterfaceOrientationMaskLandscape;
    }else if(self.isForcePortrait){
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (void)setUShare{
    // 设置友盟AppKey
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"5aee369bb27b0a6dd10007a9"];
    /* 微信聊天 */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx9da5846d2c469754" appSecret:@"461c1efa58d8ac25fc2172afdc7c6f4b" redirectURL:@"http://api.huijingschool.com/"];
    
    /* 微信朋友圈 */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatTimeLine appKey:@"wx9da5846d2c469754" appSecret:@"461c1efa58d8ac25fc2172afdc7c6f4b" redirectURL:@"http://api.huijingschool.com/"];
}

@end
