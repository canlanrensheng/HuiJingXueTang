//
//  HJSchoolLiveDetailViewModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/20.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseTableViewModel.h"
#import "HJLiveDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HJSchoolLiveDetailViewModel : BaseTableViewModel

//聊天的列表的数据源
@property (nonatomic,strong) NSMutableArray *chatListArray;

//获取直播详情的数据
@property (nonatomic,strong) HJLiveDetailModel *model;

@property (nonatomic,copy) NSString *liveId;
@property (nonatomic,copy) NSString *teacherId;

//获取直播详情的错误代码
@property (nonatomic,assign) NSInteger liveDetailErrorCode;
- (void)getLiveDetailDataWithLiveId:(NSString *)liveId  Success:(void (^)(NSInteger code))success;

//获取往期回顾的列表的数据
@property (nonatomic,strong) NSMutableArray *pastListArray;
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,assign) NSInteger totalpage;
@property (nonatomic,assign) NSInteger currentpage;
@property (nonatomic,assign) NSInteger page;

//是否是免费的
@property (nonatomic,assign) BOOL isFree;
//获取往期回顾的数据
- (void)getPastCourseListDataWithSuccess:(void (^)(void))success;

//关注老师的操作
- (void)careOrCancleCareWithTeacherId:(NSString *)teacherId
                          accessToken:(NSString *)accessToken
                            insterest:(NSString *)insterest
                              Success:(void (^)(void))success;

//播放的视频的链接
@property (nonatomic,copy) NSString *videoUrl;

@property (nonatomic,copy) NSString *courseid;

//是否显示流量弹窗
@property (nonatomic,assign) BOOL hasShowedTrafficMonitoringView;

@end

NS_ASSUME_NONNULL_END
