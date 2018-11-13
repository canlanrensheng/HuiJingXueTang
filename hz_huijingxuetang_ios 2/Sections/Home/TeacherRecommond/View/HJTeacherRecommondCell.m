//
//  HJTeacherRecommondCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/8.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJTeacherRecommondCell.h"

@implementation HJTeacherRecommondCell

- (void)hj_configSubViews {
    self.backgroundColor = HEXColor(@"0xf5f5f5");
    //背景试图
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = white_color;
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(kWidth(10));
        make.right.equalTo(self).offset(-kWidth(10));
        make.height.mas_equalTo(kHeight(90));
    }];
    backView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1].CGColor;
    backView.layer.shadowOffset = CGSizeMake(0,2);
    backView.layer.shadowOpacity = 1;
    backView.layer.shadowRadius = kHeight(8.0);
    backView.layer.cornerRadius = kHeight(5.0);
    backView.clipsToBounds = YES;
    
    UIImageView *liveImageV = [[UIImageView alloc] init];
    liveImageV.image = V_IMAGE(@"占位图");
    [backView addSubview:liveImageV];
    [liveImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(kWidth(10));
        make.centerY.equalTo(backView);
        make.size.mas_equalTo(CGSizeMake(kWidth(60), kHeight(60)));
    }];
    [liveImageV clipWithCornerRadius:kHeight(30.0) borderColor:nil borderWidth:0.0];
    
    //标题
    UILabel *titleTextLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"何晶莹",MediumFont(font(13)),HEXColor(@"#333333"));
        label.textAlignment = TextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [backView addSubview:titleTextLabel];
    [titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(liveImageV).offset(kHeight(5.0));
        make.left.equalTo(liveImageV.mas_right).offset(kWidth(10.0));
        make.height.mas_equalTo(kHeight(13));
    }];
    
    //描述
    UILabel *desTextLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"慧鲸特邀专家",MediumFont(font(11)),HEXColor(@"#666666"));
        label.textAlignment = TextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [backView addSubview:desTextLabel];
    [desTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleTextLabel.mas_bottom).offset(kHeight(7.0));
        make.left.equalTo(titleTextLabel);
        make.height.mas_equalTo(kHeight(11));
    }];
    
    //详情信息的数据
    UILabel *detailTextLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"4门课程 | 1900名学员",MediumFont(font(11)),HEXColor(@"#999999"));
        label.textAlignment = TextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [backView addSubview:detailTextLabel];
    [detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(desTextLabel.mas_bottom).offset(kHeight(10.0));
        make.left.equalTo(titleTextLabel);
        make.height.mas_equalTo(kHeight(11));
    }];
    
    //箭头
    UIImageView *arrowImageV = [[UIImageView alloc] init];
    arrowImageV.image = V_IMAGE(@"形状 8371");
    [backView addSubview:arrowImageV];
    [arrowImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView).offset(-kWidth(10));
        make.centerY.equalTo(backView);
    }];
    
}

@end
