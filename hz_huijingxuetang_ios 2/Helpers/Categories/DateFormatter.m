//
//  TimeFormatter.m
//  Zhuan
//
//  Created by txooo on 16/5/23.
//  Copyright © 2016年 黄宜波. All rights reserved.
//

#import "DateFormatter.h"
#import "NSDate+Estension.h"

@implementation DateFormatter
+ (NSString *)getDateWithDateStr:(NSString *)date format:(NSString *)format {
    if (date.length > 0 && (![date isEqualToString:@"null"]) && (![date isEqualToString:@"<null>"])) {
        
        NSArray * firstArr = [date componentsSeparatedByString:@" "];
        NSString * firstStr = [firstArr firstObject];
        NSArray * secondArr = [firstStr componentsSeparatedByString:@"/"];
        date = [NSString stringWithFormat:@"%@-%@-%@ %@",[secondArr lastObject],[secondArr firstObject],secondArr[1],[firstArr lastObject]];
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        [fmt setTimeZone:[NSTimeZone localTimeZone]];
        NSDate *tmpDate = [fmt dateFromString:date];
        fmt.dateFormat = format;
        NSString *newTime = [fmt stringFromDate:tmpDate];
        return newTime;
    }
    return @"";
}

/// 消息时间转换
+ (NSString *)getMessageDate:(NSString *)date {
    //date = [NSString stringWithFormat:@"%@",date];
    if (date.length > 0 && (![date isEqualToString:@"null"]) && (![date isEqualToString:@"<null>"])) {
        
        NSArray * firstArr = [date componentsSeparatedByString:@" "];
        NSString * firstStr = [firstArr firstObject];
        NSArray * secondArr = [firstStr componentsSeparatedByString:@"/"];
        date = [NSString stringWithFormat:@"%@-%@-%@ %@",[secondArr lastObject],[secondArr firstObject],secondArr[1],[firstArr lastObject]];
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        [fmt setTimeZone:[NSTimeZone localTimeZone]];
        NSDate *createDate = [fmt dateFromString:date];
        NSString *timeStr;
        if (createDate.isThisYear) {
            if (createDate.isToday) { // 今天
                fmt.dateFormat = @"HH:mm:ss";
                timeStr = [fmt stringFromDate:createDate];
            } else if (createDate.isYesterday) { // 昨天
                fmt.dateFormat = @"昨天 HH:mm:ss";
                timeStr = [fmt stringFromDate:createDate];
            } else if (createDate.isBeforeYesterday){ //前天
                fmt.dateFormat = @"前天 HH:mm:ss";
                timeStr = [fmt stringFromDate:createDate];
            } else{
                //fmt.dateFormat = @"MM-dd HH:mm";
                fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                timeStr = [fmt stringFromDate:createDate];
            }
        } else { // 非今年
            fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            timeStr = [fmt stringFromDate:createDate];
        }
        return timeStr;
    }
    return @"";
}

//时间转换
+ (NSString *)getDate:(NSString *)date {
    if (date.length > 0 && (![date isEqualToString:@"null"]) && (![date isEqualToString:@"<null>"])) {
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        [fmt setTimeZone:[NSTimeZone localTimeZone]];
        NSDate *createDate = [fmt dateFromString:date];
        NSString *timeStr;
        if (createDate.isThisYear) {
            if (createDate.isToday) { // 今天
                NSDateComponents *cmps = [createDate deltaWithNow];
                if (cmps.hour >= 1) { // 至少是1小时前发的
                    timeStr =  [NSString stringWithFormat:@"%ld小时前", (long)cmps.hour];
                } else if (cmps.minute >= 1) { // 1~59分钟之前发的
                    timeStr = [NSString stringWithFormat:@"%ld分钟前", (long)cmps.minute];
                } else { // 1分钟内发的
                    timeStr = @"刚刚";
                }
            } else if (createDate.isYesterday) { // 昨天
                fmt.dateFormat = @"昨天 HH:mm";
                timeStr = [fmt stringFromDate:createDate];
            } else if (createDate.isBeforeYesterday){ //前天
                fmt.dateFormat = @"前天 HH:mm";
                timeStr = [fmt stringFromDate:createDate];
            } else if (createDate.isBeforeYesterdayBefore){ //3天
                fmt.dateFormat = @"3天前 HH:mm";
                timeStr = [fmt stringFromDate:createDate];
            }else{
                //fmt.dateFormat = @"MM-dd HH:mm";
                fmt.dateFormat = @"yyyy-MM-dd";
                timeStr = [fmt stringFromDate:createDate];
            }
        } else { // 非今年
            fmt.dateFormat = @"yyyy-MM-dd";
            timeStr = [fmt stringFromDate:createDate];
        }
        return timeStr;
    }
    return @"";
    
}

+ (NSString *)getDateByMDY:(NSString *)date{
    if (date) {
        NSArray *tmpArray = [date componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/ "]];
        if (tmpArray.count >= 4) {
            date = [NSString stringWithFormat:@"%@-%@-%@ %@",tmpArray[2],tmpArray[0],tmpArray[1],tmpArray[3]];
        }else{
            return @"未知时间";
        }
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        [fmt setTimeZone:[NSTimeZone localTimeZone]];
        NSDate *createDate = [fmt dateFromString:date];
        NSString *timeStr;
        if (createDate.isThisYear) {
            if (createDate.isToday) { // 今天
                NSDateComponents *cmps = [createDate deltaWithNow];
                if (cmps.hour >= 1) { // 至少是1小时前发的
                    timeStr =  [NSString stringWithFormat:@"%ld小时前", (long)cmps.hour];
                } else if (cmps.minute >= 1) { // 1~59分钟之前发的
                    timeStr = [NSString stringWithFormat:@"%ld分钟前", (long)cmps.minute];
                } else { // 1分钟内发的
                    timeStr = @"刚刚";
                }
            } else if (createDate.isYesterday) { // 昨天
                fmt.dateFormat = @"昨天 HH:mm";
                timeStr = [fmt stringFromDate:createDate];
            } else if (createDate.isBeforeYesterday){ //前天
                fmt.dateFormat = @"前天 HH:mm";
                timeStr = [fmt stringFromDate:createDate];
            } else if (createDate.isBeforeYesterdayBefore){ //3天
                fmt.dateFormat = @"3天前 HH:mm";
                timeStr = [fmt stringFromDate:createDate];
            }else{
                //                fmt.dateFormat = @"MM-dd HH:mm";
                fmt.dateFormat = @"yyyy-MM-dd";
                timeStr = [fmt stringFromDate:createDate];
            }
        } else { // 非今年
            fmt.dateFormat = @"yyyy-MM-dd";
            timeStr = [fmt stringFromDate:createDate];
        }
        return timeStr;
    }
    return @"";
}

+ (NSString *)getChineseDate:(NSString *)date{
    if (date) {
        NSArray * firstArr = [date componentsSeparatedByString:@" "];
        NSString * firstStr = [firstArr firstObject];
        NSArray * secondArr = [firstStr componentsSeparatedByString:@"/"];
        return [NSString stringWithFormat:@"%@年%@月%@日",[secondArr lastObject],[secondArr firstObject],secondArr[1]];;
    }
    return @"";
}

-(NSString *)timeStrComform:(NSString *)timeStr{
    NSArray * firstArr = [timeStr componentsSeparatedByString:@" "];
    NSString * firstStr = [firstArr firstObject];
    NSArray * secondArr = [firstStr componentsSeparatedByString:@"/"];
    return [NSString stringWithFormat:@"%@/%@/%@",[secondArr lastObject],[secondArr firstObject],secondArr[1]];;
}

+ (NSString *)getNewDate:(NSString *)date
{
    if (date) {
        for (int i = 0; i<[date length]; i++) {
            //截取字符串中的每一个字符
            NSString *s = [date substringWithRange:NSMakeRange(i, 1)];
            if ([s isEqualToString:@"/"]) {
                NSRange range = NSMakeRange(i, 1);
                //将字符串中的“m”转化为“w”
                date = [date stringByReplacingCharactersInRange:range withString:@"-"];
            }
        }
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        [fmt setTimeZone:[NSTimeZone localTimeZone]];
        NSDate *createDate = [fmt dateFromString:date];
        NSString *timeStr;
        if (createDate.isThisYear) {
            if (createDate.isToday) { // 今天
                NSDateComponents *cmps = [createDate deltaWithNow];
                if (cmps.hour >= 1) { // 至少是1小时前发的
                    timeStr =  [NSString stringWithFormat:@"%ld小时前", (long)cmps.hour];
                } else if (cmps.minute >= 1) { // 1~59分钟之前发的
                    timeStr = [NSString stringWithFormat:@"%ld分钟前", (long)cmps.minute];
                } else { // 1分钟内发的
                    timeStr = @"刚刚";
                }
            } else if (createDate.isYesterday) { // 昨天
                fmt.dateFormat = @"昨天 HH:mm";
                timeStr = [fmt stringFromDate:createDate];
            } else if (createDate.isBeforeYesterday){ //前天
                fmt.dateFormat = @"前天 HH:mm";
                timeStr = [fmt stringFromDate:createDate];
            } else if (createDate.isBeforeYesterdayBefore){ //3天
                fmt.dateFormat = @"3天前 HH:mm";
                timeStr = [fmt stringFromDate:createDate];
            }else{
                //fmt.dateFormat = @"MM-dd HH:mm";
                fmt.dateFormat = @"yyyy-MM-dd";
                timeStr = [fmt stringFromDate:createDate];
            }
        } else { // 非今年
            fmt.dateFormat = @"yyyy-MM-dd";
            timeStr = [fmt stringFromDate:createDate];
        }
        return timeStr;
    }
    return @"";
    
}



@end
