//
//  HJMyShareCommunityDetailCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/28.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJMyShareCommunityDetailCell.h"
#import "HJMyShareCommunityDetailViewModel.h"
#import "HJMyShareCommunityDetailModel.h"

@interface HJMyShareCommunityDetailCell()

@property (nonatomic,strong) UILabel *courseNameLabel;
@property (nonatomic,strong) UILabel *moneyLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *phoneLabel;

@end

@implementation HJMyShareCommunityDetailCell

- (void)hj_configSubViews {
    //课程的名称
    UILabel *courseNameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",MediumFont(font(11)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 1;
        [label sizeToFit];
    }];
    [self addSubview:courseNameLabel];
    [courseNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(10));
        make.centerY.equalTo(self);
        make.height.equalTo(self);
        make.width.mas_equalTo((Screen_Width - kWidth(20.0)) / 4);
    }];
    
    self.courseNameLabel = courseNameLabel;
    //单价
    UILabel *moneyLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",MediumFont(font(11)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 1;
        [label sizeToFit];
    }];
    [self addSubview:moneyLabel];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.height.equalTo(self);
        make.width.mas_equalTo((Screen_Width - kWidth(20.0)) / 4);
        make.left.equalTo(courseNameLabel.mas_right);
    }];
    self.moneyLabel = moneyLabel;
    
    //时间
    UILabel *timeLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",MediumFont(font(11)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 1;
        [label sizeToFit];
    }];
    [self addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.height.equalTo(self);
        make.width.mas_equalTo((Screen_Width - kWidth(20.0)) / 4);
        make.left.equalTo(moneyLabel.mas_right);
    }];
    self.timeLabel = timeLabel;
    
    //手机号
    UILabel * phoneLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",MediumFont(font(11)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentRight;
        label.numberOfLines = 1;
        [label sizeToFit];
    }];
    [self addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self).offset(-kWidth(10));
        make.height.equalTo(self);
        make.left.equalTo(timeLabel.mas_right);
    }];
    
    self.phoneLabel = phoneLabel;
}

- (void)setViewModel:(BaseViewModel *)viewModel indexPath:(NSIndexPath *)indexPath {
    HJMyShareCommunityDetailViewModel *listViewModel = (HJMyShareCommunityDetailViewModel *)viewModel;
    HJMyShareCommunityDetailModel *model = listViewModel.communityDetailDataArray[indexPath.row];
    self.courseNameLabel.text = model.coursename;
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",model.coursemoney];
    self.timeLabel.text = [model.paytime componentsSeparatedByString:@" "].firstObject;
    self.phoneLabel.text = model.telno;
}

@end

