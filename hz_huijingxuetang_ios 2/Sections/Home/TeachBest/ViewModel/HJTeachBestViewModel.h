//
//  HJTeachBestViewModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/13.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseTableViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJTeachBestViewModel : BaseTableViewModel

//获取资讯的列表的数据
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,assign) NSInteger totalpage;
@property (nonatomic,assign) NSInteger currentpage;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray *infoListArray;
- (void)getListWithSuccess:(void (^)(void))success;

@end

NS_ASSUME_NONNULL_END
