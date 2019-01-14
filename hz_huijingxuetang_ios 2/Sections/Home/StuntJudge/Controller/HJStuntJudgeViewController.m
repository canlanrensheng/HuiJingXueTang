//
//  HJStuntJudgeViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/27.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJStuntJudgeViewController.h"

#import "HJStuntJudgeRecommendViewController.h"
#import "HJStuntJudgeReplyedViewController.h"
#import "HJStuntJudgeWaitReplyViewController.h"
#import "HJStuntJudgeToolView.h"
#import "HJStuntJudgeViewModel.h"

@interface HJStuntJudgeViewController()<UIScrollViewDelegate>


@property (nonatomic, strong) NSArray *controllersClass;


@property (nonatomic,assign) NSInteger  selectIndex;

@property (nonatomic,strong) HJStuntJudgeToolView *toolView;

@property (nonatomic,strong) HJStuntJudgeViewModel *viewModel;

@property (nonatomic,strong) UIScrollView *scrollView;

//添加按钮
@property (nonatomic,strong) UIButton *addReplyBtn;


@end


@implementation HJStuntJudgeViewController

- (HJStuntJudgeViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[HJStuntJudgeViewModel alloc] init];
    }
    return  _viewModel;
}


- (void)hj_setNavagation {
    self.title = @"绝技诊股";
    //工具条的按钮的操作
    HJStuntJudgeToolView *toolView = [[HJStuntJudgeToolView alloc] init];
    [self.view addSubview:toolView];
    [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(kHeight(40));
        make.top.mas_equalTo(kHeight(0));
    }];
    self.toolView = toolView;
    @weakify(self);
    [toolView.clickSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.viewModel.stuntJuageType = [x integerValue];
        //刷新数据
        self.selectIndex = [x integerValue];
        [UIView animateWithDuration:0.25 animations:^{
            [self.scrollView setContentOffset:CGPointMake(self.selectIndex * Screen_Width, 0)];
        }];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshStuntJudgeData" object:nil userInfo:@{@"index" :@(self.selectIndex)}];
    }];

    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"RefreshWaitReplyListData" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        self.viewModel.stuntJuageType = 2;
        [self.toolView.lastSelectButton setTitleColor:HEXColor(@"#333333") forState:UIControlStateNormal];
        [self.toolView.evaluationButton setTitleColor:HEXColor(@"#22476B") forState:UIControlStateNormal];
        self.toolView.lastSelectButton = self.toolView.evaluationButton;
        self.toolView.lineView.centerX = self.toolView.lastSelectButton.centerX;
        self.selectIndex = 2;
        [UIView animateWithDuration:0.25 animations:^{
            [self.scrollView setContentOffset:CGPointMake(self.selectIndex * Screen_Width, 0)];
        }];
    }];
    
    self.viewModel.toolView = toolView;
}

- (void)hj_configSubViews {
    self.controllersClass = @[@"HJStuntJudgeRecommendViewController",@"HJStuntJudgeReplyedViewController",@"HJStuntJudgeWaitReplyViewController"];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kHeight(40), Screen_Width, Screen_Height - kHeight(40))];
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(Screen_Width * self.controllersClass.count,  Screen_Height - kHeight(40));
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.delegate = self;
    scrollView.bounces = NO;
    
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;

    for (int index = 0; index < self.controllersClass.count; index++) {
        if(index == 0) {
            HJStuntJudgeRecommendViewController *listVC = [[HJStuntJudgeRecommendViewController alloc] initWithViewModel:self.viewModel];
            listVC.view.frame = CGRectMake(0, 0, Screen_Width, Screen_Height - kHeight(40) - kNavigationBarHeight);
            [self addChildViewController:listVC];
            [scrollView addSubview:listVC.view];
        }  else if (index == 1){
            HJStuntJudgeReplyedViewController *listVC = [[HJStuntJudgeReplyedViewController alloc] initWithViewModel:self.viewModel];
            listVC.view.frame = CGRectMake(Screen_Width * 1, 0, Screen_Width, Screen_Height - kHeight(40) - kNavigationBarHeight);
            [self addChildViewController:listVC];
            [scrollView addSubview:listVC.view];
        } else if (index == 2){
            HJStuntJudgeWaitReplyViewController *listVC = [[HJStuntJudgeWaitReplyViewController alloc] initWithViewModel:self.viewModel];
            listVC.view.frame = CGRectMake(Screen_Width * 2, 0, Screen_Width, Screen_Height - kHeight(40) - kNavigationBarHeight);
            [self addChildViewController:listVC];
            [scrollView addSubview:listVC.view];
        }
    }
    
    [self.view addSubview:self.addReplyBtn];
    [self.addReplyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-kWidth(17));
        make.size.mas_equalTo(CGSizeMake(kWidth(67), kHeight(67)));
        make.bottom.equalTo(self.view).offset(-kHeight(85));
    }];
}

//添加提问的按钮
- (UIButton *)addReplyBtn {
    if(!_addReplyBtn) {
        _addReplyBtn = [UIButton creatButton:^(UIButton *button) {
            button.ljTitle_font_titleColor_state(@"",H15,white_color,0);
            button.backgroundColor = clear_color;
            [button setBackgroundImage:V_IMAGE(@"提问按钮") forState:UIControlStateNormal];
            //            @weakify(self);
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                //                @strongify(self);
                [DCURLRouter pushURLString:@"route://stuntJudgeAddReplyVC" animated:YES];
            }];
        }];
    }
    return _addReplyBtn;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = self.view.frame.size.width;
    CGFloat offsetX = scrollView.contentOffset.x;
    //获取索引
    NSInteger scrollIndex = offsetX / width;
    self.toolView.selectIndex = scrollIndex;
}

@end


