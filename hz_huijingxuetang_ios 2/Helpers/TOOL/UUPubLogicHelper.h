//
//  UUPubLogicHelper.h
//  UUSoft
//  逻辑类公共方法
//  单例
//  Created by jagtu on 14-6-11.
//  Copyright (c) 2014年 com.66money. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UUPubLogicHelper : NSObject


/* 逻辑公共方法 */

//#pragma mark 签名
//+(NSString *)getSig:(NSString *)string;

#pragma mark 颜色转换 IOS中十六进制的颜色转换为UIColor
+(UIColor *) colorWithHexString: (NSString *)color;

#pragma mark UIColor生成UIImage
+(UIImage *) createImageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;

#pragma mark 格式化金额为32,233.0这种格式
+(NSString*)formatMoneyString:(NSString*)str;

#pragma mark 格式化身份证、手机号码 
//加星号
+(NSString*)secureFormatMobileOrCardString:(NSString*)str;


//NSDate转为NSString
+ (NSString *)stringFromDate:(NSDate *)date;

+ (NSString *)stringFromDateLess:(NSDate *)date;

//NSString转为时间戳
+(float)longtimeFromString:(NSString *)string;


//NSString转为NSDate
+ (NSDate *)dateFromString:(NSString *)string;

//高斯模糊效果
+ (UIImage *)blurryImage:(UIView *)view withBlurLevel:(CGFloat)blur;

//验证手机号码
+ (BOOL)validateMobile:(NSString *)mobileNum;
//验证昵称
+ (BOOL) validateNickName:(NSString *)nickName;
//验证交易密码
+ (BOOL)validateTrades:(NSString *)text;
//验证密码
+ (BOOL) validatePassword:(NSString *)passWord;
//验证身份证号 - 验证过于简单
+ (BOOL) validateIdentityCard: (NSString *)identityCard;
//验证身份证号 合法性
+ (BOOL)chk18PaperId:(NSString *) sPaperId;

+ (NSString *)treatSpectialChar:(NSString *)intput;

//获取当天时间的字符
+ (NSString *)nowTimeDateAllString;

//把两个时期相差的秒数
+ (NSTimeInterval)timeDifference:(NSString *)fromDateStr toDateStr:(NSString *)toDateStr;

//获取时间戳
+ (NSString *)nowTimeSp;

//获取哪一年
+ (NSString *)stringFromDateYear:(NSDate *)date;

//从时间戳转换到日期
+ (NSString *)DateStringFromTimeSp:(NSString *)timeSp;

//获取明天的日期
+ (NSString *)GetTomorrowDay;

//DES解密
+ (NSData *)decryptUseDES:(NSData*)cipherData key:(NSString*)key;

//检测textField有没有输入内容
+ (BOOL)TextFiledHaveInput:(UITextField *)textField;

//返回一个字符串第一个字母拼音，例如A，不能识别的返回#
+ (NSString *)PinyinFirstLetter:(NSString *)str;

//获取当天设备ID地址字符串
+ (NSString *)deviceIPAdress;

//把dictionary转成string
+ (NSString *)DictionaryToJsonString:(NSDictionary *)dic;

//把string转成id
+ (id)JsonStringToObject:(NSString *)string;

//判断字符串是否为空
+(BOOL) isBlankString:(NSString *)string;

//判断是否为银行卡
+(BOOL)checkCardNo:(NSString*)cardNo;


@end
