//
//  HJShareViewModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/3.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseTableViewModel.h"
#import "HJCurrentMonthMessageModel.h"
#import "HJPromoteProfitModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HJShareViewModel : BaseTableViewModel

//获取当前社区的人数和当月的订单总数
@property (nonatomic,strong) HJCurrentMonthMessageModel *model;
- (void)getCurrentMonthMessageWithSuccess:(void (^)(void))success;

//获取推广课程列表
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,assign) NSInteger totalpage;
@property (nonatomic,assign) NSInteger currentpage;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray *courseListArray;
- (void)getShareCourceListSuccess:(void (^)(void))success;

//获取推广收益信息
@property (nonatomic,strong) HJPromoteProfitModel *profitModel;
- (void)getPromoteProfitMessageSuccess:(void (^)(void))success;

@end

NS_ASSUME_NONNULL_END
