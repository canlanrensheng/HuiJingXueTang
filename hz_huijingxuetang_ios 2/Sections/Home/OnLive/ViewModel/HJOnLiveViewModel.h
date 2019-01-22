//
//  HJOnLiveViewModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2019/1/11.
//  Copyright © 2019年 Junier. All rights reserved.
//

#import "BaseTableViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJOnLiveViewModel : BaseTableViewModel
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,assign) NSInteger totalpage;
@property (nonatomic,assign) NSInteger currentpage;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray *liveListArray;
- (void)getSchoolLiveListDataWithSuccess:(void (^)(void))success;

@property (nonatomic,assign) BOOL isFirstLoad;

@end

NS_ASSUME_NONNULL_END
