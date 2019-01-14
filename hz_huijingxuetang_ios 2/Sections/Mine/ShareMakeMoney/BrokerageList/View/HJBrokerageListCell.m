//
//  HJBrokerageListCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/23.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJBrokerageListCell.h"
#import "HJBrokerageListViewModel.h"
#import "HJBrokerageListModel.h"

@interface HJBrokerageListCell ()

@property (nonatomic,strong) UILabel *monthLabel;
@property (nonatomic,strong) UILabel *incomeLabel;
@property (nonatomic,strong) UILabel *freezeMoneyLabel;
@property (nonatomic,strong) UILabel *finishDateLabel;

@end

@implementation HJBrokerageListCell

- (void)hj_configSubViews {
    self.backgroundColor = Background_Color;
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = white_color;
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(kWidth(10));
        make.right.equalTo(self).offset(-kWidth(10));
        make.height.mas_equalTo(kHeight(110.0));
    }];
    
    [topView clipWithCornerRadius:kHeight(5.0) borderColor:nil borderWidth:0];
    
    //月份
    UILabel *monthLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"03期/12月",BoldFont(font(15)),HEXColor(@"#22476B"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [topView addSubview:monthLabel];
    [monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView).offset(kHeight(20));
        make.left.equalTo(topView).offset(kWidth(10.0));
        make.height.mas_equalTo(kHeight(14));
    }];
    
    self.monthLabel = monthLabel;
    
    
    //佣金收入
    UILabel *incomeLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"佣金总额  ￥0",MediumFont(font(13)),HEXColor(@"#666666"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [topView addSubview:incomeLabel];
    [incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(monthLabel.mas_bottom).offset(kHeight(12));
        make.left.equalTo(topView).offset(kWidth(10.0));
        make.height.mas_equalTo(kHeight(13));
    }];
    
    self.incomeLabel = incomeLabel;
    
    //冻结金额
    UILabel *freezeMoneyLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"冻结金  ￥0",MediumFont(font(13)),HEXColor(@"#666666"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [topView addSubview:freezeMoneyLabel];
    [freezeMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(incomeLabel);
        make.left.equalTo(incomeLabel.mas_right).offset(kWidth(15.0));
        make.height.mas_equalTo(kHeight(13));
    }];
    
    self.freezeMoneyLabel = freezeMoneyLabel;
    
    //图片
    UIImageView *detailImageV = [[UIImageView alloc] init];
    detailImageV.image = V_IMAGE(@"详情按钮");
    [self addSubview:detailImageV];
    [detailImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.right.equalTo(topView).offset(-kWidth(10.0));
    }];
    
    //分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = HEXColor(@"#EAEAEA");
    [topView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(topView);
        make.height.mas_equalTo(kHeight(1.0));
        make.top.equalTo(incomeLabel.mas_bottom).offset(kHeight(20));
    }];
    
    //完成的日期
    UILabel *finishDateLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"2018.12.17-2018.12.23",MediumFont(font(10)),HEXColor(@"#666666"));
        label.textAlignment = NSTextAlignmentRight;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [topView addSubview:finishDateLabel];
    [finishDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(kHeight(12.0));
        make.right.equalTo(topView).offset(-kWidth(10.0));
        make.height.mas_equalTo(kHeight(10.0));
    }];
    
    self.finishDateLabel = finishDateLabel;
    
}

- (void)setViewModel:(BaseViewModel *)viewModel indexPath:(NSIndexPath *)indexPath {
    HJBrokerageListViewModel *listViewModel = (HJBrokerageListViewModel *)viewModel;
    HJBrokerageListModel *model = listViewModel.brokerageListArray[indexPath.row];

    //日期
    if(model.datadaterange) {
        NSString *month = [model.datadaterange substringWithRange:NSMakeRange(4, 2)];;
        NSString *qi = [model.datadaterange substringFromIndex:6];
        NSString *dateString = [NSString stringWithFormat:@"%@期/%@月",qi,month];
        self.monthLabel.attributedText = [dateString attributeWithStr:[NSString stringWithFormat:@"/%@月",month] color:HEXColor(@"#22476B") font:BoldFont(font(10.0))];
    }

    //佣金收入
    NSString *brokerage = [NSString stringWithFormat:@"佣金总额  ￥%.2f",model.commissionmoney];
    self.incomeLabel.attributedText = [brokerage attributeWithStr:[NSString stringWithFormat:@"￥%.2f",model.commissionmoney] color:HEXColor(@"#FF4400") font:BoldFont(font(13))];

    //冻结金额
    NSString *freezeMoneyfree = [NSString stringWithFormat:@"冻结金  ￥%.2f",model.freezingamount];
    self.freezeMoneyLabel.attributedText = [freezeMoneyfree attributeWithStr:[NSString stringWithFormat:@"￥%.2f",model.freezingamount] color:HEXColor(@"#FF4400") font:BoldFont(font(13))];

    self.finishDateLabel.text = model.cycletime;
    
}

@end
