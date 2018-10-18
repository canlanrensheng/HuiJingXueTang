//
//  orderModel.h
//  HuiJingSchool
//
//  Created by 陈燕军 on 2018/6/1.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface orderModel : NSObject
@property (nonatomic,copy) NSString *orderno;
@property (nonatomic,assign) NSNumber *paystatus;
@property (nonatomic,copy) NSString *createtime;
@property (nonatomic,copy) NSString *endpaytime;
@property (nonatomic,copy) NSString *paytime;
@property (nonatomic,copy) NSString *money;
@property (nonatomic,copy) NSString *coursepic;
@property (nonatomic,copy) NSString *coursename;
@property (nonatomic,copy) NSString *second;

- (instancetype)initWithModelDictionary:(NSDictionary *)dic;

@end
