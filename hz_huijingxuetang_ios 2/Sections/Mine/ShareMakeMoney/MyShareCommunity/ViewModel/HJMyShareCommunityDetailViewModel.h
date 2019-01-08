//
//  HJMyShareCommunityDetailViewModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/28.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseTableViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJMyShareCommunityDetailViewModel : BaseTableViewModel

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,assign) NSInteger totalpage;
@property (nonatomic,assign) NSInteger currentpage;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray *communityDetailDataArray;

@property (nonatomic,copy) NSString *dataParam;
@property (nonatomic,copy) NSString *datadaterange;

- (void)getCommunityDetailModelSuccess:(void (^)(void))success;
@property (nonatomic,assign) BOOL isFirstLoad;

@end

NS_ASSUME_NONNULL_END
