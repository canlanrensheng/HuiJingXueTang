//
//  HJHomeHeaderView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/22.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJHomeHeaderView.h"
#import "SDCycleScrollView.h"
#import "HJHomeViewModel.h"
#import "AdJumpViewController.h"
@interface HJHomeHeaderView ()<SDCycleScrollViewDelegate>

//轮播图区域
@property (nonatomic,strong) SDCycleScrollView *scrollView;
@property (nonatomic,strong) HJHomeViewModel *listViewModel;

@end

@implementation HJHomeHeaderView

- (void)hj_configSubViews {
    
    _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, Screen_Width, kHeight(185)) delegate:self placeholderImage:nil];
    _scrollView.backgroundColor = Background_Color;
    _scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    //设置循环滚动的图片的网址
    _scrollView.currentPageDotColor = white_color;
    _scrollView.pageDotColor = RGBA(255, 255, 255, 0.2);
    _scrollView.autoScrollTimeInterval = 4.0f;
    _scrollView.placeholderImage = V_IMAGE(@"占位图");
    [self addSubview:_scrollView];

    //
    NSArray *btnimgarr = @[@"直播ICON",@"砍价抢课ICON",@"绝技诊股ICON",@"教参精华"];
    NSArray *btnlbarr = @[@"正在直播",@"砍价抢课",@"绝技诊股",@"教参精华"];
    if(MaJia) {
        btnimgarr = @[@"教学跟踪ICON",@"绝技诊股ICON",@"教参精华"];
        btnlbarr = @[@"教学跟踪",@"绝技诊股",@"教参精华"];
    }
    for (int i = 0; i < btnimgarr.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(Screen_Width / btnimgarr.count *i, _scrollView.frame.size.height, Screen_Width / btnimgarr.count, kHeight(100.0))];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];

        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((view.width - kWidth(44)) / 2, kHeight(18.0), kWidth(44), kWidth(44))];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:btnimgarr[i]] forState:UIControlStateNormal];
        [view addSubview:btn];
        if((!MaJia) && (i == 0)){
            self.onLiveButton = btn;
        }

        UILabel *btnlb = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btn.frame) + kHeight(10.0), view.width, kHeight(10.0))];
        btnlb.textColor = HEXColor(@"#333333");
        btnlb.text = btnlbarr[i];
        btnlb.textAlignment = 1;
        btnlb.font = MediumFont(font(11.0));
        [view addSubview:btnlb];
    }
}

//点击跳转的处理
- (void)btnAction:(UIButton *)btn {
    if (btn.tag == 0) {
        if(MaJia){
           //教学跟踪
//            VisibleViewController().tabBarController.selectedIndex = 2;
            NSDictionary *para = @{@"index" : @(0)};
            [DCURLRouter pushURLString:@"route://infoVC" query:para animated:YES];
            return;
        }
        //正在直播
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"SetToLiveVC" object:nil userInfo:nil];
//        VisibleViewController().tabBarController.selectedIndex = 1;
        [DCURLRouter pushURLString:@"route://onLiveVC" animated:YES];
    } else if ( btn.tag == 1) {
        //教学跟踪
        if(MaJia) {
            //绝技诊股
            if([APPUserDataIofo AccessToken].length <= 0) {
                [DCURLRouter pushURLString:@"route://loginVC" animated:YES];
                return;
            }
            [DCURLRouter pushURLString:@"route://stuntJudgeVC" animated:YES];
            return;
        }
//        VisibleViewController().tabBarController.selectedIndex = 3;
        //砍价抢课
        [DCURLRouter pushURLString:@"route://killPriceCourseVC" animated:YES];
    } else if (btn.tag == 2) {
        if(MaJia) {
            //教参精华
//            VisibleViewController().tabBarController.selectedIndex = 2;
            NSDictionary *para = @{@"index" : @(2)};
            [DCURLRouter pushURLString:@"route://infoVC" query:para animated:YES];
            return;
        }
        if([APPUserDataIofo AccessToken].length <= 0) {
            [DCURLRouter pushURLString:@"route://loginVC" animated:YES];
            return;
        }
        //绝技诊股
        [DCURLRouter pushURLString:@"route://stuntJudgeVC" animated:YES];
    } else if ( btn.tag == 3) {
        if(MaJia) {
             //马甲跳转到资讯页面
            VisibleViewController().tabBarController.selectedIndex = 2;
            return;
        }
        if([APPUserDataIofo AccessToken].length <= 0) {
//            ShowMessage(@"您还未登录");
            [DCURLRouter pushURLString:@"route://loginVC" animated:YES];
            return;
        }
        //教参精华
        [DCURLRouter pushURLString:@"route://teachBestVC" animated:YES];
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    //跳转处理
    if(_scrollView.imageURLStringsGroup.count > 0) {
        NSDictionary *dic = self.listViewModel.cycleScrollViewDataArray[index];
        NSString *courseId = [dic valueForKey:@"content"];
        if(courseId.length > 0) {
            if([APPUserDataIofo AccessToken].length <= 0) {
                [DCURLRouter pushURLString:@"route://loginVC" animated:YES];
                return;
            }
            [DCURLRouter pushURLString:@"route://classDetailVC" query:@{@"courseId" : [dic valueForKey:@"content"]} animated:YES];
        } else{
            ShowMessage(@"课程Id不能为空");
        }
    }
}

- (void)setViewModel:(BaseViewModel *)viewModel {
    self.listViewModel = (HJHomeViewModel *)viewModel;
    _scrollView.imageURLStringsGroup = self.listViewModel.headerDataArray;
}

@end
