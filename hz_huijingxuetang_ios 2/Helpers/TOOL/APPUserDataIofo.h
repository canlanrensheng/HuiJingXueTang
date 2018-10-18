//
//  APPUserDataIofo.h
//  TennisClass
//
//  Created by Junier on 2017/12/13.
//  Copyright © 2017年 陈燕军. All rights reserved.
//



#import <Foundation/Foundation.h>

@interface APPUserDataIofo : NSObject
/**
 存入accessToken
 **/
+(void)writeAccessToken:(NSString *)accessToken;

/**
 获取用户token
 **/
+ (NSString *)AccessToken;


/**
 存入accessToken
 **/
+(void)getAccess:(NSString *)access;

/**
 获取用户token
 **/
+ (NSString *)Access;
/**
 存入用户ID
 **/
+(void)getUserID:(NSString *)userid;

/**
 获取用户ID
 **/
+ (NSString *)UserID;

/**
 存入用户昵称
 **/
+(void)getUserName:(NSString *)nikename;

/**
 获取用户昵称
 **/
+ (NSString *)nikename;

/**
 存入用户手机
 **/
+(void)getUserPhone:(NSString *)phone;

/**
 获取用户手机
 **/
+ (NSString *)phone;

//改变用户是否登录
+ (void)ChangeUserIsLogin:(BOOL)login;

//获取用户是否在线
+ (BOOL)UserIsLogin;

/**
 存入cityid
 **/
+(void)getCity:(NSString *)cityid;

/**
 获取cityid
 **/
+ (NSString *)CityId;


/**
 存入cityname
 **/
+(void)getCityname:(NSString *)cityname;

/**
 获取cityname
 **/
+ (NSString *)Cityname;

/**
 存入cityshortname
 **/
+(void)getCityshortname:(NSString *)cityshortname;

/**
 获取cityshortname
 **/
+ (NSString *)Cityshortname;

/**
 存入用户头像
 **/
+(void)getUserIcon:(NSString *)usericon;

/**
 获取用户头像
 **/
+ (NSString *)UserIcon;
/**
 登出
 **/
+(void)LogOut;


/**
 存入DeviceToken
 **/
+(void)getDeviceToken:(NSString *)deviceToken;

/**
 获取DeviceToken
 **/
+ (NSString *)DeviceToken;

/**
 是否首次下载
 **/
+(void)isFirstDL:(NSString * )num;

/**
 是否首次下载
 **/
+ (NSString * )isFirstDL;

@end
