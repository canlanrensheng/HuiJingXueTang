//
//  HJHomeLatestSatausView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/23.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJHomeLatestSatausView.h"
#import "AdvertScrollView.h"
#import "HJHomeViewModel.h"
@interface HJHomeLatestSatausView ()

@property (nonatomic,strong) AdvertScrollView *advertScrollView;

@end

@implementation HJHomeLatestSatausView


- (void)hj_configSubViews {
    self.backgroundColor = white_color;
    
    UIView *topiew = [[UIView alloc] init];
    topiew.backgroundColor = Background_Color;
    [self addSubview:topiew];
    [topiew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(kHeight(10.0));
    }];
    
    
    UIView *scrollView = [[UIView alloc] init];
    scrollView.backgroundColor = white_color;
    [self addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(topiew.mas_bottom);
        make.height.mas_equalTo(kHeight(52));
    }];
    
    //最新的动态的图片
    UIImageView *makeMoneyRankImageView = [[UIImageView alloc] init];
    makeMoneyRankImageView.image = V_IMAGE(@"最新资讯");
    [scrollView addSubview:makeMoneyRankImageView];
    [makeMoneyRankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(scrollView);
        make.left.equalTo(self).offset(kWidth(10.0));
        make.size.mas_equalTo(CGSizeMake(kWidth(36), kHeight(34)));
    }];
    
    _advertScrollView = [[AdvertScrollView alloc] initWithFrame:CGRectMake(kWidth(55.0), kHeight(8.0),Screen_Width - kWidth(55.0 + 10.0), kHeight(40.0))];
    _advertScrollView.centerY = makeMoneyRankImageView.centerY;
    _advertScrollView.advertScrollViewStyle = AdvertScrollViewStyleMore;
    _advertScrollView.titleFont = MediumFont(font(13.0));
    _advertScrollView.scrollTimeInterval = 3.0;
    _advertScrollView.topTitleColor = HEXColor(@"#333333");
    _advertScrollView.bottomTitleColor = HEXColor(@"#333333");
    _advertScrollView.textAlignment = NSTextAlignmentLeft;
    
    [scrollView addSubview:_advertScrollView];
    [_advertScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(makeMoneyRankImageView.mas_right).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(40);
        make.centerY.equalTo(makeMoneyRankImageView).offset(-kHeight(2.0));
    }];
    
    UIView *bottomiew = [[UIView alloc] init];
    bottomiew.backgroundColor = Background_Color;
    [self addSubview:bottomiew];
    [bottomiew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(scrollView.mas_bottom);
        make.height.mas_equalTo(kHeight(10.0));
    }];
}

- (void)setViewModel:(BaseViewModel *)viewModel {
    HJHomeViewModel *listViewModel = (HJHomeViewModel *)viewModel;
    _advertScrollView.topTitles = listViewModel.topTitlesArray;
    _advertScrollView.bottomTitles= listViewModel.bottomTitlesArray;
}

@end
