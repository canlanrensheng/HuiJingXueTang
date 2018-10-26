//
//  HJSearchResultInfomationCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/26.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSearchResultInfomationCell.h"

@implementation HJSearchResultInfomationCell

- (void)hj_configSubViews {
    //图片
    UIImageView *imaV = [[UIImageView alloc] init];
    imaV.image = V_IMAGE(@"占位图");
    //    [imaV sd_setImageWithURL:URL(model.coursepic) placeholderImage:nil];
    imaV.backgroundColor = Background_Color;
    [self addSubview:imaV];
    [imaV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-kWidth(10.0));
        make.width.mas_equalTo(kWidth(160));
        make.height.mas_equalTo(kHeight(90));
    }];
    [imaV clipWithCornerRadius:kHeight(5.0) borderColor:nil borderWidth:0];

    
    //名称
    UILabel *nameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"重温经典系列之新K线战法",BoldFont(font(14)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imaV).offset(kHeight(6.0));
        make.left.equalTo(self).offset(kWidth(10.0));
        make.height.mas_equalTo(kHeight(14.0));
        make.right.equalTo(imaV.mas_left).offset(-kWidth(10.0));
    }];
    
    //描述
    UILabel *desLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"如何在动荡股市中求得一颗平常心 唯一可以...",MediumFont(font(11)),HEXColor(@"#666666"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 2;
        [label sizeToFit];
    }];
    [self addSubview:desLabel];
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(kHeight(10.0));
        make.left.equalTo(self).offset(kWidth(10.0));
//        make.height.mas_equalTo(kHeight(26.0));
        make.right.equalTo(imaV.mas_left).offset(-kWidth(10.0));
    }];
    
    //阅读的图标
    UIImageView *readImaV = [[UIImageView alloc] init];
    readImaV.image = V_IMAGE(@"阅读ICON");
    //    [imaV sd_setImageWithURL:URL(model.coursepic) placeholderImage:nil];
    readImaV.backgroundColor = Background_Color;
    [self addSubview:readImaV];
    [readImaV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(10.0));
        make.bottom.equalTo(imaV.mas_bottom).offset(-kHeight(5.0));
    }];
    
    //阅读的数量
    UILabel *readCountLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"2208",MediumFont(font(11)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [self addSubview:readCountLabel];
    [readCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(readImaV.mas_right).offset(kWidth(5.0));
        make.centerY.equalTo(readImaV);
        make.height.mas_equalTo(kHeight(9.0));
    }];
    
    //时间
    UILabel *timeLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"18/08/29",MediumFont(font(11)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentRight;
        [label sizeToFit];
    }];
    [self addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imaV.mas_left).offset(-kWidth(10.0));
        make.centerY.equalTo(readImaV);
        make.height.mas_equalTo(kHeight(11.0));
    }];
}

@end
