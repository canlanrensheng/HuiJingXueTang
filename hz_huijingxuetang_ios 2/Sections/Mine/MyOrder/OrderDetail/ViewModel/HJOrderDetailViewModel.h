//
//  HJOrderDetailViewModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/10.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseTableViewModel.h"

#import "HJMyOrderListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HJOrderDetailViewModel : BaseTableViewModel

@property (nonatomic,strong) HJMyOrderListModel *model;
- (void)getOrderDetailWithOrderId:(NSString *)orderId success:(void (^)(BOOL successFlag))success;

//删除订单的操作
- (void)deleteOrderWithOrderId:(NSString *)orderId success:(void (^)(void))success;

@end

NS_ASSUME_NONNULL_END
