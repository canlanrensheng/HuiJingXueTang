//
//  HJClassDetailTitleView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/9.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJClassDetailTitleView.h"


@implementation HJClassDetailTitleView

- (void)hj_configSubViews {
    
    self.backgroundColor = HEXColor(@"#F5F5F5");
    
    UIView * topBackView = [[UIView alloc] init];
    topBackView.backgroundColor = white_color;
    [self addSubview:topBackView];
    [topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(kHeight(45.0));
    }];
    
    //标题
    UILabel *titleTextLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"暂无课程标题",BoldFont(font(17)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [topBackView addSubview:titleTextLabel];
    [titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topBackView);
        make.left.equalTo(topBackView).offset(kWidth(10.0));
    }];
    
    self.titleTextLabel = titleTextLabel;
    
    //倒计时操作
    TimeCountDownView *timeCountDownView = [[TimeCountDownView alloc] init];
    timeCountDownView.backgroundColor = white_color;
    timeCountDownView.backgroundImageName = @"返回按钮";
//    timeCountDownView.timestamp = 100000;
    timeCountDownView.timerStopBlock = ^{
        DLog(@"时间停止");
    };
    [topBackView addSubview:timeCountDownView];
    [timeCountDownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topBackView);
        make.right.equalTo(topBackView).offset(-kWidth(10));
        make.size.mas_equalTo(CGSizeMake(Screen_Width - kWidth(191), kHeight(15)));
    }];
    self.timeCountDownView = timeCountDownView;
    timeCountDownView.hidden = YES;

}


@end
