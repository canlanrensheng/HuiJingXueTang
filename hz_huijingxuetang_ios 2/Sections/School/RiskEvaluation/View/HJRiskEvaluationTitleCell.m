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
        label.ljTitle_font_textColor(@"最近您的家庭预计进行证券投资的资金占家庭现有资产(不含自住，自用房产及汽车等固定资产)的比例是",BoldFont(font(15)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
    }];
    [self addSubview:_titleTextLabel];
    [_titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(10.0));
        make.right.equalTo(self).offset(-kWidth(10));
        make.top.equalTo(self);
        make.height.mas_equalTo(kHeight(45));
    }];
}

@end
