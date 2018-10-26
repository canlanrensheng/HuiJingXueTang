//
//  HJSelectJiListCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/25.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSelectJiListCell.h"

@implementation HJSelectJiListCell

- (void)hj_configSubViews {
    UILabel *jiNameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"1.识别K线",MediumFont(font(14)),HEXColor(@"#333333"));
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:jiNameLabel];
    [jiNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kHeight(10.0));
        make.left.equalTo(self).offset(kWidth(11.0));
        make.height.mas_equalTo(kHeight(13));
    }];
    
    //直播的状态
    UILabel *liveStatusLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"点播",MediumFont(font(10)),HEXColor(@"#22476B"));
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = white_color;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [liveStatusLabel clipWithCornerRadius:kHeight(2.5) borderColor:HEXColor(@"#22476B") borderWidth:kHeight(1.0)];
    [self addSubview:liveStatusLabel];
    [liveStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(jiNameLabel);
        make.left.equalTo(jiNameLabel.mas_right).offset(kWidth(8.0));
        make.size.mas_equalTo(CGSizeMake(kWidth(25), kHeight(15)));
    }];
    
    liveStatusLabel.hidden = YES;
    
    UILabel *onLiveStatusLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"正在播放",MediumFont(font(10)),white_color);
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = HEXColor(@"#0ABC64");
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [onLiveStatusLabel clipWithCornerRadius:kHeight(2.5) borderColor:nil borderWidth:0];
    [self addSubview:onLiveStatusLabel];
    [onLiveStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(jiNameLabel);
        make.left.equalTo(jiNameLabel.mas_right).offset(kWidth(8.0));
        make.size.mas_equalTo(CGSizeMake(kWidth(47), kHeight(15)));
    }];
    
    UIImageView *liveStatusImageV = [[UIImageView alloc] init];
    liveStatusImageV.image = V_IMAGE(@"liveStatusImageV");
    [self addSubview:liveStatusImageV];
    [liveStatusImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-kWidth(10));
        make.width.height.mas_equalTo(kWidth(24));
    }];
    
    //课程的播放的次数
    UILabel *playCountLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"俞春 1500次播放",MediumFont(font(11)),HEXColor(@"#999999"));
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:playCountLabel];
    [playCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(jiNameLabel.mas_bottom).offset(kHeight(5.0));
        make.left.equalTo(self).offset(kWidth(11.0));
        make.height.mas_equalTo(kHeight(11.0));
    }];
}

@end
