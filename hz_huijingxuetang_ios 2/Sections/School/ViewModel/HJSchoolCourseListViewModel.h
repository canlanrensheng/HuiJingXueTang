//
//  HJSchoolCourseListViewModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/14.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseTableViewModel.h"
#import "HJSchoolCourseListModel.h"



NS_ASSUME_NONNULL_BEGIN

@interface HJSchoolCourseListViewModel : BaseTableViewModel

@property (nonatomic,weak) UITableView *tableView;

//获取资讯的列表的数据
@property (nonatomic,assign) NSInteger totalpage;
@property (nonatomic,assign) NSInteger currentpage;

//价格排序（asc升序， desc降序）
@property (nonatomic,copy) NSString *sort_price;
//销量排序（asc升序， desc降序）
@property (nonatomic,copy) NSString *sort_sales;
//星级排序（asc升序， desc降序）
@property (nonatomic,copy) NSString *sort_starlevel;
//价格区间id
@property (nonatomic,copy) NSString *filter_price;
//是否现时特惠，非空:现时特惠；空：全部
@property (nonatomic,copy) NSString *filter_preference;
//请求页(默认：1)    
@property (nonatomic,assign) NSInteger page;

@property (nonatomic,strong) NSMutableArray *videoCourseListArray;
@property (nonatomic,strong) HJSchoolCourseListModel *model;
- (void)getListWithSuccess:(void (^)(void))success;

@property (nonatomic,assign) BOOL isFirstLoad;

@end

NS_ASSUME_NONNULL_END
