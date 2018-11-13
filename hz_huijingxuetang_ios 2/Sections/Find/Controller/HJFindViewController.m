//
//  HJFindViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/30.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJFindViewController.h"
#import "HJFindRecommondViewController.h"
#import "HJFindCareViewController.h"

#import "HJFindSegmentView.h"
@interface HJFindViewController ()

@property (nonatomic, strong) NSArray *controllersClass;
@property (nonatomic,assign) NSInteger  selectIndex;
@property (nonatomic,strong) UIScrollView *scrollView;



@end

@implementation HJFindViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CGFLOAT_MIN * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
}


- (void)hj_setNavagation {
    //自制导航条
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, kNavigationBarHeight)];
    navView.backgroundColor = NavAndBtnColor;
    [self.view addSubview:navView];
    //工具条的按钮的操作
    HJFindSegmentView *toolView = [[HJFindSegmentView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, Screen_Width, kHeight(44))];
    [navView addSubview:toolView];
    @weakify(self);
    [toolView.clickSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        //刷新数据
        self.selectIndex = [x integerValue];
        [self.scrollView setContentOffset:CGPointMake(self.selectIndex * Screen_Width, 0)];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshFindData" object:nil userInfo:@{@"index" :@(self.selectIndex)}];
    }];

}

- (void)hj_configSubViews {
    self.controllersClass = @[@"HJFindRecommondViewController",@"HJFindCareViewController"];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, Screen_Width, Screen_Height - kNavigationBarHeight - kBottomBarHeight)];
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(Screen_Width * self.controllersClass.count,  Screen_Height - kNavigationBarHeight - kBottomBarHeight);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = NO;
    scrollView.bounces = NO;
    
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    for (int index = 0; index < self.controllersClass.count; index++) {
        if(index == 0) {
            HJFindRecommondViewController *listVC = [[HJFindRecommondViewController alloc] init];
            listVC.view.frame = CGRectMake(0, 0, Screen_Width, Screen_Height  - kNavigationBarHeight - kBottomBarHeight);
            [self addChildViewController:listVC];
            [scrollView addSubview:listVC.view];
        }  else if (index == 1){
            HJFindCareViewController *listVC = [[HJFindCareViewController alloc] init];
            listVC.view.frame = CGRectMake(Screen_Width * 1, 0, Screen_Width, Screen_Height - kNavigationBarHeight - kBottomBarHeight);
            [self addChildViewController:listVC];
            [scrollView addSubview:listVC.view];
        }
    }
}


@end
