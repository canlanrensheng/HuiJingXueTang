//
//  HJMyCardVoucherViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/9.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJMyCardVoucherViewController.h"
#import "HJTopSementView.h"
#import "HJValidMyCardVoucherViewController.h"
#import "HJUsedMyCardVoucherViewController.h"
#import "HJInValidMyCardVoucherViewController.h"
#import "HJMyCardVoucherViewModel.h"
@interface HJMyCardVoucherViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *controllersClass;
@property (nonatomic,assign) NSInteger  selectIndex;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) HJMyCardVoucherViewModel *viewModel;

@property (nonatomic,strong) HJValidMyCardVoucherViewController *validMyCardVoucherVC;
@property (nonatomic,strong) HJUsedMyCardVoucherViewController *usedMyCardVoucherVC;
@property (nonatomic,strong) HJInValidMyCardVoucherViewController *inValidMyCardVoucherVC;

@property (nonatomic,strong) HJTopSementView *toolView;

@end

@implementation HJMyCardVoucherViewController

- (HJMyCardVoucherViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[HJMyCardVoucherViewModel alloc] init];
    }
    return _viewModel;
}

- (void)hj_setNavagation {
    self.title = @"优惠券";
    //工具条的按钮的操作
    __weak typeof(self)weakSelf = self;
    HJTopSementView *toolView = [[HJTopSementView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, kHeight(40)) titleColor:HEXColor(@"#333333") selectTitleColor:HEXColor(@"#22476B") lineColor:HEXColor(@"#22476B")  buttons:@[@"可用",@"已使用",@"已过期"] block:^(NSInteger index) {
        weakSelf.selectIndex = index;
        weakSelf.viewModel.myCardVoucherType = index + 1;
        [UIView animateWithDuration:0.25 animations:^{
            [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.selectIndex * Screen_Width, 0)];
        }];
    }];
    [self.view addSubview:toolView];
    
    self.toolView = toolView;
}

- (void)hj_configSubViews {
    self.controllersClass = @[@"HJValidMyCardVoucherViewController",@"HJUsedMyCardVoucherViewController",@"HJInValidMyCardVoucherViewController"];
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
       
        if (index == 0) {
            HJValidMyCardVoucherViewController *listVC = [[HJValidMyCardVoucherViewController alloc] init];
            self.viewModel.myCardVoucherType = index + 1;
            listVC.view.frame = CGRectMake(index * Screen_Width, 0, Screen_Width, Screen_Height  - kNavigationBarHeight - kHeight(40));
            [self addChildViewController:listVC];
            [scrollView addSubview:listVC.view];
            self.validMyCardVoucherVC = listVC;
        } else if (index == 1) {
            HJUsedMyCardVoucherViewController *listVC = [[HJUsedMyCardVoucherViewController alloc] init];
            self.viewModel.myCardVoucherType = index + 1;
            listVC.view.frame = CGRectMake(index * Screen_Width, 0, Screen_Width, Screen_Height  - kNavigationBarHeight - kHeight(40));
            [self addChildViewController:listVC];
            
            [scrollView addSubview:listVC.view];
            self.usedMyCardVoucherVC = listVC;
        } else {
            HJInValidMyCardVoucherViewController *listVC = [[HJInValidMyCardVoucherViewController alloc] init];
            self.viewModel.myCardVoucherType = index + 1;
            listVC.view.frame = CGRectMake(index * Screen_Width, 0, Screen_Width, Screen_Height  - kNavigationBarHeight - kHeight(40));
            [self addChildViewController:listVC];
            [scrollView addSubview:listVC.view];
            
            self.inValidMyCardVoucherVC = listVC;
        }
    }
}

//滚动控制器进行的操作
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = self.view.frame.size.width;
    CGFloat offsetX = scrollView.contentOffset.x;
    //获取索引
    NSInteger scrollIndex = offsetX / width;
    self.toolView.selectIndex = scrollIndex;
}

@end
