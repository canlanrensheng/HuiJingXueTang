//
//  HJLiveReviewSementView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/29.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJLiveReviewSementView.h"

@interface HJLiveReviewSementView ()


@end

@implementation HJLiveReviewSementView

- (void)hj_configSubViews {
    self.backgroundColor = white_color;
    
    UILabel *liveReviewLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"往期回顾",BoldFont(font(15)),HEXColor(@"#141E2F"));
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:liveReviewLabel];
    [liveReviewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    //返回直播的按钮
    UIButton *backLiveBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"返回直播",MediumFont(font(11)),white_color,0);
        button.backgroundColor = HEXColor(@"#22476B");
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [DCURLRouter popViewControllerAnimated:YES];
        }];
    }];
    [backLiveBtn clipWithCornerRadius:kHeight(10.0) borderColor:nil borderWidth:0];
    [self addSubview:backLiveBtn];
    [backLiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-kWidth(10.0));
        make.size.mas_equalTo(CGSizeMake(kWidth(65), kHeight(20)));
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = Line_Color;
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(kHeight(0.5));
    }];
}

@end
