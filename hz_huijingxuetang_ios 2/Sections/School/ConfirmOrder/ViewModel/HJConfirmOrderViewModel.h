//
//  HJConfirmOrderViewModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/24.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseTableViewModel.h"
#import "HJConfirmOrderModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HJConfirmOrderViewModel : BaseTableViewModel

//获取购物车列表的数据
@property (nonatomic,strong) HJConfirmOrderModel *model;
@property (nonatomic,strong) NSMutableArray *orderListArray;
- (void)getConfirmOrderListDataWithOrderId:(NSString *)orderId Success:(void (^)(void))success;

@end

NS_ASSUME_NONNULL_END
