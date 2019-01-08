//
//  HJExclusiveInfoModel.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/22.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJExclusiveInfoModel.h"

@implementation NewsList

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"des" : @"descrption",
             @"infoId" : @"id"
             };
}

@end


@implementation HJExclusiveInfoModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"newsList" : @"NewsList"
             };
}


@end
