//
//  HJEvaluationSingleCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/25.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJEvaluationSingleCell.h"

@implementation HJEvaluationSingleCell

- (void)hj_configSubViews {
    //图片
    UIImageView *imaV = [[UIImageView alloc] init];
    imaV.image = V_IMAGE(@"默认头像");
//    [imaV sd_setImageWithURL:nil placeholderImage:V_IMAGE(@"占位图")];
    imaV.backgroundColor = Background_Color;
    [self addSubview:imaV];
    [imaV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kHeight(13.0));
        make.left.equalTo(self).offset(kWidth(10.0));
        make.width.mas_equalTo(kWidth(45));
        make.height.mas_equalTo(kHeight(45));
    }];
    [imaV clipWithCornerRadius:kHeight(22.5) borderColor:nil borderWidth:0];
    
    //名称
    UILabel *nameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"明天会更好",MediumFont(font(11)),HEXColor(@"#666666"));
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imaV).offset(kHeight(8.0));
        make.left.equalTo(imaV.mas_right).offset(kWidth(10.0));
        make.height.mas_equalTo(kHeight(11.0));
    }];
    
    //时间
    UILabel *timeLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"8月24日",MediumFont(font(11)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentRight;
        [label sizeToFit];
    }];
    [self addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameLabel);
        make.right.equalTo(self).offset(-kWidth(10.0));
        make.height.mas_equalTo(kHeight(10.0));
    }];
    
    //星级
    UIView *starView = [[UIView alloc] init];
    starView.backgroundColor = white_color;
    [self addSubview:starView];
    CGFloat totalWidth = kWidth(11) * 5 + kWidth(2.0) * 4;
    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.top.equalTo(nameLabel.mas_bottom).offset(kHeight(8.0));
        make.height.mas_equalTo(kHeight(11));
        make.width.mas_equalTo(kWidth(totalWidth));
    }];
    
    for(int i = 0; i < 5;i++) {
        UIImageView *starImageView = [[UIImageView alloc] init];
        starImageView.frame = CGRectMake((kWidth(2 + 11) * i), 0, kWidth(11), kWidth(11));
        starImageView.backgroundColor = white_color;
        starImageView.image = V_IMAGE(@"评价星星");
        [starView addSubview:starImageView];
    }
    
    //星级Label
    UILabel *starCountLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"5.0",MediumFont(font(11)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [self addSubview:starCountLabel];
    [starCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(starView);
        make.left.equalTo(starView.mas_right).offset(kWidth(6.0));
        make.height.mas_equalTo(kHeight(9.0));
    }];
    
    //描述
    UILabel *desLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"看了老师的课之后受益匪浅，很欣赏老师的讲课方式，很幽默也很有意思，希望老师以后能够多多出新的课程带我装逼带我飞。",MediumFont(font(13)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:desLabel];
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-kWidth(10.0));
        make.top.equalTo(starView.mas_bottom).offset(kHeight(13.0));
        make.left.equalTo(nameLabel);
    }];
    
}

@end
