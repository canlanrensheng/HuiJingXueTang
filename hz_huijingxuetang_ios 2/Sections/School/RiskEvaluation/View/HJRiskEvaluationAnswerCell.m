//
//  HJRiskEvaluationAnswerCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/21.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJRiskEvaluationAnswerCell.h"

@interface HJRiskEvaluationAnswerCell ()



@end

@implementation HJRiskEvaluationAnswerCell

- (void)hj_configSubViews {
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = HEXColor(@"#F5F5F5");
    [self addSubview:backView];
    [backView clipWithCornerRadius:kHeight(5.0) borderColor:nil borderWidth:0];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(10.0));
        make.right.equalTo(self).offset(-kWidth(10));
        make.top.equalTo(self);
        make.height.mas_equalTo(kHeight(40));
    }];
    self.backView = backView;
    _titleTextLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",MediumFont(font(11)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [backView addSubview:_titleTextLabel];
    [_titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(kWidth(10.0));
        make.right.equalTo(backView).offset(-kWidth(10));
        make.centerY.equalTo(backView);
        make.height.mas_equalTo(kHeight(40));
    }];
}

- (void)setModel:(Answer *)model {
    _model = model;
    self.titleTextLabel.text = [NSString stringWithFormat:@"%@",model.answername];
    [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(10.0));
        make.right.equalTo(self).offset(-kWidth(10));
        make.top.equalTo(self);
        make.height.mas_equalTo(model.answerCellHeight);
    }];
    
    [_titleTextLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).offset(kWidth(10.0));
        make.right.equalTo(self.backView).offset(-kWidth(10));
        make.centerY.equalTo(self.backView);
        make.height.mas_equalTo(model.answerCellHeight - kHeight(28));
    }];
}

@end
