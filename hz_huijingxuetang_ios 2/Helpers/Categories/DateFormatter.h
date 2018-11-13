//
//  TimeFormatter.h
//  Zhuan
//
//  Created by txooo on 16/5/23.
//  Copyright © 2016年 黄宜波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DateFormatter.h"
@interface DateFormatter : NSObject
+ (NSString *)getDateWithDateStr:(NSString *)date format:(NSString *)format;
+ (NSString *)getMessageDate:(NSString *)date;
+ (NSString *)getDate:(NSString *)date;
+ (NSString *)getDateByMDY:(NSString *)date;
+ (NSString *)getChineseDate:(NSString *)date;
@end
