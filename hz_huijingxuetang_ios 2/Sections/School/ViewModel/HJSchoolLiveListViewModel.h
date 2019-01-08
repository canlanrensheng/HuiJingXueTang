//
//  HJSchoolLiveListViewModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/24.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseTableViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJSchoolLiveListViewModel : BaseTableViewModel

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,assign) NSInteger totalpage;
@property (nonatomic,assign) NSInteger currentpage;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray *liveListArray;
//获取购物车列表的数据
- (void)getSchoolLiveListDataWithSuccess:(void (^)(void))success;

@end

NS_ASSUME_NONNULL_END
