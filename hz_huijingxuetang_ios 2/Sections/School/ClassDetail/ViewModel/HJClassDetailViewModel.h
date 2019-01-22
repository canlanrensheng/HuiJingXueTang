//
//  HJClassDetailViewModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/14.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseTableViewModel.h"
#import "HJSchoolCourseDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HJClassDetailViewModel : BaseTableViewModel

//获取课程详情的数据
@property (nonatomic,copy) NSString *courseId;

@property (nonatomic,strong) HJSchoolCourseDetailModel *model;
- (void)getCourceDetailWithCourseid:(NSString *)courseid Success:(void (^)(BOOL successFlag))success;

//课程选集
@property (nonatomic,strong) NSMutableArray *selectJiArray;
- (void)getCourceSelectJiWithCourseid:(NSString *)courseid Success:(void (^)(void))success;

//获取评论数据
@property (nonatomic,strong) NSMutableArray *commentArray;

//获取资讯的列表的数据
@property (nonatomic,assign) NSInteger totalpage;
@property (nonatomic,assign) NSInteger currentpage;

@property (nonatomic,assign) NSInteger totalcount;
@property (nonatomic,copy) NSString *starlevel;
//是否已经评论
@property (nonatomic,copy) NSString *commentcount;


@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,assign) NSInteger page;
//获取播放列表
- (void)getCourceCommentWithCourseid:(NSString *)courseid Success:(void (^)(void))success;

//播放量加1
- (void)addCourseCommentCountWithVideoId:(NSString *)videoId Success:(void (^)(void))success;

//加入购物车操作
- (void)addShopListOperationWithCourseId:(NSString *)courseId Success:(void (^)(void))success;

//生成免费的订单
- (void)createFreeCourseOrderWithCourseId:(NSString *)courseId Success:(void (^)(BOOL succcessFlag))success;

//是否已经展示了流量的弹窗
@property (nonatomic,assign) BOOL hasShowedTrafficMonitoringView;

@property (nonatomic,copy) NSString *selectCourseId;


@end

NS_ASSUME_NONNULL_END
