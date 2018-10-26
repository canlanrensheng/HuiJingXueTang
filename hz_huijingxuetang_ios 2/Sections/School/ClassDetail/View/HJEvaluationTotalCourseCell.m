//
//  HJEvaluationTotalCourseCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/25.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJEvaluationTotalCourseCell.h"

@implementation HJEvaluationTotalCourseCell

- (void)hj_configSubViews {
    UILabel *teacherInfoLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"讲师简介",BoldFont(font(15)),HEXColor(@"#22476B"));
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:teacherInfoLabel];
    [teacherInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kHeight(23.0));
        make.height.mas_equalTo(kHeight(14));
        make.left.equalTo(self).offset(kWidth(10.0));
    }];
    
    //星级
    UIView *starView = [[UIView alloc] init];
    starView.backgroundColor = white_color;
    [self addSubview:starView];
    CGFloat totalWidth = kWidth(14) * 5 + kWidth(2.0) * 4;
    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(teacherInfoLabel);
        make.top.equalTo(teacherInfoLabel.mas_bottom).offset(kHeight(7.0));
        make.height.mas_equalTo(kHeight(14));
        make.width.mas_equalTo(kWidth(totalWidth));
    }];
    
    for(int i = 0; i < 5;i++) {
        UIImageView *starImageView = [[UIImageView alloc] init];
        starImageView.frame = CGRectMake((kWidth(2 + 14) * i), 0, kWidth(14), kWidth(14));
        starImageView.backgroundColor = white_color;
        starImageView.image = V_IMAGE(@"评价星星");
        [starView addSubview:starImageView];
    }
    
    //星星的数量
    UILabel *starCountLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"5.0",MediumFont(font(13)),HEXColor(@"#666666"));
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:starCountLabel];
    [starCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(starView);
        make.height.mas_equalTo(kHeight(9.0));
        make.left.equalTo(starView.mas_right).offset(kWidth(6.0));
    }];
    
    //评价的总数量
    UILabel *judgeCountLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"180条评价",MediumFont(font(13)),HEXColor(@"#666666"));
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:judgeCountLabel];
    [judgeCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(starView);
        make.height.mas_equalTo(kHeight(912.0));
        make.right.equalTo(self).offset(-kWidth(10.0));
    }];
}

@end
