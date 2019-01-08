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
@interface HJFindViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *controllersClass;
@property (nonatomic,assign) NSInteger  selectIndex;
@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) HJFindRecommondViewController *findRecommondVC;
@property (nonatomic,strong) HJFindCareViewController *findCareVC;

@property (nonatomic,strong) HJFindSegmentView *toolView;

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
    __weak typeof(self)weakSelf = self;
    HJFindSegmentView *toolView = [[HJFindSegmentView alloc] initWithFrame:CGRectMake(0, navView.frame.size.height - kHeight(44), Screen_Width, kHeight(44)) titleColor:white_color selectTitleColor:white_color lineColor:HEXColor(@"#FAD466")  buttons:@[@"推荐",@"关注"] block:^(NSInteger index) {
        weakSelf.selectIndex = index;
        [UIView animateWithDuration:0.25 animations:^{
            [UIView animateWithDuration:0.25 animations:^{
                [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.selectIndex * Screen_Width, 0)];
            }];
        }];

    }];
    [navView addSubview:toolView];
    self.toolView = toolView;
}

- (void)hj_configSubViews {
    self.controllersClass = @[@"HJFindRecommondViewController",@"HJFindCareViewController"];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, Screen_Width, Screen_Height - kNavigationBarHeight - kBottomBarHeight)];
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(Screen_Width * self.controllersClass.count,  Screen_Height - kNavigationBarHeight - kBottomBarHeight);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.delegate = self;
    scrollView.bounces = NO;
    
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    for (int index = 0; index < self.controllersClass.count; index++) {
        if(index == 0) {
            HJFindRecommondViewController *listVC = [[HJFindRecommondViewController alloc] init];
            listVC.view.frame = CGRectMake(0, 0, Screen_Width, Screen_Height  - kNavigationBarHeight - kBottomBarHeight);
            [self addChildViewController:listVC];
            [scrollView addSubview:listVC.view];
            self.findRecommondVC = listVC;
        }  else if (index == 1){
            HJFindCareViewController *listVC = [[HJFindCareViewController alloc] init];
            listVC.view.frame = CGRectMake(Screen_Width * 1, 0, Screen_Width, Screen_Height - kNavigationBarHeight - kBottomBarHeight);
            [self addChildViewController:listVC];
            [scrollView addSubview:listVC.view];
            self.findCareVC = listVC;
        }
    }
}

//滚动切换控制器
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = self.view.frame.size.width;
    CGFloat offsetX = scrollView.contentOffset.x;
    //获取索引
    NSInteger scrollIndex = offsetX / width;
    self.toolView.selectIndex = scrollIndex;
}

@end
