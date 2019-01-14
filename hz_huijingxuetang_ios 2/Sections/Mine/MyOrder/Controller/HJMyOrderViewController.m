//
//  HJMyOrderViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/21.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJMyOrderViewController.h"

#import "HJTopSementView.h"
#import "HJAllOrderViewController.h"
#import "HJKillPriceViewController.h"
#import "HJWaitPayViewController.h"
#import "HJFinishOrderViewController.h"
@interface HJMyOrderViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *controllersClass;
@property (nonatomic,assign) NSInteger  selectIndex;
@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) HJTopSementView *toolView;

@end

@implementation HJMyOrderViewController

- (UIBarButtonItem*)createBackButton{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, kHeight(30), kHeight(30));
    [backButton setImage:[UIImage imageNamed:@"导航返回按钮"] forState:UIControlStateNormal];
//    [backButton setImage:[UIImage imageNamed:@"导航返回按钮"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(popSelf) forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)popSelf {
    NSString *isFromOrderPay = self.params[@"isFromOrderPay"];
    if([isFromOrderPay boolValue]) {
        //来之订单支付的时候防止不断返回
        [DCURLRouter popToRootViewControllerAnimated:YES];
    } else {
        //从我的页面过来的时候直接返回到我的页面
        [DCURLRouter popViewControllerAnimated:YES];
    }
}


- (void)hj_setNavagation {
    self.title = @"我的订单";
    //工具条的按钮的操作
    __weak typeof(self)weakSelf = self;
    HJTopSementView *toolView = [[HJTopSementView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, kHeight(40)) titleColor:HEXColor(@"#333333") selectTitleColor:HEXColor(@"#22476B") lineColor:HEXColor(@"#22476B")  buttons:@[@"全部",@"砍价中",@"未付款",@"已完成"] block:^(NSInteger index) {
        weakSelf.selectIndex = index;
        [UIView animateWithDuration:0.25 animations:^{
            [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.selectIndex * Screen_Width, 0)];
        }];
        
    }];
    [self.view addSubview:toolView];
    self.toolView = toolView;
    
    //返回按钮的操作
    self.navigationItem.leftBarButtonItem = [self createBackButton];
}

- (void)hj_configSubViews {
    self.controllersClass = @[@"HJAllOrderViewController",@"HJKillPriceViewController",@"HJWaitPayViewController",@"HJFinishOrderViewController"];
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
            HJAllOrderViewController *listVC = [[HJAllOrderViewController alloc] init];
            listVC.view.frame = CGRectMake(index * Screen_Width, 0, Screen_Width, Screen_Height  - kNavigationBarHeight - kHeight(40));
            [self addChildViewController:listVC];
            [scrollView addSubview:listVC.view];
        } else if (index == 1) {
            HJKillPriceViewController *listVC = [[HJKillPriceViewController alloc] init];
            listVC.view.frame = CGRectMake(index * Screen_Width, 0, Screen_Width, Screen_Height  - kNavigationBarHeight - kHeight(40));
            [self addChildViewController:listVC];
            [scrollView addSubview:listVC.view];
        } else if (index == 2) {
            HJWaitPayViewController *listVC = [[HJWaitPayViewController alloc] init];
            listVC.view.frame = CGRectMake(index * Screen_Width, 0, Screen_Width, Screen_Height  - kNavigationBarHeight - kHeight(40));
            [self addChildViewController:listVC];
            [scrollView addSubview:listVC.view];
        } else {
            HJFinishOrderViewController *listVC = [[HJFinishOrderViewController alloc] init];
            listVC.view.frame = CGRectMake(index * Screen_Width, 0, Screen_Width, Screen_Height  - kNavigationBarHeight - kHeight(40));
            [self addChildViewController:listVC];
            [scrollView addSubview:listVC.view];
        }
    }
    
    //是否定位到砍价中的页面的操作
    NSString *isJumpTopKillPriceOrder = self.params[@"isJumpTopKillPriceOrder"];
    if(isJumpTopKillPriceOrder) {
        self.toolView.selectIndex = 1;
        self.selectIndex = 1;
        [UIView animateWithDuration:0.25 animations:^{
            [self.scrollView setContentOffset:CGPointMake(self.selectIndex * Screen_Width, 0)];
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = self.view.frame.size.width;
    CGFloat offsetX = scrollView.contentOffset.x;
    //获取索引
    NSInteger scrollIndex = offsetX / width;
    self.toolView.selectIndex = scrollIndex;
}


@end
