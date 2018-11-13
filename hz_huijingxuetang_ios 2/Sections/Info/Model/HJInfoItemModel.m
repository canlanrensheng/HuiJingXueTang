//
//  HJInfoItemModel.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/9.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJInfoItemModel.h"

@implementation HJInfoItemModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"itemId":@"id"
             };
}

@end
