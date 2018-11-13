//
//  HJSchoolViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/23.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSchoolViewController.h"
#import "HJSchoolClassViewController.h"
#import "HJSchoolLiveViewController.h"
#import "HJSchoolSementView.h"
#import "HJSchoolSearchView.h"

//#import "shoppingCartViewController.h"
@interface HJSchoolViewController ()

@property (nonatomic, strong) NSArray *controllersClass;
@property (nonatomic,assign) NSInteger  selectIndex;
@property (nonatomic,strong) UIScrollView *scrollView;


@property (nonatomic,strong) UIButton *footerView;

@property (nonatomic,strong) HJSchoolSementView *topButtonView;
@property (nonatomic,strong) HJSchoolSearchView *searchView;

@end


@implementation HJSchoolViewController

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
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, kNavigationBarHeight)];
    navView.backgroundColor = NavAndBtnColor;
    [self.view addSubview:navView];
    
    self.searchView = [[HJSchoolSearchView alloc] init];
    [navView addSubview:self.searchView];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(navView).offset(kWidth(10.0));
        make.top.equalTo(navView).offset(kStatusBarHeight + kHeight(8.0));
        make.right.equalTo(navView).offset(-kWidth(37));
        make.height.mas_equalTo(kHeight(28.0));
    }];
    [self.searchView.searchSubject subscribeNext:^(id  _Nullable x) {
        [DCURLRouter pushURLString:@"route://searchResultVC" animated:YES];
    }];
    
    UIButton *carBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"",nil,white_color,0);
        [button setBackgroundImage:V_IMAGE(@"购物车") forState:UIControlStateNormal];
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [DCURLRouter pushURLString:@"route://shopCarVC" animated:YES];
        }];
    }];
    [navView addSubview:carBtn];
    [carBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.searchView);
        make.right.equalTo(navView).offset(-kWidth(10.0));
        make.width.height.mas_offset(kWidth(16));
    }];
    
}

- (void)hj_configSubViews {
    [self.view addSubview:self.topButtonView];
    
    self.controllersClass = @[@"HJSchoolClassViewController",@"HJSchoolLiveViewController"];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight + kHeight(45), Screen_Width, Screen_Height - kNavigationBarHeight - kBottomBarHeight - kHeight(45))];
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
            HJSchoolClassViewController *listVC = [[HJSchoolClassViewController alloc] init];
            listVC.view.frame = CGRectMake(0, 0, Screen_Width, Screen_Height  - kNavigationBarHeight - kBottomBarHeight - kHeight(45));
            [self addChildViewController:listVC];
            [scrollView addSubview:listVC.view];
        }  else if (index == 1){
            HJSchoolLiveViewController *listVC = [[HJSchoolLiveViewController alloc] init];
            listVC.view.frame = CGRectMake(Screen_Width * 1, 0, Screen_Width, Screen_Height - kNavigationBarHeight - kBottomBarHeight - kHeight(45));
            [self addChildViewController:listVC];
            [scrollView addSubview:listVC.view];
        }
    }
}

- (void)hj_loadData {
    
}

- (HJSchoolSementView *)topButtonView {
    if (!_topButtonView) {
        _topButtonView = [[HJSchoolSementView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, Screen_Width, kHeight(45))];
        @weakify(self);
        [_topButtonView.clickSubject subscribeNext:^(id x) {
            @strongify(self);
            self.selectIndex = [x integerValue];
            [self.scrollView setContentOffset:CGPointMake(self.selectIndex * Screen_Width, 0)];
            if(self.selectIndex == 0) {
                self.searchView.placeLabel.text = @"搜索/老师/课程";
            } else {
                self.searchView.placeLabel.text = @"搜索/老师/直播间";
            }
        }];
    }
    return _topButtonView;
}

@end
