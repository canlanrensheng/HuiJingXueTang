//
//  HJLimitKillMoreViewModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/22.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseTableViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJLimitKillMoreViewModel : BaseTableViewModel

@property (nonatomic,assign) NSInteger totalpage;
@property (nonatomic,assign) NSInteger currentpage;
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,assign) NSInteger page;

- (void)getLimitKillMoreListDataSuccess:(void (^)(void))success;
@property (nonatomic,strong) NSMutableArray *limitKillMoreArray;

@end

NS_ASSUME_NONNULL_END
