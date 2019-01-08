//
//  HJPayTool.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/10.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HJPayTypeAlert.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJPayTool : NSObject

+ (instancetype)shareInstance;

/*
 orderId 订单id
 couponid 优惠券id
 */
- (void)payWithOrderId:(NSString *)orderId couponid:(NSString *)couponid ;

//支付类型的弹窗
@property (nonatomic,strong) HJPayTypeAlert *payAlertView;

@end

NS_ASSUME_NONNULL_END
