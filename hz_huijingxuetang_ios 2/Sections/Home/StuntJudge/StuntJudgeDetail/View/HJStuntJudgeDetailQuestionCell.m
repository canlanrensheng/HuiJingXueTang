//
//  HJStuntJudgeDetailQuestionCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/29.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJStuntJudgeDetailQuestionCell.h"

@interface HJStuntJudgeDetailQuestionCell ()

@property (nonatomic,strong) UIImageView *iconImageV;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) UILabel *desLabel;

@end

@implementation HJStuntJudgeDetailQuestionCell

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
        button.ljTitle_font_titleColor_state(@"问",MediumFont(font(10)),white_color,0);
        [button setBackgroundImage:V_IMAGE(@"问标签") forState:UIControlStateNormal
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
        label.ljTitle_font_textColor(@"中原环保（000554）求帮忙分析一下这只股票的好坏K线图看不懂？",BoldFont(font(15)),HEXColor(@"#333333"));
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
    [self.iconImageV sd_setImageWithURL:URL(model.createiconurl) placeholderImage:V_IMAGE(@"默认头像")];
    self.nameLabel.text = model.updatename.length > 0 ? model.updatename : @"咨询用户";
    if (model.createtime) {
        self.dateLabel.text = [model.createtime componentsSeparatedByString:@" "].firstObject;
    } else {
        self.dateLabel.text = @" ";
    }
    
//    self.desLabel.text = [NSString stringWithFormat:@"%@ %@",model.questiontitle,model.questiondes];
    NSString *question = [NSString stringWithFormat:@"%@ %@",model.questiontitle,model.questiondes];
    self.desLabel.attributedText = [question fuWenBenWithStr:model.questiontitle withColor:HEXColor(@"#22476B") withFont:BoldFont(font(14))];
}

@end
