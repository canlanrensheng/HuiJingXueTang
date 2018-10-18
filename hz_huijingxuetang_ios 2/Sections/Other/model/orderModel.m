
//
//  orderModel.m
//  HuiJingSchool
//
//  Created by 陈燕军 on 2018/6/1.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "orderModel.h"

@implementation orderModel
- (instancetype)initWithModelDictionary:(NSDictionary *)dic{
    self = [super init];
    
    if (self)
    {
        self.orderno = dic[@"orderno"];
        self.paystatus = dic[@"paystatus"];
        self.createtime = dic[@"createtime"];
        self.endpaytime = dic[@"endpaytime"];
        self.paytime = dic[@"paytime"];
        self.money = dic[@"money"];
        self.coursepic = dic[@"coursepic"];
        self.coursename = dic[@"coursename"];
        self.second = dic[@"second"];

    }
    return self;
}

@end
