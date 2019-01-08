//
//  HJRiskEvaluationModel.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/27.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJRiskEvaluationModel.h"

@implementation Answer

@end

@implementation Question

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"answer" : @"Answer"
             };
}


@end

@implementation HJRiskEvaluationModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"question" : @"Question"
             };
}


@end



