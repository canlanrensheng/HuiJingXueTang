//
//  HJWatchHistoryVideoCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/9.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJWatchHistoryVideoCell.h"

@implementation HJWatchHistoryVideoCell

- (void)hj_configSubViews {
    //图片
    UIImageView *imaV = [[UIImageView alloc] init];
    imaV.image = V_IMAGE(@"占位图");
    //    [imaV sd_setImageWithURL:URL(model.coursepic) placeholderImage:V_IMAGE(@"占位图")];
    imaV.backgroundColor = Background_Color;
    imaV.userInteractionEnabled = YES;
    [self addSubview:imaV];
    [imaV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(kWidth(10.0));
        make.width.mas_equalTo(kWidth(127));
        make.height.mas_equalTo(kHeight(70));
    }];
    [imaV clipWithCornerRadius:kHeight(2.5) borderColor:nil borderWidth:0];
    
    self.imaV = imaV;
    
    //名称
    UILabel *nameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"重温经典系列之新K线战法",BoldFont(font(13)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imaV).offset(kHeight(5.0));
        make.left.equalTo(imaV.mas_right).offset(kWidth(10.0));
        make.height.mas_equalTo(kHeight(13.0));
    }];
    
    self.nameLabel = nameLabel;
    
    //讲师
    UILabel *teacherLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"120:00",MediumFont(font(10)),white_color);
        label.backgroundColor = HEXColor(@"#CCCCCC");
        label.textAlignment = NSTextAlignmentCenter;
        [label sizeToFit];
    }];
    [self addSubview:teacherLabel];
    [teacherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(kHeight(8.0));
        make.left.equalTo(nameLabel);
        make.width.mas_offset(kWidth(40.0));
        make.height.mas_equalTo(kHeight(13.0));
    }];
    [teacherLabel clipWithCornerRadius:kHeight(2.5) borderColor:nil borderWidth:0];
    
    self.totalTimeLabel = teacherLabel;
    
    //天数
    UILabel *dayLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"讲师：金建",MediumFont(font(11)),HEXColor(@"#666666"));
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [self addSubview:dayLabel];
    [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.bottom.equalTo(imaV).offset(-kHeight(5.0));
        make.height.mas_equalTo(kHeight(11.0));
    }];
    self.teacherNameLabel = dayLabel;
    
    //时间
    UILabel *timeLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"7小时前",MediumFont(font(11)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentRight;
        [label sizeToFit];
    }];
    [self addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(dayLabel);
        make.right.equalTo(self).offset(-kWidth(10.0));
        make.height.mas_equalTo(kHeight(11.0));
    }];
    self.timeLabel = timeLabel;
}

@end
