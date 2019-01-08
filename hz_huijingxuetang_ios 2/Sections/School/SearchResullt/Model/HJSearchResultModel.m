//
//  HJSearchResultModel.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/16.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSearchResultModel.h"

@implementation HJSearchResultModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"courseResponses" : @"CourseResponses",
             @"informationResponses" : @"InformationResponses",
             @"teacherResponses" : @"TeacherResponses",
             @"courseLiveResponses" : @"CourseLiveModel"
             };
}

@end

@implementation CourseLiveModel


@end

@implementation CourseResponses

@end

@implementation InformationResponses

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"informationId":@"id"
             };
}

@end

@implementation TeacherResponses

@end

