//
//  HJMessageDetailCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/8.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJMessageDetailCell.h"

@implementation HJMessageDetailCell

- (void)hj_configSubViews {
    self.backgroundColor = HEXColor(@"0xf5f5f5");
    
    //背景试图
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = white_color;
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(kWidth(10));
        make.right.equalTo(self).offset(-kWidth(10));
        make.height.mas_equalTo(kHeight(100));
    }];
    backView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1].CGColor;
    backView.layer.shadowOffset = CGSizeMake(0,2);
    backView.layer.shadowOpacity = 1;
    backView.layer.shadowRadius = kHeight(8.0);
    backView.layer.cornerRadius = kHeight(5.0);
    backView.clipsToBounds = YES;
    
    //时间
    UILabel *timeLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"8月20日",MediumFont(font(11)),HEXColor(@"#CCCCCC"));
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [backView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView);
        make.top.equalTo(backView).offset(kHeight(14));
        make.height.mas_equalTo(kHeight(10));
    }];
    
    //标题
    UILabel *titleTextLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"绝技诊股",BoldFont(font(15)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [backView addSubview:titleTextLabel];
    [titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(kHeight(10));
        make.top.equalTo(backView).offset(kHeight(38));
        make.height.mas_equalTo(kHeight(15));
    }];
    
    //描述的标题
    UILabel *desTextLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"你的问题已被回复，点击查看",BoldFont(font(13)),HEXColor(@"#666666"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [backView addSubview:desTextLabel];
    [desTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleTextLabel);
        make.top.equalTo(titleTextLabel.mas_bottom).offset(kHeight(10));
        make.height.mas_equalTo(kHeight(14));
    }];
    
    //箭头
    UIImageView *arrowImageV = [[UIImageView alloc] init];
    arrowImageV.image = V_IMAGE(@"形状 8371");
    [backView addSubview:arrowImageV];
    [arrowImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView).offset(-kWidth(10));
        make.centerY.equalTo(backView);
    }];
    
}

@end
