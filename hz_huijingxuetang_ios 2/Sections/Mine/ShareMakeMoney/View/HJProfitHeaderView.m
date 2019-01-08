//
//  HJProfitHeaderView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/23.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJProfitHeaderView.h"

@interface HJProfitHeaderView ()

//上月可提现的金额
@property (nonatomic,strong) UILabel *lastMonthCanWithDrawLabel;
//社区人数
@property (nonatomic,strong) UILabel *commutityNumLabel;
//账户余额
@property (nonatomic,strong) UILabel *accountMoneyLabel;
//保证金
@property (nonatomic,strong) UILabel *depositLabel;
//上月成交单数
@property (nonatomic,strong) UILabel *lastFinishOrderLabel;

@end

@implementation HJProfitHeaderView

- (void)hj_configSubViews {
    self.backgroundColor = white_color;
    UIImageView *topHeaderImageV = [[UIImageView alloc] init];
    topHeaderImageV.image = V_IMAGE(@"背景蓝-1");
    [self addSubview:topHeaderImageV];
    [topHeaderImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(kHeight(220));
    }];
    
    //分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGBA(255, 255, 255, 0.5);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kWidth(1.0), kHeight(65)));
        make.top.equalTo(self).offset(kHeight(57));
    }];
    
    //当前的社区人数
    UILabel *currentAreaCountTextLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"上期可提现",MediumFont(font(13)),RGBA(255, 255, 255, 0.5));
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:currentAreaCountTextLabel];
    [currentAreaCountTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(56));
        make.top.equalTo(lineView).offset(kHeight(6.0));
        make.height.mas_equalTo(kHeight(13));
    }];
    
    //当前人数
    UILabel *currentAreaCountLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"- - 元",MediumFont(font(30)),white_color);
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:currentAreaCountLabel];
    [currentAreaCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(currentAreaCountTextLabel);
        make.top.equalTo(currentAreaCountTextLabel.mas_bottom).offset(kHeight(19));
        make.height.mas_equalTo(kHeight(23));
    }];
    self.lastMonthCanWithDrawLabel = currentAreaCountLabel;
    
    //当前成交单数
    UILabel *finishOrderTextLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"社区人数",MediumFont(font(13)),RGBA(255, 255, 255, 0.5));
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:finishOrderTextLabel];
    [finishOrderTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView.mas_right).offset(kWidth(56));
        make.top.equalTo(lineView).offset(kHeight(6.0));
        make.height.mas_equalTo(kHeight(13));
    }];
    
    //当前人数
    UILabel *finishOrderCountLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" 人",MediumFont(font(30)),white_color);
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:finishOrderCountLabel];
    [finishOrderCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(finishOrderTextLabel);
        make.top.equalTo(finishOrderTextLabel.mas_bottom).offset(kHeight(19));
        make.height.mas_equalTo(kHeight(23));
    }];
    self.commutityNumLabel = finishOrderCountLabel;
    
    //账户的信息
    UIView *accountMessageView = [[UIView alloc] init];
    accountMessageView.backgroundColor = clear_color;
    [self addSubview:accountMessageView];
    [accountMessageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(kHeight(40));
        make.left.right.equalTo(self);
        make.height.mas_equalTo(kHeight(38));
    }];
    
    CGFloat width = Screen_Width / 3;
    CGFloat height = kHeight(100.0);
    NSArray *moneyTextArray = @[@"账户余额（元）",@"保证金（元）",@"本期成交订单（单）"];
    NSArray *moneyArray = @[@"0.00",@"0.00",@"0.00"];
    for(int i = 0 ;i < 3;i++){
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake((width + 1) * i, 0, width, height)];
        backView.tag = i + 10;
        [accountMessageView addSubview:backView];
        
        //账户信息
        UILabel *moneyTextLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(moneyTextArray[i],MediumFont(font(11)),RGBA(255, 255, 255, 0.5));
            label.textAlignment = TextAlignmentCenter;
            [label sizeToFit];
        }];
        [backView addSubview:moneyTextLabel];
        [moneyTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(backView);
            make.top.equalTo(backView);
        }];
        
        //金额
        UILabel *moneyLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(moneyArray[i],MediumFont(font(15)),white_color);
            label.textAlignment = TextAlignmentCenter;
            [label sizeToFit];
        }];
        [backView addSubview:moneyLabel];
        [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(backView);
            make.height.mas_equalTo(kHeight(15));
            make.top.equalTo(moneyTextLabel.mas_bottom).offset(kHeight(13));
        }];
        if (i == 0) {
            self.accountMoneyLabel = moneyLabel;
        } else if (i == 1) {
            self.depositLabel = moneyLabel;
        } else {
            self.lastFinishOrderLabel = moneyLabel;
        }
    }
}

- (void)setModel:(HJPromoteProfitModel *)model {
    _model = model;
    if (model) {
        //上月可提现
        if(model.lastmonthaccount == 0) {
            NSString *lastMonthCanWithDrawMoney = @"- - 元";
            self.lastMonthCanWithDrawLabel.attributedText = [lastMonthCanWithDrawMoney attributeWithStr:@"元" color:white_color font:MediumFont(font(10))];
        } else {
            NSString *lastMonthCanWithDrawMoney = [NSString stringWithFormat:@"%.2f 元",model.lastmonthaccount];
            self.lastMonthCanWithDrawLabel.attributedText = [lastMonthCanWithDrawMoney attributeWithStr:@"元" color:white_color font:MediumFont(font(10))];
        }
        
        //社区人数
        NSString *lastMonthCanWithDrawMoney = [NSString stringWithFormat:@"%ld 人",model.commCount];
        self.commutityNumLabel.attributedText = [lastMonthCanWithDrawMoney attributeWithStr:@"人" color:white_color font:MediumFont(font(10))];
        
        //账户余额
        self.accountMoneyLabel.text = [NSString stringWithFormat:@"%.2f",model.canWithedSum];
        
        //保证金
        self.depositLabel.text = [NSString stringWithFormat:@"%.2f",model.freezingsum];
        
        //上月成交单数
        self.lastFinishOrderLabel.text = [NSString stringWithFormat:@"%ld",model.orderCount];
        
    }
}

@end
