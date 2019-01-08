//
//  APPUserDataIofo.m
//  TennisClass
//
//  Created by Junier on 2017/12/13.
//  Copyright © 2017年 陈燕军. All rights reserved.
//

#import "APPUserDataIofo.h"
#import "LoginViewController.h"

NSString * const AccessToken  = @"accessToken";
NSString * const Access  = @"access";

NSString * const UserID  = @"userID";
NSString * const Eval  = @"eval";
NSString * const UserIsLoginInfoKey = @"UserIsLoginInfoKey";
NSString * const Cityid  = @"cityID";
NSString * const CityName  = @"cityname";
NSString * const CityShortName  = @"cityshortname";
NSString * const UserIcon  = @"usericon";
NSString * const NikeName  = @"nikename";
NSString * const Sex  = @"sex";
NSString * const Phone  = @"phone";
NSString * const DeviceToken  = @"deviceToken";



@implementation APPUserDataIofo

/**
 存入openId
 **/
+(void)writeOpenId:(NSString *)openId {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:openId forKey:@"openId"];
    [userdefaults synchronize];
}

/**
 获取用户openId
 **/
+ (NSString *)OpenId {
    NSString *openId = [[NSUserDefaults standardUserDefaults] stringForKey:@"openId"];
    if (openId == nil) {
        openId = @"";
        
    }
    return openId;
}


/**
 存入accessToken
 **/

+(void)writeAccessToken:(NSString *)accessToken
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:accessToken forKey:AccessToken];
    [userdefaults synchronize];
}

//获取用户token
+ (NSString *)AccessToken{
    NSString *accesstoken = [[NSUserDefaults standardUserDefaults] stringForKey:AccessToken];
    if (accesstoken == nil) {
        accesstoken = @"";
        
    }
    return accesstoken;
}

/**
 存入access
 **/

+(void)getAccess:(NSString *)access
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:access forKey:Access];
    [userdefaults synchronize];
}

//获取用户access
+ (NSString *)Access{
    NSString *access = [[NSUserDefaults standardUserDefaults] stringForKey:Access];
    if (access == nil) {
        access = @"";
    }
    return access;
}


/**
 存入用户ID
 **/

+(void)getUserID:(NSString *)userid
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:userid forKey:UserID];
    [userdefaults synchronize];
    
}

//获取用户ID
+ (NSString *)UserID{
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:UserID];
    if (userid == nil) {
        userid = @"";
    }
    return userid;
}

/**
 存入风险评估
 **/
+(void)getEval:(NSString *)eval {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:eval forKey:Eval];
    [userdefaults synchronize];
}

/**
 //获取是否做过风险评估
 **/
+ (NSString *)Eval {
    NSString *eval = [[NSUserDefaults standardUserDefaults] stringForKey:Eval];
    if (eval == nil) {
        eval = @"";
    }
    return eval;
}

/**
 存入用户昵称
 **/
+(void)getUserName:(NSString *)nikename{
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:nikename forKey:NikeName];
    [userdefaults synchronize];
}


/**
 获取用户昵称
 **/
+ (NSString *)nikename{
    NSString *Nikename = [[NSUserDefaults standardUserDefaults] stringForKey:NikeName];
    if (Nikename == nil) {
        Nikename = @"";
    }
    return Nikename;
    
}

/**
 存入性别
 **/
+(void)getSex:(NSString *)sex{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:sex forKey:Sex];
    [userdefaults synchronize];
}

/**
 获取用户性别
 **/
+ (NSString *)sex {
    NSString *sex = [[NSUserDefaults standardUserDefaults] stringForKey:Sex];
    if (sex == nil) {
        sex = @"";
    }
    return sex;
}

/**
 存入用户手机
 **/
+(void)getUserPhone:(NSString *)phone{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:phone forKey:Phone];
    [userdefaults synchronize];
}


/**
 获取用户手机
 **/
+ (NSString *)phone{
    NSString *Phonemu = [[NSUserDefaults standardUserDefaults] stringForKey:Phone];
    if (Phonemu == nil) {
        Phonemu = @"";
    }
    return Phonemu;
    
}



//改变用户是否登录
+ (void)ChangeUserIsLogin:(BOOL)login{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:login] forKey:UserIsLoginInfoKey];
    [defaults synchronize];
    
}

//获取用户是否在线
+ (BOOL)UserIsLogin{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:UserIsLoginInfoKey] boolValue];
}

/**
 存入Citydi
 **/

+(void)getCity:(NSString *)cityid
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:cityid forKey:Cityid];
    [userdefaults synchronize];
}

/**
 获取Citydi
 **/
+(NSString *)CityId{
    NSString *cityid = [[NSUserDefaults standardUserDefaults] stringForKey:Cityid];
    if (cityid == nil) {
        cityid = @"";
    }
    return cityid;
}


/**
 存入Cityname
 **/

+(void)getCityname:(NSString *)cityname
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:cityname forKey:CityName];
    [userdefaults synchronize];
}

/**
 获取Cityname
 **/
+(NSString *)Cityname{
    NSString *cityid = [[NSUserDefaults standardUserDefaults] stringForKey:CityName];
    if (cityid == nil) {
        cityid = @"";
    }
    return cityid;
}

//存入问题返回时间

+(void)getProblemBacktTime:(NSString *)problembacktime {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:problembacktime forKey:@"problembacktime"];
    [userdefaults synchronize];
}

/**
 获取问题反馈时间
 **/
+ (NSString *)Problembacktime {
    NSString *problembacktime = [[NSUserDefaults standardUserDefaults] stringForKey:@"problembacktime"];
    if (problembacktime == nil) {
        problembacktime = @"";
    }
    return problembacktime;
}

//联系人
+(void)getContact:(NSString *)contact {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:contact forKey:@"contact"];
    [userdefaults synchronize];
}

//合伙人的标示
+(void)getPartner:(NSString *)partner {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:partner forKey:@"partner"];
    [userdefaults synchronize];
}

/**
 获取合伙人的标示
 **/
+ (NSString *)Partner {
    NSString *partner = [[NSUserDefaults standardUserDefaults] stringForKey:@"partner"];
    if (partner == nil) {
        partner = @"";
    }
    return partner;
}

/**
 获取问题反馈时间
 **/
+ (NSString *)Contact {
    NSString *contact = [[NSUserDefaults standardUserDefaults] stringForKey:@"contact"];
    if (contact == nil) {
        contact = @"";
    }
    return contact;
}

/**
 存入Cityshortname
 **/

+(void)getCityshortname:(NSString *)cityshortname
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:cityshortname forKey:CityShortName];
    [userdefaults synchronize];
}

/**
 获取Cityshortname
 **/
+(NSString *)Cityshortname{
    NSString *cityid = [[NSUserDefaults standardUserDefaults] stringForKey:CityShortName];
    if (cityid == nil) {
        cityid = @"";
    }
    return cityid;
}

/**
 存入Cityshortname
 **/

+(void)getUserIcon:(NSString *)usericon
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:usericon forKey:UserIcon];
    [userdefaults synchronize];
}

/**
 获取Cityshortname
 **/
+(NSString *)UserIcon{
    NSString *usericon = [[NSUserDefaults standardUserDefaults] stringForKey:UserIcon];
    if (usericon == nil) {
        usericon = @"";
    }
    return usericon;
}
/**
 登出
 **/
+(void)LogOut{
    [self writeAccessToken:@""];
    [self getAccess:@""];
    [self getUserID:@""];
    [self getUserName:@""];
    [self getUserPhone:@""];
    [self getUserIcon:@""];
    [self ChangeUserIsLogin:NO];

}

/**
 存入DeviceToken
 **/
+(void)getDeviceToken:(NSString *)deviceToken{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:deviceToken forKey:DeviceToken];
    [userdefaults synchronize];
}

/**
 获取DeviceToken
 **/
+ (NSString *)DeviceToken{
    NSString *devicetoken = [[NSUserDefaults standardUserDefaults] stringForKey:DeviceToken];
    if (devicetoken == nil) {
        devicetoken = @"";
    }
    return devicetoken;
}

/**
 是否首次下载
 **/
+(void)isFirstDL:(NSString *)num{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:num forKey:@"isFrist"];
}

/**
 是否首次下载
 **/
+ (NSString * )isFirstDL{
    NSString *  num = [[NSUserDefaults standardUserDefaults] stringForKey:@"isFrist"];
    if (num == nil) {
        num = @"0";
    }
    return num;
}
@end
