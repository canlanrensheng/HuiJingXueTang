//
//  HJShopCarViewModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/23.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseTableViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJShopCarViewModel : BaseTableViewModel

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,assign) NSInteger totalpage;
@property (nonatomic,assign) NSInteger currentpage;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray *shopCarListArray;

//合计的金额
@property (nonatomic,assign) CGFloat totalMoney;
//获取购物车列表的数据
- (void)getShopCarListDataWithSuccess:(void (^)(void))success;
//创建待支付订单
- (void)createWaitPayOrderWithCids:(NSString *)cids Success:(void (^)(void))success;
//删除购物车数据
- (void)deleteShopListWithCourseid:(NSString *)courseId Success:(void (^)(void))success;

//是否是第一次加载
@property (nonatomic,assign) BOOL isFirstLoad;

@end

NS_ASSUME_NONNULL_END
