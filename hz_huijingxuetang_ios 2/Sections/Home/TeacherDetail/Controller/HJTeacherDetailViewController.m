//
//  HJTeacherDetailViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/5.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJTeacherDetailViewController.h"
#import "HJTeacherDetailHeaderView.h"
#import "HJTeacherDetailSementView.h"

#import "HJTeacherDetailDynamicViewController.h"
#import "HJTeacherDetailCourceViewController.h"
#import "HJTeacherDetailLiveViewController.h"
#import "HJTeacherDetailActicleViewController.h"

@interface HJTeacherDetailViewController ()

@property (nonatomic,strong) HJTeacherDetailHeaderView *headerView;
@property (nonatomic,strong) HJTeacherDetailSementView *sementView;

@property (nonatomic, strong) NSArray *controllersClass;
@property (nonatomic,assign) NSInteger  selectIndex;
@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation HJTeacherDetailViewController

- (HJTeacherDetailHeaderView *)headerView {
    if(!_headerView){
        _headerView = [[HJTeacherDetailHeaderView alloc] init];
    }
    return _headerView;
}

- (void)hj_configSubViews {
    //顶部试图
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(kHeight(211));
    }];
    
    //插板
    HJTeacherDetailSementView *toolView = [[HJTeacherDetailSementView alloc] init];
    [self.view addSubview:toolView];
    [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(kHeight(40));
        make.top.equalTo(self.headerView.mas_bottom);
    }];
    self.sementView = toolView;

    @weakify(self);
    [toolView.clickSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        //刷新数据
        self.selectIndex = [x integerValue];
        [self.scrollView setContentOffset:CGPointMake(self.selectIndex * Screen_Width, 0)];
    }];

    //创建控制器容器
    self.controllersClass = @[@"HJTeacherDetailDynamicViewController",@"HJTeacherDetailCourceViewController",@"HJTeacherDetailLiveViewController",@"HJTeacherDetailActicleViewController"];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kHeight(40) + kHeight(211), Screen_Width, Screen_Height - kHeight(40) - kHeight(211))];
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(Screen_Width * self.controllersClass.count,  Screen_Height - kHeight(40));
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = NO;
    scrollView.bounces = NO;

    [self.view addSubview:scrollView];
    self.scrollView = scrollView;

    for (int index = 0; index < self.controllersClass.count; index++) {
        if(index == 0) {
            HJTeacherDetailDynamicViewController *vc = [[HJTeacherDetailDynamicViewController alloc] init];
            vc.view.frame = CGRectMake(0, 0, Screen_Width, Screen_Height - kHeight(40) - kHeight(211) - kNavigationBarHeight);
            [self addChildViewController:vc];
            [scrollView addSubview:vc.view];
        }  else if (index == 1){
            HJTeacherDetailCourceViewController *vc = [[HJTeacherDetailCourceViewController alloc] init];
            vc.view.frame = CGRectMake(Screen_Width * 1, 0, Screen_Width, Screen_Height - kHeight(40) - kHeight(211) - kNavigationBarHeight);
            [self addChildViewController:vc];
            [scrollView addSubview:vc.view];
        }  else if (index == 2){
            HJTeacherDetailLiveViewController *vc = [[HJTeacherDetailLiveViewController alloc] init];
            vc.view.frame = CGRectMake(Screen_Width * 2, 0, Screen_Width , Screen_Height - kHeight(40) - kHeight(211) - kNavigationBarHeight);
            [self addChildViewController:vc];
            [scrollView addSubview:vc.view];
        } else {
            HJTeacherDetailActicleViewController *vc = [[HJTeacherDetailActicleViewController alloc] init];
            vc.view.frame = CGRectMake(Screen_Width * 3, 0, Screen_Width, Screen_Height - kHeight(40) - kHeight(211) - kNavigationBarHeight);
            [self addChildViewController:vc];
            [scrollView addSubview:vc.view];
        }
    }
}

@end
