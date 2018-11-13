//
//  HomePageViewController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/1/15.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HomePageViewController.h"
#import "HJHomeHeaderView.h"
#import "HJHomeViewModel.h"
#import "HJHomeLimitKillView.h"
#import "HJHomeLiveOnlineView.h"
#import "HJHomeExclusiveInfoView.h"
#import "HJHomeStuntJudgeStockView.h"
#import "HJHomeTeacherRecommendedView.h"
#import "HJHomeCourseRecommendedView.h"
#import "HJHomeLatestSatausView.h"

#import <MJRefresh.h>

@interface HomePageViewController ()


//慧鲸头试图
@property (nonatomic,strong) UIScrollView *backgroundScrollView;
//轮播图
@property (nonatomic,strong) HJHomeHeaderView *homeHeaderView;

//最新的动态
@property (nonatomic,strong) HJHomeLatestSatausView *latestSatausView;
//限时特惠
@property (nonatomic,strong) HJHomeLimitKillView *limitKillView;
//正在直播
@property (nonatomic,strong) HJHomeLiveOnlineView *liveOnlineView;

//绝技诊断股
@property (nonatomic,strong) HJHomeStuntJudgeStockView *stuntJudgeStockView;

//独家资讯
@property (nonatomic,strong) HJHomeExclusiveInfoView *exclusiveInfoView;
//名师推荐
@property (nonatomic,strong) HJHomeTeacherRecommendedView *teacherRecommendedView;
//课程推荐
@property (nonatomic,strong) HJHomeCourseRecommendedView *courseRecommendedView;
//我是有底线的
@property (nonatomic,strong) UILabel *noDataLabel;

@property (nonatomic,strong) HJHomeViewModel *viewModel;

@end

@implementation HomePageViewController

- (HJHomeHeaderView *)homeHeaderView {
    if(!_homeHeaderView){
        _homeHeaderView = [[HJHomeHeaderView alloc] init];
    }
    return _homeHeaderView;
}

//最新动态
- (HJHomeLatestSatausView *)latestSatausView {
    if(!_latestSatausView){
        _latestSatausView = [[HJHomeLatestSatausView alloc] init];
    }
    return _latestSatausView;
}


- (HJHomeLimitKillView *)limitKillView {
    if(!_limitKillView){
        _limitKillView = [[HJHomeLimitKillView alloc] init];
    }
    return _limitKillView;
}

- (HJHomeLiveOnlineView *)liveOnlineView {
    if(!_liveOnlineView){
        _liveOnlineView = [[HJHomeLiveOnlineView alloc] init];
    }
    return _liveOnlineView;
}

//独家资讯
- (HJHomeExclusiveInfoView *)exclusiveInfoView {
    if(!_exclusiveInfoView){
        _exclusiveInfoView = [[HJHomeExclusiveInfoView alloc] init];
    }
    return _exclusiveInfoView;
}

//绝技诊股
- (HJHomeStuntJudgeStockView *)stuntJudgeStockView {
    if(!_stuntJudgeStockView){
        _stuntJudgeStockView = [[HJHomeStuntJudgeStockView alloc] init];
    }
    return _stuntJudgeStockView;
}

//名师推荐
- (HJHomeTeacherRecommendedView *)teacherRecommendedView {
    if(!_teacherRecommendedView){
        _teacherRecommendedView = [[HJHomeTeacherRecommendedView alloc] init];
    }
    return  _teacherRecommendedView;
}

//课程推荐
- (HJHomeCourseRecommendedView *)courseRecommendedView {
    if(!_courseRecommendedView){
        _courseRecommendedView = [[HJHomeCourseRecommendedView alloc] init];
    }
    return _courseRecommendedView;
}

- (HJHomeViewModel *)viewModel {
    if(!_viewModel){
        _viewModel = [[HJHomeViewModel alloc] init];
    }
    return _viewModel;
}

- (void)hj_setNavagation {
     self.title = @"慧鲸学堂";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:nil image:V_IMAGE(@"搜索ICON") action:^(id sender) {
        [DCURLRouter pushURLString:@"route://searchResultVC" animated:YES];
    }];
}

- (void)hj_configSubViews {
    //背景视图
    UIScrollView *backGroundScrollView = [[UIScrollView alloc]init];
    backGroundScrollView.scrollEnabled = YES;
    backGroundScrollView.contentSize = CGSizeMake(Screen_Width, Screen_Height * 4);
    backGroundScrollView.showsVerticalScrollIndicator = NO;
    backGroundScrollView.showsHorizontalScrollIndicator = NO;
    backGroundScrollView.backgroundColor = ALLViewBgColor;
    backGroundScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(hj_loadData)];
    [self.view addSubview:backGroundScrollView];
    self.backgroundScrollView = backGroundScrollView;
    
    [backGroundScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    //轮播图和4个item
    self.homeHeaderView.frame = CGRectMake(0, 0, Screen_Width, kHeight(185.0 + 100));
    [backGroundScrollView addSubview:self.homeHeaderView];
    
    //最新的动态
    self.latestSatausView.frame = CGRectMake(0, CGRectGetMaxY(self.homeHeaderView.frame), Screen_Width, kHeight(62.0));
    [backGroundScrollView addSubview:self.latestSatausView];
    
    //限时特惠
    self.limitKillView.frame = CGRectMake(0, CGRectGetMaxY(self.latestSatausView.frame), Screen_Width, kHeight(267.0));
    [backGroundScrollView addSubview:self.limitKillView];
    
    //正在直播
    self.liveOnlineView.frame = CGRectMake(0, CGRectGetMaxY(self.limitKillView.frame), Screen_Width, kHeight(219.0 + 3.0));
    [backGroundScrollView addSubview:self.liveOnlineView];


    //独家资讯
    self.exclusiveInfoView.frame = CGRectMake(0, CGRectGetMaxY(self.liveOnlineView.frame), Screen_Width, kHeight(289 + 25));
    [backGroundScrollView addSubview:self.exclusiveInfoView];
    
    //绝技诊股
    self.stuntJudgeStockView.frame = CGRectMake(0, CGRectGetMaxY(self.exclusiveInfoView.frame), Screen_Width, kHeight(335 + 5.0));
    [backGroundScrollView addSubview:self.stuntJudgeStockView];
    
    //名师推荐
    self.teacherRecommendedView.frame = CGRectMake(0, CGRectGetMaxY(self.stuntJudgeStockView.frame), Screen_Width, kHeight(205));
    [backGroundScrollView addSubview:self.teacherRecommendedView];
    
    //课程推荐
    self.courseRecommendedView.frame = CGRectMake(0, CGRectGetMaxY(self.teacherRecommendedView.frame), Screen_Width, kHeight(84));
    [backGroundScrollView addSubview:self.courseRecommendedView];
    
    
    //我是有底线的
    UILabel *noDataLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"我是有底线的！",MediumFont(font(11)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentCenter;
        [label sizeToFit];
    }];
    self.noDataLabel = noDataLabel;
    noDataLabel.frame = CGRectMake(0, CGRectGetMaxY(self.courseRecommendedView.frame), Screen_Width, kHeight(31.0));
    [backGroundScrollView addSubview:noDataLabel];
    
//    backGroundScrollView.contentSize = CGSizeMake(Screen_Width, CGRectGetMaxY([[backGroundScrollView.subviews lastObject] frame]));
    
}

- (void)hj_loadData {
    [self.backgroundScrollView.mj_header endRefreshing];
    [self.backgroundScrollView.mj_footer resetNoMoreData];
    
    //获取首页轮播图
    [YJAPPNetwork getAdSuccess:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            NSMutableArray *urlArr = [NSMutableArray array];
            self.viewModel.cycleScrollViewDataArray = [NSMutableArray array];
            for (NSDictionary *dic in responseObject[@"data"]) {
                NSString *url = dic[@"picurl"];
                [urlArr addObject:url];
                [self.viewModel.cycleScrollViewDataArray addObject:dic];
            }
            self.viewModel.headerDataArray = urlArr;
            [self.homeHeaderView setViewModel:self.viewModel];
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        ShowError(netError);
    }];
    
//    //加载最新的动态
//    [YJAPPNetwork HomeViewNewsuccess:^(NSDictionary *responseObject) {
//        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
//        if (code == 200) {
//
//        }else{
//            [ConventionJudge NetCode:code vc:self type:@"1"];
//        }
//    } failure:^(NSString *error) {
//        ShowError(netError);
//    }];
    
    //加载课程列表
    [self.viewModel HomeRecommongCourceWithType:@"" success:^{
        self.courseRecommendedView.frame = CGRectMake(0, CGRectGetMaxY(self.teacherRecommendedView.frame), Screen_Width, kHeight(self.viewModel.recommongCourceDataArray.count * 100 + 84));
        self.noDataLabel.frame = CGRectMake(0, CGRectGetMaxY(self.courseRecommendedView.frame), Screen_Width, kHeight(31.0));
        self.backgroundScrollView.contentSize = CGSizeMake(Screen_Width, CGRectGetMaxY([[self.backgroundScrollView.subviews lastObject] frame]));
        [self.courseRecommendedView setViewModel:self.viewModel];
    }];
    
    //加载绝技诊股
    [self.viewModel stuntJudgeStockWithType:@"1" page:@"1" success:^{
        [self.stuntJudgeStockView setViewModel:self.viewModel];
    }];
    
    //获取推荐老师
    [self.viewModel recommentTeacherWithPage:@"1" success:^{
        [self.teacherRecommendedView setViewModel:self.viewModel];
    }];
}





@end
