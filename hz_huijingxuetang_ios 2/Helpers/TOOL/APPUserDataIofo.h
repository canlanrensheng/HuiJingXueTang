//
//  APPUserDataIofo.h
//  TennisClass
//
//  Created by Junier on 2017/12/13.
//  Copyright © 2017年 陈燕军. All rights reserved.
//



#import <Foundation/Foundation.h>

@interface APPUserDataIofo : NSObject

//是否获取过微信openId

/**
 存入openId
 **/
+(void)writeOpenId:(NSString *)openId;

/**
 获取用户openId
 **/
+ (NSString *)OpenId;

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
 存入风险评估
 **/
+(void)getEval:(NSString *)eval;

/**
//获取是否做过风险评估
 **/
+ (NSString *)Eval;

/**
 存入用户昵称
 **/
+(void)getUserName:(NSString *)nikename;

/**
 获取用户昵称
 **/
+ (NSString *)nikename;

/**
 存入性别
 **/
+(void)getSex:(NSString *)sex;

/**
 获取用户性别
 **/
+ (NSString *)sex;

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

//
/**
 存入问题反馈时间
 **/
+(void)getProblemBacktTime:(NSString *)problembacktime;

/**
 获取问题反馈时间
 **/
+ (NSString *)Problembacktime;

//联系人
+(void)getContact:(NSString *)contact;

/**
 获取联系人
 **/
+ (NSString *)Contact;

//合伙人的标示
+(void)getPartner:(NSString *)partner;

/**
 获取合伙人的标示
 **/
+ (NSString *)Partner;

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
