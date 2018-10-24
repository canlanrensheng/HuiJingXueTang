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
    [self addSubview:_scrollView];

    //
    NSArray *btnimgarr = @[@"直播ICON",@"教学跟踪ICON",@"绝技诊股ICON",@"教参精华"];
    NSArray *btnlbarr = @[@"直播教学",@"教学跟踪",@"绝技诊股",@"教参精华"];
    for (int i = 0; i < 4; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(Screen_Width / 4*i, _scrollView.frame.size.height, Screen_Width / 4, kHeight(100.0))];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];

        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((view.width - kWidth(44)) / 2, kHeight(18.0), kWidth(44), kWidth(44))];
        btn.tag = 1234+i;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:btnimgarr[i]] forState:UIControlStateNormal];
        [view addSubview:btn];

        UILabel *btnlb = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(btn.frame) + kHeight(10.0), view.width, kHeight(10.0))];
        btnlb.textColor = HEXColor(@"#333333");
        btnlb.text = btnlbarr[i];
        btnlb.textAlignment = 1;
        btnlb.font = MediumFont(font(11.0));
        [view addSubview:btnlb];
    }
}

//点击跳转的处理
- (void)btnAction:(UIButton *)btn {
    
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
   //跳转处理
    if(_scrollView.imageURLStringsGroup.count > 0) {
        NSDictionary *dic = self.listViewModel.cycleScrollViewDataArray[index];
        NSInteger link = [dic[@"link"] integerValue];
        if (link == 1) {
            NSString *imgurl = dic[@"content"];
            AdJumpViewController *vc = [[AdJumpViewController alloc] init];
            vc.type = @"1";
            vc.url = imgurl;
            [VisibleViewController().navigationController pushViewController:vc animated:YES];
        }else{
            NSString *imgurl = dic[@"content"];
            AdJumpViewController *vc = [[AdJumpViewController alloc] init];
            vc.type = @"0";
            vc.url = imgurl;
            [VisibleViewController().navigationController pushViewController:vc animated:YES];
        }
    }
    
}

- (void)setViewModel:(BaseViewModel *)viewModel {
    self.listViewModel = (HJHomeViewModel *)viewModel;
    _scrollView.imageURLStringsGroup = self.listViewModel.headerDataArray;
}

@end
