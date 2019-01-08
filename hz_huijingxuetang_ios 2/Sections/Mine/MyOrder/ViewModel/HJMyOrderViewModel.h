//
//  HJMyOrderViewModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/7.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseTableViewModel.h"

typedef NS_ENUM(NSInteger,MyOrderType){
    MyOrderTypeWaitPay = 0, //待支付
    MyOrderTypePayed = 1, //已支付
    MyOrderTypeKillPriceing = 2, //砍价中
    MyOrderTypeAll = 3, //全部订单
};

NS_ASSUME_NONNULL_BEGIN

@interface HJMyOrderViewModel : BaseTableViewModel

@property (nonatomic,assign) MyOrderType orderType;

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,assign) NSInteger totalpage;
@property (nonatomic,assign) NSInteger currentpage;
@property (nonatomic,assign) NSInteger page;

//订单列表的数据
@property (nonatomic,strong) NSMutableArray *orderListArray;
- (void)getOrderListWithType:(NSInteger)type success:(void (^)(void))success;

//删除订单的操作
- (void)deleteOrderWithOrderId:(NSString *)orderId success:(void (^)(void))success;

//全部订单列表第一次加载数据
@property (nonatomic,assign) BOOL isAllOrderListFirstLoad;

@end

NS_ASSUME_NONNULL_END
