//
//  AppDelegate.h
//  HuiJingSchool
//
//  Created by Junier on 2018/1/15.
//  Copyright © 2018年 陈燕军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <WXApi.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(assign,nonatomic) BOOL isForcePortrait;
@property(assign,nonatomic) BOOL isForceLandscape;
@property (nonatomic,strong) CLLocationManager *locationManager;

@end

