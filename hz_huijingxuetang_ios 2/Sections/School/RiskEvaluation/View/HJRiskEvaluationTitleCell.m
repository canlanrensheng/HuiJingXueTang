//
//  HJRiskEvaluationTitleCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/21.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJRiskEvaluationTitleCell.h"

@interface HJRiskEvaluationTitleCell ()



@end

@implementation HJRiskEvaluationTitleCell

- (void)hj_configSubViews {
    _titleTextLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",BoldFont(font(14)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
    }];
    [self addSubview:_titleTextLabel];
    [_titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(10.0));
        make.right.equalTo(self).offset(-kWidth(10));
        make.top.equalTo(self);
//        make.height.mas_equalTo(kHeight(45));
    }];
}

@end
