//
//  HJMyCourceViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/9.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJMyCourceViewController.h"
#import "HJTopSementView.h"
#import "HJBaseMyCourseViewController.h"
#import "HJWaitLiveViewController.h"
@interface HJMyCourceViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *controllersClass;
@property (nonatomic,assign) NSInteger  selectIndex;
@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) HJTopSementView *toolView;

@end

@implementation HJMyCourceViewController

- (void)hj_setNavagation {
    self.title = @"我的课程";
    //工具条的按钮的操作
    __weak typeof(self)weakSelf = self;
    HJTopSementView *toolView = [[HJTopSementView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, kHeight(40)) titleColor:HEXColor(@"#333333") selectTitleColor:HEXColor(@"#22476B") lineColor:HEXColor(@"#22476B")  buttons:@[@"已购课程",@"等待直播"] block:^(NSInteger index) {
        weakSelf.selectIndex = index;
        [UIView animateWithDuration:0.25 animations:^{
            [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.selectIndex * Screen_Width, 0)];
        }];
       
    }];
    [self.view addSubview:toolView];
   
    self.toolView = toolView;
}

- (void)hj_configSubViews {
    self.controllersClass = @[@"HJBaseMyCourseViewController",@"HJWaitLiveViewController"];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kHeight(40), Screen_Width, Screen_Height - kNavigationBarHeight - kHeight(40))];
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(Screen_Width * self.controllersClass.count,  Screen_Height - kNavigationBarHeight - kHeight(40));
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.delegate = self;
    scrollView.bounces = NO;
    
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    for (int index = 0; index < self.controllersClass.count; index++) {
        if(index == 0) {
            HJBaseMyCourseViewController *listVC = [[HJBaseMyCourseViewController alloc] init];
            listVC.view.frame = CGRectMake(0, 0, Screen_Width, Screen_Height  - kNavigationBarHeight - kHeight(40));
            [self addChildViewController:listVC];
            [scrollView addSubview:listVC.view];
        }  else if (index == 1){
            HJWaitLiveViewController *listVC = [[HJWaitLiveViewController alloc] init];
            listVC.view.frame = CGRectMake(Screen_Width * 1, 0, Screen_Width, Screen_Height - kNavigationBarHeight - kHeight(40));
            [self addChildViewController:listVC];
            [scrollView addSubview:listVC.view];
        }
    }
}

//左右滚动切换视图控制器
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = self.view.frame.size.width;
    CGFloat offsetX = scrollView.contentOffset.x;
    //获取索引
    NSInteger scrollIndex = offsetX / width;
    self.toolView.selectIndex = scrollIndex;
}

@end
