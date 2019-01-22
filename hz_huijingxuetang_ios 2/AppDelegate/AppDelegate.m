//
//  AppDelegate.m
//  HuiJingSchool
//
//  Created by Junier on 2018/1/15.
//  Copyright © 2018年 陈燕军. All rights reserved.
//

#import "AppDelegate.h"
#import <NIMSDK/NIMSDK.h>

#import "CustomTabbarController.h"
#import "AppDelegate+Category.h"
#import "AppDelegate+Share.h"

#import <AlipaySDK/AlipaySDK.h>
#import <sys/utsname.h>
#import <WXApi.h>
#import "HJMyOrderViewController.h"

#import "HJPlaceHoderViewController.h"

#import <Contacts/Contacts.h>
#import <AddressBook/AddressBookDefines.h>
#import <AddressBook/ABRecord.h>

#import <Bugly/Bugly.h>

#define CheckOnLineVersion @"1.0.0"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = black_color;
    [self.window makeKeyAndVisible];
    if (@available(iOS 11.0, *)) {
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    HJPlaceHoderViewController *placeHoderVC = [[HJPlaceHoderViewController alloc] init];
    self.window.rootViewController = placeHoderVC;
    
    //检测马甲的部分
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [YJAPPNetwork SetOnlineMaJiaBaoWithCheckVersion:CheckOnLineVersion success:^(NSDictionary *responseObject) {
            NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
           
            if (code == 200) {
                NSString *data = [responseObject objectForKey:@"data"];
                [UserInfoSingleObject shareInstance].isShowMaJia = [data boolValue];
                //自动登录
                if ([APPUserDataIofo AccessToken].length > 0) {
                    [YJAPPNetwork AutoLoginWithAccesstoken:[APPUserDataIofo AccessToken] success:^(NSDictionary *responseObject) {
                        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
                        if (code == 200) {
                            NSDictionary *dic = [responseObject objectForKey:@"data"];
                            [APPUserDataIofo writeAccessToken:[dic objectForKey:@"accesstoken"]];
                            [APPUserDataIofo getUserID:[dic objectForKey:@"userid"]];
                            [APPUserDataIofo getEval:[NSString stringWithFormat:@"%@",[dic objectForKey:@"eval"]]];
                            
                            //加载配置
                            [self loadApplicationConfigWithApplication:application];
                        } else if (code == 10) {
                            //账号被挤掉
                            NSDictionary *dic = [responseObject objectForKey:@"data"];
                            [APPUserDataIofo writeAccessToken:[dic objectForKey:@"accesstoken"]];
                            [APPUserDataIofo getUserID:[dic objectForKey:@"userid"]];
                            [APPUserDataIofo getEval:[NSString stringWithFormat:@"%@",[dic objectForKey:@"eval"]]];

                            //加载配置
                            [self loadApplicationConfigWithApplication:application];
                        } else{
                            ShowMessage([responseObject objectForKey:@"msg"]);
                        }
                    } failure:^(NSString *error) {
                        ShowMessage(error);
                    }];
                } else {
                    //没有登陆
                    //加载配置
                    [self loadApplicationConfigWithApplication:application];
                }
            } else {
                ShowError([responseObject objectForKey:@"msg"]);
            }
        } failure:^(NSString *error) {
            ShowMessage(netError);
        }];
    });
    
#if DEBUG
    //    for iOS
    [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/iOSInjection10.bundle"] load];
    //    for tvOS
    [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/tvOSInjection10.bundle"] load];
    //    for masOS
    [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/macOSInjection10.bundle"] load];
#endif
    return NO;
}

//加载配置
- (void)loadApplicationConfigWithApplication:(UIApplication *)application {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        //设置根视图控制器
        [self setRootViewController:application];
        
        [self initParams];
        //                    [self autoLogin];
        [self getNIMSDK];
        [self registerSharePlatforms];
        [self location];
        //微信支付注册
        [WXApi registerApp:@"wx9da5846d2c469754"];
        //Bugly
        [Bugly startWithAppId:@"820d27c14f"];
    });
}


/**
 *  设置全局支持方向，然后在控制器中单独配置各自的支持方向
 */
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskAll;
}

//请求定位
- (void)location{
    self.locationManager = [[CLLocationManager alloc] init];
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [self.locationManager  requestWhenInUseAuthorization];
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
        [self.locationManager  requestAlwaysAuthorization ];
        [self.locationManager   requestWhenInUseAuthorization];
        self.locationManager.delegate = self;
        self.locationManager .desiredAccuracy = kCLLocationAccuracyBest;//精准度
        self.locationManager .distanceFilter = 1.0;//移动十米定位一次
        //    位置信息更新最小距离，只有移动大于这个距离才更新位置信息，默认为kCLDistanceFilterNone：不进行距离限制
        [self.locationManager  startUpdatingLocation];
    }
}

#pragma mark location代理
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还未开启定位服务，是否需要开启？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *queren = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *setingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication]openURL:setingsURL];
    }];
    [alert addAction:cancel];
    [alert addAction:queren];
    [VisibleViewController().navigationController presentViewController:alert animated:YES completion:nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [self.locationManager stopUpdatingLocation];//停止定位
    //地理反编码
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    //当系统设置为其他语言时，可利用此方法获得中文地理名称
    NSMutableArray
    *userDefaultLanguages = [[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"];
    // 强制 成 简体中文
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans", nil]forKey:@"AppleLanguages"];
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        NSString *currentCity = @"";
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            NSDictionary *addressDic = placeMark.addressDictionary;//地址的所有信息
            NSString *state=[addressDic objectForKey:@"State"];//省。直辖市  江西省
            NSString *city=[addressDic objectForKey:@"City"];
            NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
            [defa setValue:[NSString stringWithFormat:@"%@%@",state,city] forKey:@"CurrentLocation"];
            [defa synchronize];
            
            DLog(@"定位到的城市是:%@",[NSString stringWithFormat:@"%@%@",state,city]);
            
        } else if (error == nil && placemarks.count == 0 ) {
            DLog(@"定位失败");
        } else if (error) {
            currentCity = @"⟳定位获取失败,点击重试";
            DLog(@"定位获取失败,点击重试");
        }
        // 还原Device 的语言
        [[NSUserDefaults
          standardUserDefaults] setObject:userDefaultLanguages
         forKey:@"AppleLanguages"];
    }];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            DLog(@"result = %@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderPaySuccessNoty" object:nil userInfo:nil];
            
            if([UserInfoSingleObject shareInstance].payType == WxOrAlipayTypeBuy) {
                for (UIViewController *vc in VisibleViewController().navigationController.viewControllers) {
                    if([vc  isKindOfClass:[HJMyOrderViewController class]]){
                        return;
                    }
                }
                [DCURLRouter pushURLString:@"route://myOrderVC" query:@{@"isFromOrderPay" : @"YES"} animated:YES];
            } else {
                if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                    //打赏成功
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"GiftRewardSuccessNoty" object:nil userInfo:nil];
                }
            }
        }];

    }
    // 在此方法中做如下判断，因为还有可能有其他的支付，如支付宝就是@"safepay"
    if ([url.host isEqualToString:@"pay"] || [url.host isEqualToString:@"oauth"]) {
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
            DLog(@"result = %@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderPaySuccessNoty" object:nil userInfo:nil];
            
            if([UserInfoSingleObject shareInstance].payType == WxOrAlipayTypeBuy) {
                for (UIViewController *vc in VisibleViewController().navigationController.viewControllers) {
                    if([vc  isKindOfClass:[HJMyOrderViewController class]]){
                        return;
                    }
                }
                [DCURLRouter pushURLString:@"route://myOrderVC" query:@{@"isFromOrderPay" : @"YES"} animated:YES];
            } else {
                //打赏成功
                if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                    //打赏成功
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"GiftRewardSuccessNoty" object:nil userInfo:nil];
                }
            }
        }];
    }
    if ([url.host isEqualToString:@"pay"] || [url.host isEqualToString:@"oauth"]) {
        return [WXApi handleOpenURL:url delegate:self];
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


//网易云信
- (void)getNIMSDK{
    //网易云信 appKey和推送证书
    [[NIMSDK sharedSDK] registerWithAppID:@"2b5791890612603d6bedb3ddef616ea9" cerName:@"developerPush"];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    //设置deviceToken
    [[NIMSDK sharedSDK] updateApnsToken:deviceToken];
}

// iOS9.0以前调用此方法
- (BOOL)application:(UIApplication *)application  handleOpenURL:(NSURL *)url {
    if ([url.host isEqualToString:@"pay"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

//发起微信的请求
- (void)onResp:(BaseResp *)resp{
    if ([resp isKindOfClass:[PayResp class]]) {
        // 微信支付
        if([UserInfoSingleObject shareInstance].payType == WxOrAlipayTypeBuy) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderPaySuccessNoty" object:nil userInfo:nil];
            
            for (UIViewController *vc in VisibleViewController().navigationController.viewControllers) {
                if([vc  isKindOfClass:[HJMyOrderViewController class]]){
                    return;
                }
            }
             [DCURLRouter pushURLString:@"route://myOrderVC" query:@{@"isFromOrderPay" : @"YES"} animated:YES];
        }else {
            //打赏成功
            if(resp.errCode == WXSuccess) {
                DLog(@"微信打赏的次数是");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"GiftRewardSuccessNoty" object:nil userInfo:nil];
            }
        }
    }
//    //微信登陆
//    if([resp isKindOfClass:[SendAuthResp class]]) {
//        SendAuthResp *resp = (SendAuthResp *)resp;
//        if(resp.errCode == WXSuccess) {
//
//        }
//        DLog(@"获取到的code的数据是:%@ %ld %@",resp.code,resp.errCode,resp.state);
//    }
    
}


//- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
//    if (self.isForceLandscape) {
//        return UIInterfaceOrientationMaskLandscape;
//    }else if(self.isForcePortrait){
//        return UIInterfaceOrientationMaskPortrait;
//    }
//    return UIInterfaceOrientationMaskPortrait;
//}


@end
