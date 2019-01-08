//
//  HJNoDataView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/22.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJNoDataView.h"

@implementation HJNoDataView

- (void)hj_configSubViews {
    UIImageView *liveImageV = [[UIImageView alloc] init];
    liveImageV.image = V_IMAGE(@"网络问题空白页");
    [self addSubview:liveImageV];
    [liveImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self);
    }];
    self.iconImageV = liveImageV;
    
    UILabel *noDataLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"网络好像出了点问题",MediumFont(font(15)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:noDataLabel];
    [noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(liveImageV.mas_bottom).offset(kWidth(15));
        make.height.mas_equalTo(kHeight(15));
    }];
    self.noDataLabel = noDataLabel;
    
    //点击刷新的操作
    UIButton *refreshBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"",H15,white_color,0);
        [button setBackgroundImage:V_IMAGE(@"点击刷新") forState:UIControlStateNormal];
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.backSubject sendNext:@""];
        }];
    }];
    [self addSubview:refreshBtn];
    [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(noDataLabel.mas_bottom).offset(kWidth(35));
        make.size.mas_equalTo(CGSizeMake(kWidth(150), kHeight(40)));
    }];
    self.refreshBtn = refreshBtn;
}

@end
