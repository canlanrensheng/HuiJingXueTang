//
//  ConventionJudge.h
//  TennisClass
//
//  Created by Junier on 2017/12/13.
//  Copyright © 2017年 陈燕军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConventionJudge : NSObject

/**
 判断手机
 **/
+(BOOL)isTruePhone: (NSString *)phone;

/**
 得到随机英文加数字
 **/
+(NSString *)getRandomStringWithNum;

/**
 用户定位权限判断
 **/
//+(BOOL)openLocationService;
+(BOOL)isopenLoction;


/**
 字典转JSON字符串
 **/
+(NSString *)convertToJsonData:(NSDictionary *)dict;

/**
 传入秒得到天时分
 **/
+(NSString *)getDDHHMMFromSS:(NSString *)totalTime;
/**
 传入秒得到XX:XX:XX
 **/
+(NSString *)getMMSSFromSS:(NSString *)totalTime;
/**
 传入秒得到XX:XX
 **/
+(NSString *)getSSFromSS:(NSString *)totalTime;


+ (BOOL)isNotNULL:(id)obj;
//判断邮箱格式
+ (BOOL)isValidateEmail:(NSString *)email;


//用来判断返回的网络错误码
+ (void)NetCode:(NSInteger)code vc:(UIViewController *)vc type:(NSString *)type;

@end
