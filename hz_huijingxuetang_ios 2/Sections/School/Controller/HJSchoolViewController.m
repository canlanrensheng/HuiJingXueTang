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
@interface HJSchoolViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *controllersClass;
@property (nonatomic,assign) NSInteger  selectIndex;
@property (nonatomic,strong) UIScrollView *scrollView;


@property (nonatomic,strong) UIButton *footerView;

@property (nonatomic,strong) HJSchoolSementView *toolView;
@property (nonatomic,strong) HJSchoolSearchView *searchView;

@property (nonatomic,strong) UIView *navView;

@end


@implementation HJSchoolViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CGFLOAT_MIN * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    hideHud();
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
}

//设置导航条的属性
- (void)hj_setNavagation {
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, kNavigationBarHeight)];
    navView.backgroundColor = NavAndBtnColor;
    [self.view addSubview:navView];
    self.navView = navView;
    
    self.searchView = [[HJSchoolSearchView alloc] init];
    [navView addSubview:self.searchView];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(navView).offset(kWidth(10.0));
        make.top.equalTo(navView).offset(kStatusBarHeight + kHeight(8.0));
        make.right.equalTo(navView).offset(-kWidth(37));
        make.height.mas_equalTo(kHeight(28.0));
    }];
    
    @weakify(self);
    [self.searchView.searchSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if(self.selectIndex == 0)  {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"HiddenSelectView" object:nil userInfo:nil];
            NSDictionary *para =  @{@"type" : @"2"};
            [DCURLRouter pushURLString:@"route://searchResultVC" query:para  animated:YES];
        } else {
            NSDictionary *para =  @{@"type" : @"3"};
            [DCURLRouter pushURLString:@"route://searchResultVC" query:para  animated:YES];
        }
    }];
    
    UIButton *carBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"",nil,white_color,0);
        [button setBackgroundImage:V_IMAGE(@"购物车") forState:UIControlStateNormal];
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"HiddenSelectView" object:nil userInfo:nil];
            if([APPUserDataIofo AccessToken].length <= 0) {
//                ShowMessage(@"您还未登录");
                [DCURLRouter pushURLString:@"route://loginVC" animated:YES];
                return;
            }
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

//监听通知的处理
- (void)hj_bindViewModel {
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"SetToLiveVC" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        self.toolView.selectIndex = 1;
        [self.scrollView setContentOffset:CGPointMake(Screen_Width, 0)];
    }];
    
    //定位到学堂模块
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"JumpToSchoolVCourse" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        self.toolView.selectIndex = 0;
        self.selectIndex = 0;
        self.searchView.placeLabel.text = @"搜索/老师/课程";
        [self.scrollView setContentOffset:CGPointMake(0, 0)];
    }];
}

//加载页面视图的方法
- (void)hj_configSubViews {
    __weak typeof(self)weakSelf = self;
    HJSchoolSementView *toolView = [[HJSchoolSementView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, Screen_Width, kHeight(45)) titleColor:white_color selectTitleColor:white_color lineColor:HEXColor(@"#FAD466")  buttons:@[@"课程",@"直播"] block:^(NSInteger index) {
        if(index == 0) {
            weakSelf.searchView.placeLabel.text = @"搜索/老师/课程";
        } else {
            weakSelf.searchView.placeLabel.text = @"搜索/老师/直播";
        }
        weakSelf.selectIndex = index;
        [UIView animateWithDuration:0.25 animations:^{
            [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.selectIndex * Screen_Width, 0)];
        }];
    }];
    [self.view addSubview:toolView];
    self.toolView = toolView;
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navView.mas_bottom);
        make.height.mas_equalTo(kHeight(45));
    }];
    
    CGFloat vcHeight = Screen_Height - kNavigationBarHeight - kBottomBarHeight - kHeight(45);
    self.controllersClass = @[@"HJSchoolClassViewController",@"HJSchoolLiveViewController"];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.toolView.frame), Screen_Width, vcHeight)];
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(Screen_Width * self.controllersClass.count,  vcHeight);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.delegate = self;
    scrollView.bounces = NO;
    
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    for (int index = 0; index < self.controllersClass.count; index++) {
        if(index == 0) {
            HJSchoolClassViewController *listVC = [[HJSchoolClassViewController alloc] init];
            listVC.view.frame = CGRectMake(0, 0, Screen_Width, vcHeight);
            [self addChildViewController:listVC];
            [scrollView addSubview:listVC.view];
        }  else if (index == 1){
            HJSchoolLiveViewController *listVC = [[HJSchoolLiveViewController alloc] init];
            listVC.view.frame = CGRectMake(Screen_Width * 1, 0, Screen_Width, vcHeight  );
            [self addChildViewController:listVC];
            [scrollView addSubview:listVC.view];
        }
    }
}

- (void)hj_loadData {

}

//设置页面滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = self.view.frame.size.width;
    CGFloat offsetX = scrollView.contentOffset.x;
    //获取索引
    NSInteger scrollIndex = offsetX / width;
    self.toolView.selectIndex = scrollIndex;
    self.selectIndex = scrollIndex;
    if(scrollIndex == 0) {
        self.searchView.placeLabel.text = @"搜索/老师/课程";
    } else {
        self.searchView.placeLabel.text = @"搜索/老师/直播";
    }
}



@end
