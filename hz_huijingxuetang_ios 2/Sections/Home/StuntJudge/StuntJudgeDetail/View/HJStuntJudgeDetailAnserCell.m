//
//  HJStuntJudgeDetailAnserCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/29.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJStuntJudgeDetailAnserCell.h"

@interface HJStuntJudgeDetailAnserCell ()

@property (nonatomic,strong) UIImageView *iconImageV;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) UILabel *desLabel;

@end

@implementation HJStuntJudgeDetailAnserCell

- (void)hj_configSubViews {
    //头像
    UIImageView *iconImageV = [[UIImageView alloc] init];
    iconImageV.image = V_IMAGE(@"默认头像");
    iconImageV.backgroundColor = Background_Color;
    [self addSubview:iconImageV];
    [iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(10.0));
        make.top.equalTo(self).offset(kHeight(15.0));
        make.width.height.mas_equalTo(kHeight(30));
    }];
    [iconImageV clipWithCornerRadius:kHeight(15.0) borderColor:nil borderWidth:0];
    
    //昵称
    UILabel *nameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"咨询用户",MediumFont(font(13)),HEXColor(@"#666666"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageV);
        make.height.mas_equalTo(kHeight(13));
        make.left.equalTo(iconImageV.mas_right).offset(kWidth(10.0));
    }];
    
    UIButton *wenBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"答",MediumFont(font(10)),white_color,0);
        [button setBackgroundImage:V_IMAGE(@"答标签") forState:UIControlStateNormal
         ];
    }];
    [self addSubview:wenBtn];
    [wenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self).offset(kHeight(21.0));
    }];
    
    //日期
    UILabel *dateLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"2018/08/29",MediumFont(font(11)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(kHeight(5.0));
        make.height.mas_equalTo(kHeight(11));
        make.left.equalTo(iconImageV.mas_right).offset(kWidth(10.0));
    }];
    
    //问题描述
    UILabel *questionLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"股价均线下降，空头行情中相对走势较弱。中短线看继续调整，均线具有稳定性，是因为它的计算公式是算术平均，所以在偶尔的高价或低价出现时，它不会出现过于明显的变化，除非这些高价或低价连续出现。均线不会因为少数几天的大幅变动而改变原有的趋势，这就说明均线有很好的容错性和稳定性。这也是为什么很多投资者都喜欢使用均线指标的原因。",MediumFont(font(13)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:questionLabel];
    [questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dateLabel.mas_bottom).offset(kHeight(17.0));
        make.left.equalTo(iconImageV);
        make.right.equalTo(self).offset(-kWidth(10.0));
    }];
    
    self.iconImageV = iconImageV;
    self.nameLabel = nameLabel;
    self.dateLabel = dateLabel;
    self.desLabel = questionLabel;
    
}

- (void)setModel:(HJStuntJudgeListModel *)model {
    [self.iconImageV sd_setImageWithURL:URL(model.updateiconurl) placeholderImage:V_IMAGE(@"默认头像")];
    self.nameLabel.text = model.updatename.length > 0 ? model.updatename : @"咨询用户";
    if (model.answertime) {
        self.dateLabel.text = [model.answertime componentsSeparatedByString:@" "].firstObject;
    } else {
        self.dateLabel.text = @" ";
    }
    
    self.desLabel.text = model.answer.length > 0 ? model.answer : @" ";
    
}

@end