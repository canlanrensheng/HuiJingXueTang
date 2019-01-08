//
//  HJSchoolCourseListModel.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/14.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSchoolCourseListModel.h"

@implementation HJSchoolCourseListModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"price" : @"Price",
             @"courselist" : @"Courselist"
             };
}


@end

@implementation Price

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"priceId":@"id"
             };
}

@end

@implementation Courselist

@end
