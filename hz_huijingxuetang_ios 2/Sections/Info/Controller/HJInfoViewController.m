//
//  HJInfoViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/2.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJInfoViewController.h"
#import "HJBaseInfoViewController.h"
#import "HJTopSementView.h"
#import "HJInfoViewModel.h"
#import "HJNoDataView.h"

#import <Contacts/Contacts.h>
#import <AddressBook/AddressBookDefines.h>
#import <AddressBook/ABRecord.h>

@interface HJInfoViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) HJTopSementView *sementView;

@property (nonatomic, strong) NSArray *controllersClass;
@property (nonatomic,assign) NSInteger  selectIndex;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) HJInfoViewModel *viewModel;

@property (nonatomic,strong) HJNoDataView *noDataView;

@end

@implementation HJInfoViewController

- (HJNoDataView *)noDataView {
    if(!_noDataView) {
        _noDataView = [[HJNoDataView alloc] init];
    }
    return _noDataView;
}

- (HJInfoViewModel *)viewModel {
    if(!_viewModel){
        _viewModel = [[HJInfoViewModel alloc] init];
    }
    return  _viewModel;
}

- (void)hj_setNavagation {
    self.view.backgroundColor = Background_Color;
    self.title = @"资讯";
}

- (void)hj_loadData {
    [self.viewModel.loadingView startAnimating];
    [self.viewModel getnewsItemslistWithSuccess:^(BOOL success) {
        [self.viewModel.loadingView stopLoadingView];
        if(success) {
            self.noDataView.hidden = YES;
            if (self.viewModel.newsItemNameArray.count > 0){
                //加载试图控制器
                [self loadSubViews];
                //设置自试图控制器
                for (int index = 0; index < self.controllersClass.count; index++) {
                    HJBaseInfoViewController *vc = [[HJBaseInfoViewController alloc] init];
                    vc.view.frame = CGRectMake(Screen_Width * index, 0, Screen_Width, Screen_Height - kHeight(40) - kNavigationBarHeight - kBottomBarHeight);
                    [self addChildViewController:vc];
                    [self.scrollView addSubview:vc.view];
                    if(self.viewModel.newsItemArray.count > 0){
                        vc.model = self.viewModel.newsItemArray[index];
                    }
                }
            }
        } else {
            self.noDataView.hidden = NO;
            [self.viewModel.loadingView stopLoadingView];
        }
    }];
}

- (void)loadSubViews {
    __weak typeof(self)weakSelf = self;
    HJTopSementView *toolView = [[HJTopSementView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, kHeight(40)) titleColor:HEXColor(@"#333333") selectTitleColor:HEXColor(@"#22476B") lineColor:HEXColor(@"#22476B")  buttons:self.viewModel.newsItemNameArray block:^(NSInteger index) {
        weakSelf.selectIndex = index;
        [UIView animateWithDuration:0.25 animations:^{
            [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.selectIndex * Screen_Width, 0)];
        }];
    }];
    [self.view addSubview:toolView];
    
    self.sementView = toolView;

    
    //创建控制器容器
    self.controllersClass = @[@"HJBaseInfoViewController",@"HJBaseInfoViewController",@"HJBaseInfoViewController",@"HJBaseInfoViewController"];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kHeight(40) , Screen_Width, Screen_Height - kHeight(40) - kNavigationBarHeight - kBottomBarHeight)];
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(Screen_Width * self.controllersClass.count,  Screen_Height - kHeight(40) - kNavigationBarHeight - kBottomBarHeight);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    
    [self.view addSubview:self.noDataView];
    [self.noDataView.backSubject subscribeNext:^(id  _Nullable x) {
        [self hj_loadData];
    }];
    [self.noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kWidth(150), kHeight(210)));
    }];
}

//滚动的操作
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = self.view.frame.size.width;
    CGFloat offsetX = scrollView.contentOffset.x;
    //获取索引
    NSInteger scrollIndex = offsetX / width;
    self.sementView.selectIndex = scrollIndex;
}

@end
