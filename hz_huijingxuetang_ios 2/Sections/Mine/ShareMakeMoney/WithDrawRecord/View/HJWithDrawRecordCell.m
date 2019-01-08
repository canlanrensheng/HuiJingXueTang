//
//  HJWithDrawRecordCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/23.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJWithDrawRecordCell.h"
#import "HJWithDrawRecordViewModel.h"
#import "HJWithDrawRacordModel.h"

@interface HJWithDrawRecordCell ()

@property (nonatomic,strong) UIImageView *payImageV;
@property (nonatomic,strong) UILabel *payTypeLabel;
@property (nonatomic,strong) UILabel *payNameLabel;
@property (nonatomic,strong) UILabel *incomeLabel;
@property (nonatomic,strong) UILabel *dateLabel;

@end

@implementation HJWithDrawRecordCell

- (void)hj_configSubViews {
    self.backgroundColor = Background_Color;
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = white_color;
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(kWidth(10));
        make.right.equalTo(self).offset(-kWidth(10));
        make.height.mas_equalTo(kHeight(110));
    }];
    
    [topView clipWithCornerRadius:kHeight(5.0) borderColor:nil borderWidth:0];
    
    UIImageView *payImageV = [[UIImageView alloc] init];
    payImageV.image = V_IMAGE(@"支付宝1");
    [topView addSubview:payImageV];
    [payImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(topView).offset(kWidth(20));
        make.size.mas_equalTo(CGSizeMake(kWidth(39), kHeight(39)));
    }];
    self.payImageV = payImageV;
    

    //提现类型名称
    UILabel *payTypeLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",MediumFont(font(15)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [topView addSubview:payTypeLabel];
    [payTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(payImageV).offset(kHeight(4.0));
        make.left.equalTo(payImageV.mas_right).offset(kWidth(10.0));
        make.height.mas_equalTo(kHeight(14));
    }];
    self.payTypeLabel = payTypeLabel;
    
    //支付宝名称
    UILabel *payNameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",MediumFont(font(11)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [topView addSubview:payNameLabel];
    [payNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(payTypeLabel.mas_bottom).offset(kHeight(7));
        make.left.equalTo(payTypeLabel);
        make.height.mas_equalTo(kHeight(11));
    }];
    self.payNameLabel = payNameLabel;

    //收入金额
    UILabel *incomeLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"+0 RMB",BoldFont(font(17)),HEXColor(@"#22476B"));
        label.textAlignment = NSTextAlignmentRight;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [topView addSubview:incomeLabel];
    [incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView).offset(kHeight(33));
        make.right.equalTo(topView).offset(-kWidth(20.0));
        make.height.mas_equalTo(kHeight(13));
    }];
    self.incomeLabel = incomeLabel;

    //分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = Line_Color;
    [topView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(topView);
        make.height.mas_equalTo(kHeight(0.5));
        make.top.equalTo(payImageV.mas_bottom).offset(kHeight(20));
    }];
    
    //提现时间
    UILabel *dateLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"提现时间 ",MediumFont(font(10)),HEXColor(@"#666666"));
        label.textAlignment = NSTextAlignmentRight;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [topView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(kHeight(10));
        make.right.equalTo(topView).offset(-kWidth(20.0));
        make.height.mas_equalTo(kHeight(10));
    }];
    self.dateLabel = dateLabel;
}

- (void)setViewModel:(BaseViewModel *)viewModel indexPath:(NSIndexPath *)indexPath {
    HJWithDrawRecordViewModel *listViewModel = (HJWithDrawRecordViewModel *)viewModel;
    HJWithDrawRacordModel *model = listViewModel.withDrawRecordListArray[indexPath.row];
    if (model.withdrawtype == 1) {
        //支付宝
        self.payImageV.image = V_IMAGE(@"支付宝1");
        self.payTypeLabel.text = @"支付宝";
        
    } else {
        //微信
        self.payImageV.image = V_IMAGE(@"微信支付1");
        self.payTypeLabel.text = @"微信";
    }
    self.incomeLabel.text = [NSString stringWithFormat:@"+%.2f RMB",model.money];
    NSDate *date = [NSDate dateWithString:model.withdrawtime formatString:@"yyyy-MM-dd HH:mm:ss"];
    self.dateLabel.text = [NSString stringWithFormat:@"提现时间 %ld-%@-%@  %@:%@",date.year,[NSString convertDateSingleData:date.month],[NSString convertDateSingleData:date.day],[NSString convertDateSingleData:date.hour],[NSString convertDateSingleData:date.minute]];
    self.payNameLabel.text = model.accountname;
}

@end
