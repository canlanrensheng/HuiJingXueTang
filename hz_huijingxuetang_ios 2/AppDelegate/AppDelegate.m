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

#import <sys/utsname.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = white_color;
    [self.window makeKeyAndVisible];
    //设置根视图控制器
    [self setRootViewController:application];
    [self autoLogin];
    [self getNIMSDK];
    [self registerSharePlatforms];
    [self location];
    
    NSString *deviceModel = [[UIDevice currentDevice] model]; //获取设备的型号 例如：iPhone
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    DLog(@"获取到的设备的信息是:%@ %@",deviceModel,platform);
    
    if (@available(iOS 11.0, *)) {
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
    }
    return YES;
}


- (void)location{
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager  requestAlwaysAuthorization];//请求授权
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        self.locationManager.distanceFilter = 200.0f;
        [self.locationManager requestAlwaysAuthorization];//位置权限申请
        [self.locationManager startUpdatingLocation];
    } else {
        ShowMessage(@"请开启定位功能！");
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

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
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
        } else if (error == nil && placemarks.count == 0 ) {
            
        } else if (error) {
            currentCity = @"⟳定位获取失败,点击重试";
        }
        // 还原Device 的语言
        [[NSUserDefaults
          standardUserDefaults] setObject:userDefaultLanguages
         forKey:@"AppleLanguages"];
    }];
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

- (void)autoLogin{
    if ([APPUserDataIofo AccessToken].length > 0) {
        [YJAPPNetwork AutoLoginWithAccesstoken:[APPUserDataIofo AccessToken] success:^(NSDictionary *responseObject) {
            NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSDictionary *dic = [responseObject objectForKey:@"data"];
                [APPUserDataIofo writeAccessToken:[dic objectForKey:@"accesstoken"]];
                [APPUserDataIofo getUserID:[dic objectForKey:@"userid"]];
            }else{
                ShowError([responseObject objectForKey:@"msg"]);
            }
        } failure:^(NSString *error) {
            [SVProgressHUD showInfoWithStatus:netError];
        }];
    }
}

//网易云信
- (void)getNIMSDK{
    [[NIMSDK sharedSDK]registerWithAppID:@"2b5791890612603d6bedb3ddef616ea9" cerName:@"developerPush"];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[NIMSDK sharedSDK] updateApnsToken:deviceToken];
}


//-(void)getWXApi{
//    [WXApi registerApp:@"wx9da5846d2c469754"];
//}
//
//-(UIImage *)getnewimage:(UIImage *)image{
//    UIImage *image1 = image;
//    UIGraphicsBeginImageContext(CGSizeMake(17, 17));
//    [image1 drawInRect:CGRectMake(0.0f, 0.0f, 17, 17)];
//    image1 = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image1;
//}
//
//// iOS9.0以前调用此方法
//- (BOOL)application:(UIApplication *)application  handleOpenURL:(NSURL *)url {
//    if ([url.host isEqualToString:@"pay"]) {
//        return [WXApi handleOpenURL:url delegate:self];
//    }
//    return YES;
//}
//
//
//
//- (void)onResp:(BaseResp *)resp{
//    if ([resp isKindOfClass:[PayResp class]]) {
//        // 微信支付
//        PayResp*response=(PayResp*)resp;
//        switch(response.errCode){
//            case 0:
//                NSLog(@"支付成功");
//                break;
//            case -1:
//                NSLog(@"支付失败！");
//                break;
//            case -2:
//                NSLog(@"支付失败！");
//                break;
//            default:
//                NSLog(@"支付失败！");
//                break;
//                  }
//              }
//          }

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    if (self.isForceLandscape) {
        return UIInterfaceOrientationMaskLandscape;
    }else if(self.isForcePortrait){
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskPortrait;
}


@end
