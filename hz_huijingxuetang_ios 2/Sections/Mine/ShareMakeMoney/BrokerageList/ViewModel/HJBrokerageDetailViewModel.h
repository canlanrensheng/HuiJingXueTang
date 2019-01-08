//
//  HJBrokerageDetailViewModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/3.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJBrokerageDetailViewModel : BaseViewModel

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,assign) NSInteger totalpage;
@property (nonatomic,assign) NSInteger currentpage;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray *brokerageDetailArray;

@property (nonatomic,copy) NSString *dataParam;
@property (nonatomic,copy) NSString *datadaterange;

//总的佣金
@property (nonatomic,assign) CGFloat commissionsum;
//总的成交金额
@property (nonatomic,assign) NSInteger ordersum;

- (void)getBrokerageDetailSuccess:(void (^)(void))success;

@end

NS_ASSUME_NONNULL_END
