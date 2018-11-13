//
//  ConventionJudge.m
//  TennisClass
//
//  Created by Junier on 2017/12/13.
//  Copyright © 2017年 陈燕军. All rights reserved.
//

#import "ConventionJudge.h"
#import <CoreLocation/CoreLocation.h>
#import "LoginViewController.h"
@implementation ConventionJudge
/**
 判断手机
 **/
+(BOOL)isTruePhone: (NSString *)phone{
    
    if (phone.length != 11)
    {
        return NO;
    }
    
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    //   NSString * PHS = @"^(0[0-9]{2})\\d{8}$|^(0[0-9]{3}(\\d{7,8}))$";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:phone] == YES)
        || ([regextestcm evaluateWithObject:phone] == YES)
        || ([regextestct evaluateWithObject:phone] == YES)
        || ([regextestcu evaluateWithObject:phone] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}


+(NSString *)getRandomStringWithNum{
    
    NSString *string = [[NSString alloc]init];
    for (int i = 0; i < 32; i++) {
        int number = arc4random() % 36;
        if (number < 10) {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
        }else {
            int figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }

    return string;
}


/**
 用户定位权限判断
 **/
+(BOOL)isopenLoction{
    BOOL isOpen = NO;
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        
        //定位功能可用
        isOpen = YES;
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        
        //定位不能用
        
        isOpen = NO;
    }
    return isOpen;
}

// 字典转json字符串方法

+(NSString *)convertToJsonData:(NSDictionary *)dict
{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}
/**
 传入秒得到天时分秒
 **/
+(NSString *)getDDHHMMFromSS:(NSString *)totalTime{
    NSInteger seconds = [totalTime integerValue];
    //format of day
    NSString *str_day = [NSString stringWithFormat:@"%ld",seconds/60/60/24];
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/60/60%24];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
//    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@天%@时%@分",str_day,str_hour,str_minute];
    
    return format_time;
}
+(NSString *)getMMSSFromSS:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue];
    
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    
    return format_time;
}
+(NSString *)getSSFromSS:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue];
    
    //format of hour
//    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    
    return format_time;
}
//判断服务器返回的数据是否为空(nil,NULL等情况)
+ (BOOL)isNotNULL:(id)obj{
    return   NULL!=obj && nil!=obj && (NULL)!=obj && (Nil)!=obj  && [NSNull null]!=obj ?  YES: NO ;
}


//邮箱地址的正则表达式
+ (BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}



//用来判断返回的网络错误码//type 1.回退首页 2.回退上一页的前一页 3回退上一页
+ (void)NetCode:(NSInteger)code vc:(UIViewController *)vc type:(NSString *)type{
    
    switch (code) {
        case 1:
            ShowError(@"您输入的电话号码有误请重新输入");
//            [SVProgressHUD showInfoWithStatus:@"您输入的电话号码有误请重新输入"];
            break;
            
        case 2:
            ShowError(@"当前手机号码已被注册");
//            [SVProgressHUD showInfoWithStatus:@"当前手机号码已被注册"];
            break;
            
        case 3:
            ShowError(@"短信发送失败");
//            [SVProgressHUD showInfoWithStatus:@"短信发送失败"];
            break;
            
        case 4:
            ShowError(@"请输入验证码");
//            [SVProgressHUD showInfoWithStatus:@"请输入验证码"];
            break;
            
        case 5:
            ShowError(@"验证码不正确");
//            [SVProgressHUD showInfoWithStatus:@"验证码不正确"];
            break;
            
        case 6:
            ShowError(@"用户注册失败，请稍后重试");
//            [SVProgressHUD showInfoWithStatus:@"用户注册失败，请稍后重试"];
            break;
            
        case 7:
            ShowError(@"当前手机号码未注册");
//            [SVProgressHUD showInfoWithStatus:@"当前手机号码未注册"];
            break;
            
        case 8:
            ShowError(@"账号或密码不正确");
//            [SVProgressHUD showInfoWithStatus:@"账号或密码不正确"];
            break;
            
        case 9:
            ShowError(@"请输入您的姓名");
//            [SVProgressHUD showInfoWithStatus:@"请输入您的姓名"];
            break;
        case 10:{
            ShowError(@"您还未登录");
//            for (UIViewController *vc in VisibleViewController().navigationController.viewControllers) {
//                DLog(@"获取到的名称是:%@",NSStringFromClass([vc class]));
//                if([vc isKindOfClass:[LoginViewController class]]) {
//                    break;
//                }
//            }
//            LoginViewController *loginvc = [[LoginViewController alloc]init];
//            [VisibleViewController().navigationController pushViewController:loginvc animated:YES];
            break;
        }
        case 11:
            ShowError(@"当前手机号码的信息已提交");
//            [SVProgressHUD showInfoWithStatus:@"当前手机号码的信息已提交"];
            break;
        case 12:
            ShowError(@"未查询到当前套餐信息");
//            [SVProgressHUD showInfoWithStatus:@"未查询到当前套餐信息"];
            break;
        case 13:
            ShowError(@"未查询到当前代金券信息");
//            [SVProgressHUD showInfoWithStatus:@"未查询到当前代金券信息"];
            break;
        case 14:
            ShowError(@"未查询到订单信息");
//            [SVProgressHUD showInfoWithStatus:@"未查询到订单信息"];
            break;
        case 15:
            ShowError(@"未知的支付类型");
//            [SVProgressHUD showInfoWithStatus:@"未知的支付类型"];
            break;
        case 16:
            ShowError(@"当前代金券已过期");
//            [SVProgressHUD showInfoWithStatus:@"当前代金券已过期"];
            break;
        case 17:
            ShowError(@"原密码不正确");
//            [SVProgressHUD showInfoWithStatus:@"原密码不正确"];
            break;
        case 18:
            ShowError(@"两次输入的新密码不相同");
//            [SVProgressHUD showInfoWithStatus:@"两次输入的新密码不相同"];
            break;
        case 19:
            ShowError(@"新旧密码不能相同");
//            [SVProgressHUD showInfoWithStatus:@"新旧密码不能相同"];
            break;
        case 20:
            ShowError(@"存在相同名称");
//            [SVProgressHUD showInfoWithStatus:@"存在相同名称"];
            break;
        case 21:
            ShowError(@"邀请码无效");
//            [SVProgressHUD showInfoWithStatus:@"邀请码无效"];
            break;
        case 30:
            ShowError(@"当前直播未开始");
//            [SVProgressHUD showInfoWithStatus:@"当前直播未开始"];
            [vc.navigationController popViewControllerAnimated:YES];

            break;
        case 500:
            ShowError(@"服务器忙");
//            [SVProgressHUD showInfoWithStatus:@"服务器忙"];
            break;
        case 501:
            ShowError(@"参数错误");
//            [SVProgressHUD showInfoWithStatus:@"参数错误"];
            break;
    }
}

@end
