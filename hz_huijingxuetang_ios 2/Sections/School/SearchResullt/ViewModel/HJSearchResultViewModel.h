//
//  HJSearchResultViewModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/16.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseTableViewModel.h"
#import "HJSearchResultModel.h"

typedef NS_ENUM(NSInteger,SearchResultType){
    SearchResultTypeAll = 1,
    SearchResultTypeCourse = 2,
    SearchResultTypeLive = 3
};

NS_ASSUME_NONNULL_BEGIN

@interface HJSearchResultViewModel : BaseTableViewModel

@property (nonatomic,copy) NSString *searchParam;

@property (nonatomic,strong) HJSearchResultModel *model;
//获取搜索结果接口
- (void)getSearchResultListDataWithSearchParam:(NSString *)searchParam success:(void (^)(void))success;

//搜索类型
@property (nonatomic,assign) SearchResultType searchResultType;

@property (nonatomic,assign) BOOL isEmptyData;


@property (nonatomic,assign) NSInteger totalpage;
@property (nonatomic,assign) NSInteger currentpage;

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,assign) NSInteger page;


//第一次加载更多课程的数据，添加加载动画
@property (nonatomic,assign) BOOL isFirstLoadCourseListData;
@property (nonatomic,strong) NSMutableArray *courseListArray;
//获取更多课程
- (void)getMoreCourseWithSuccess:(void (^)(BOOL successFlag))success;

//第一次加载更多老师的数据，添加加载动画
@property (nonatomic,assign) BOOL isFirstLoadTeacherListData;
@property (nonatomic,strong) NSMutableArray *teacherListArray;
//获取更多老师
- (void)getMoreTeacherWithSuccess:(void (^)(BOOL successFlag))success;

//获取更多资讯
//第一次加载更多资讯的数据，添加加载动画
@property (nonatomic,assign) BOOL isFirstLoadInfoListData;
@property (nonatomic,strong) NSMutableArray *infoListArray;
- (void)getMoreInfoWithSuccess:(void (^)(BOOL successFlag))success;

//获取更多直播列表
//第一次加载更多直播的数据，添加加载动画
@property (nonatomic,assign) BOOL isFirstLoadLiveListData;
@property (nonatomic,strong) NSMutableArray *liveListArray;
- (void)getMoreLiveWithSuccess:(void (^)(BOOL successFlag))success;

@end

NS_ASSUME_NONNULL_END
