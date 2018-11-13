//
//  HJInfoViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/2.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJInfoViewController.h"
#import "HJBaseInfoViewController.h"
#import "HJInfoSegmentView.h"
#import "HJInfoViewModel.h"
@interface HJInfoViewController ()

@property (nonatomic,strong) HJInfoSegmentView *sementView;

@property (nonatomic, strong) NSArray *controllersClass;
@property (nonatomic,assign) NSInteger  selectIndex;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) HJInfoViewModel *viewModel;

@end

@implementation HJInfoViewController

- (HJInfoViewModel *)viewModel {
    if(!_viewModel){
        _viewModel = [[HJInfoViewModel alloc] init];
    }
    return  _viewModel;
}

- (void)hj_setNavagation {
    self.title = @"资讯";
}

- (void)hj_loadData {
    [self.viewModel getnewsItemslistWithSuccess:^{
        //对标题进行赋值
        self.sementView.nameArray = self.viewModel.newsItemNameArray;
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
    }];
}

- (void)hj_configSubViews {
    HJInfoSegmentView *toolView = [[HJInfoSegmentView alloc] init];
    [self.view addSubview:toolView];
    [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(kHeight(40));
        make.top.equalTo(self.view);
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
    self.controllersClass = @[@"HJBaseInfoViewController",@"HJBaseInfoViewController",@"HJBaseInfoViewController",@"HJBaseInfoViewController"];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kHeight(40) , Screen_Width, Screen_Height - kHeight(40) - kNavigationBarHeight -kBottomBarHeight)];
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(Screen_Width * self.controllersClass.count,  Screen_Height - kHeight(40) - kBottomBarHeight);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = NO;
    scrollView.bounces = NO;
    
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}

@end
