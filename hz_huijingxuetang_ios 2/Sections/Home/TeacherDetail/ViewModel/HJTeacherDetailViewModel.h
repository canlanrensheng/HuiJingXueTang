//
//  HJTeacherDetailViewModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/15.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseTableViewModel.h"
#import "HJTeacherDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HJTeacherDetailViewModel : BaseTableViewModel

//获取老师详情
@property (nonatomic,strong) HJTeacherDetailModel *model;
@property (nonatomic,copy) NSString *teacherId;
- (void)getTeacherDetailWithTeacherId:(NSString *)teacherid Success:(void (^)(void))success;

//关注的操作
- (void)careOrCancleCareWithTeacherId:(NSString *)teacherId
                          accessToken:(NSString *)accessToken
                            insterest:(NSString *)insterest
                              Success:(void (^)(void))success;

//获取老师课程列表
@property (nonatomic,assign) NSInteger totalpage;
@property (nonatomic,assign) NSInteger currentpage;
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,assign) NSInteger page;
//推荐老师列表
- (void)getTeachercCourseListWithTeacherid:(NSString *)teacherid  Success:(void (^)(void))success;

@property (nonatomic,strong) NSMutableArray *teachercCourseArray;

//获取老师资讯列表
@property (nonatomic,strong) NSMutableArray *teacherInfoArray;
- (void)getTeachercInfoListWithTeacherid:(NSString *)teacherid  Success:(void (^)(void))success;

//获取直播列表
@property (nonatomic,strong) NSMutableArray *liveListArray;
- (void)getTeachercLiveListWithTeacherid:(NSString *)teacherid  Success:(void (^)(void))success;

@end

NS_ASSUME_NONNULL_END
