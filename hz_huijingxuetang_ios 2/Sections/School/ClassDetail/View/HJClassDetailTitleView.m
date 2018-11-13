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
    //标题
    UILabel *titleTextLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"三板斧战法",BoldFont(font(17)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:titleTextLabel];
    [titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(kWidth(10.0));
    }];
    
    //秒
    UILabel *miaoLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"05",MediumFont(font(11)),white_color);
        label.backgroundColor = HEXColor(@"#333740");
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [miaoLabel clipWithCornerRadius:kHeight(2.5) borderColor:nil borderWidth:0];
    [self addSubview:miaoLabel];
    [miaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-kWidth(10.0));
        make.size.mas_equalTo(CGSizeMake(kWidth(18), kHeight(15)));
    }];
    
    //分号
    UILabel *fenHaoLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@":",BoldFont(font(11)),HEXColor(@"#333740"));
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:fenHaoLabel];
    [fenHaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(miaoLabel.mas_left).offset(-kWidth(5.0));
        make.size.mas_equalTo(CGSizeMake(kWidth(2), kHeight(2)));
    }];
    
    //分
    UILabel *fenLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"00",MediumFont(font(11)),white_color);
        label.backgroundColor = HEXColor(@"#333740");
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [fenLabel clipWithCornerRadius:kHeight(2.5) borderColor:nil borderWidth:0];
    [self addSubview:fenLabel];
    [fenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(fenHaoLabel.mas_right).offset(-kWidth(4.0));
        make.size.mas_equalTo(CGSizeMake(kWidth(18), kHeight(15)));
    }];
    
    //天
    UILabel *dayLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"天",MediumFont(font(13)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:dayLabel];
    [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(fenLabel.mas_left).offset(-kWidth(5.0));
        make.size.mas_equalTo(CGSizeMake(kWidth(12), kHeight(12)));
    }];
    
    //天
    UILabel *dayNumLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"05",MediumFont(font(11)),white_color);
        label.backgroundColor = HEXColor(@"#333740");
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [dayNumLabel clipWithCornerRadius:kHeight(2.5) borderColor:nil borderWidth:0];
    [self addSubview:dayNumLabel];
    [dayNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(dayLabel.mas_left).offset(-kWidth(5.0));
        make.size.mas_equalTo(CGSizeMake(kWidth(18), kHeight(15)));
    }];
    
    //剩余
    UILabel *lastLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"剩余",MediumFont(font(13)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:lastLabel];
    [lastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(dayNumLabel.mas_left).offset(-kWidth(5.0));
        make.size.mas_equalTo(CGSizeMake(kWidth(25), kHeight(13)));
    }];
    
    //限时特惠
    UILabel *limitLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"限时特惠",MediumFont(font(11)),white_color);
        label.backgroundColor = HEXColor(@"#DC1E4F");
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:limitLabel];
    [limitLabel clipWithCornerRadius:kHeight(2.5) borderColor:nil borderWidth:0];
    [limitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(dayNumLabel.mas_left).offset(-kWidth(5.0));
        make.size.mas_equalTo(CGSizeMake(kWidth(50), kHeight(15)));
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = Background_Color;
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-kHeight(1.0));
        make.height.mas_equalTo(kHeight(1.0));
    }];
    
}


@end
