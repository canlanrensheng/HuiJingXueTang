//
//  HJDealNullTool.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/16.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJDealNullTool.h"

@implementation HJDealNullTool

//判断服务器返回的数据是否为空(nil,NULL等情况)
+ (BOOL)isNotNULL:(id)obj{
    return   NULL!=obj && nil!=obj && (NULL)!=obj && (Nil)!=obj  && [NSNull null]!=obj ?  YES: NO ;
}

@end
