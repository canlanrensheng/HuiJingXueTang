//
//  HJSearchResultTeacherCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/26.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSearchResultTeacherCell.h"

@implementation HJSearchResultTeacherCell

- (void)hj_configSubViews {
    self.backgroundColor = white_color;

    //头像
    UIImageView *iconImageV = [[UIImageView alloc] init];
    iconImageV.image = V_IMAGE(@"默认头像");
    iconImageV.backgroundColor = Background_Color;
    [self addSubview:iconImageV];
    [iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(10.0));
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(kHeight(60));
    }];
    [iconImageV clipWithCornerRadius:kHeight(30.0) borderColor:nil borderWidth:0];
    //昵称
    UILabel *nameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"何晶莹",BoldFont(font(13)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageV).offset(kHeight(5.0));
        make.height.mas_equalTo(kHeight(13));
        make.left.equalTo(iconImageV.mas_right).offset(kWidth(10.0));
    }];

    //工作
    UILabel *jobLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"慧鲸特邀专家",MediumFont(font(11)),HEXColor(@"#666666"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:jobLabel];
    [jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(kHeight(7.0));
        make.height.mas_equalTo(kHeight(11));
        make.left.equalTo(iconImageV.mas_right).offset(kWidth(10.0));
    }];

    //功课和学员数量
    UILabel *studentCountLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"4门课程 1900名学员",MediumFont(font(11)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:studentCountLabel];
    [studentCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(jobLabel.mas_bottom).offset(kHeight(10.0));
        make.height.mas_equalTo(kHeight(11));
        make.left.equalTo(iconImageV.mas_right).offset(kWidth(10.0));
    }];
}

@end
