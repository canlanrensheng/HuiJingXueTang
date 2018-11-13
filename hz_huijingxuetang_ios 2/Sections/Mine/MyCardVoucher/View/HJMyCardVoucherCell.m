//
//  HJMyCardVoucherCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/9.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJMyCardVoucherCell.h"

@implementation HJMyCardVoucherCell

- (void)hj_configSubViews {
    
    self.backgroundColor = HEXColor(@"#F5F5F5");
    
    //图片
    UIImageView *imaV = [[UIImageView alloc] init];
    imaV.image = V_IMAGE(@"优惠券可使用");
    imaV.backgroundColor = white_color;
    imaV.userInteractionEnabled = YES;
    [self addSubview:imaV];
    [imaV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(kWidth(10));
        make.right.equalTo(self).offset(-kWidth(10));
        make.height.mas_equalTo(kHeight(100));
    }];
    [imaV clipWithCornerRadius:kHeight(5.0) borderColor:nil borderWidth:0];

    //名称
    UILabel *priceLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"129",BoldFont(font(30)),HEXColor(@"#FF3C00"));
        label.textAlignment = NSTextAlignmentCenter;
        [label sizeToFit];
    }];
    [self addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imaV).offset(kHeight(27.0));
        make.left.equalTo(imaV).offset(kWidth(21.0));
        make.height.mas_equalTo(kHeight(23.0));
    }];
    NSString *priceString = @"129元";
    priceLabel.attributedText = [priceString attributeWithStr:@"元" color:HEXColor(@"#333333") font:BoldFont(font(10))];
    
    //满1000抵用
    UILabel *diYongLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"满1000抵用",MediumFont(font(11)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentCenter;
        [label sizeToFit];
    }];
    [self addSubview:diYongLabel];
    [diYongLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceLabel.mas_bottom).offset(kHeight(10.0));
        make.centerX.equalTo(priceLabel);
        make.height.mas_equalTo(kHeight(11.0));
    }];
    
    //新学员抵用券
    UILabel *quanNameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"新学员抵用券",MediumFont(font(15)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [self addSubview:quanNameLabel];
    [quanNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceLabel.mas_right).offset(kWidth(44));
        make.centerY.equalTo(priceLabel);
        make.height.mas_equalTo(kHeight(15.0));
    }];
    
    //日期
    UILabel *dateLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"8月21日-9月10日",[UIFont fontWithName:@"PingFangSC-Regular" size:font(11)],HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [self addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(quanNameLabel);
        make.centerY.equalTo(diYongLabel);
        make.height.mas_equalTo(kHeight(10.0));
    }];
}

@end
