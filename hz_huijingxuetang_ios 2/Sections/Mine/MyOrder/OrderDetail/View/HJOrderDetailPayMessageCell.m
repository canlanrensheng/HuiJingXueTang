//
//  HJOrderDetailPayMessageCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/8.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJOrderDetailPayMessageCell.h"

@interface HJOrderDetailPayMessageCell ()

@property (nonatomic,strong) UILabel *payTypeLabel;
@property (nonatomic,strong) UILabel *goodStaticsLabel;
@property (nonatomic,strong) UILabel *quanLabel;
@property (nonatomic,strong) UILabel *priceLabel;

@end

@implementation HJOrderDetailPayMessageCell

- (void)hj_configSubViews {
    self.backgroundColor = Background_Color;
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = white_color;
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(kHeight(107));
    }];
    
    //支付方式
    UILabel *payTypeTextLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"支付方式：",MediumFont(font(11)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [topView addSubview:payTypeTextLabel];
    [payTypeTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(topView).offset(kWidth(10.0));
        make.height.mas_equalTo(kHeight(11.0));
    }];
    
    UILabel *payTypeLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",MediumFont(font(11)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentRight;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [topView addSubview:payTypeLabel];
    [payTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(payTypeTextLabel);
        make.right.equalTo(topView).offset(-kWidth(218));
        make.height.mas_equalTo(kHeight(11.0));
    }];
    self.payTypeLabel = payTypeLabel;
    
    //商品统计
    UILabel *goodStaticsTextLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"商品合计：",MediumFont(font(11)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [topView addSubview:goodStaticsTextLabel];
    [goodStaticsTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(payTypeTextLabel.mas_bottom).offset(kHeight(6.0));
        make.left.equalTo(topView).offset(kWidth(10.0));
        make.height.mas_equalTo(kHeight(11.0));
    }];
    
    UILabel *goodStaticsLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",MediumFont(font(11)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentRight;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [topView addSubview:goodStaticsLabel];
    [goodStaticsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(goodStaticsTextLabel);
        make.right.equalTo(topView).offset(-kWidth(218));
        make.height.mas_equalTo(kHeight(11.0));
    }];
    self.goodStaticsLabel = goodStaticsLabel;
    
    //优惠券抵扣
    UILabel *quanTextLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"优惠券抵扣：",MediumFont(font(11)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [topView addSubview:quanTextLabel];
    [quanTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goodStaticsTextLabel.mas_bottom).offset(kHeight(6.0));
        make.left.equalTo(topView).offset(kWidth(10.0));
        make.height.mas_equalTo(kHeight(11.0));
    }];
    
    UILabel *quanLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",MediumFont(font(11)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentRight;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [topView addSubview:quanLabel];
    [quanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(quanTextLabel);
        make.right.equalTo(topView).offset(-kWidth(218));
        make.height.mas_equalTo(kHeight(11.0));
    }];
    self.quanLabel = quanLabel;
    
    //分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = HEXColor(@"#EAEAEA");
    [topView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.left.equalTo(self).offset(kWidth(10.0));
        make.height.mas_equalTo(kHeight(0.5));
        make.top.equalTo(quanTextLabel.mas_bottom).offset(kHeight(10.0));
    }];
    
    UIView *bottomView = [[UIView alloc] init];
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(topView);
        make.top.equalTo(lineView.mas_bottom);
    }];
    
    //实际付款
    UILabel *priceTextLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"实付：",MediumFont(font(13)),HEXColor(@"#FF4400"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [bottomView addSubview:priceTextLabel];
    [priceTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView);
        make.left.equalTo(topView).offset(kWidth(10.0));
        make.height.mas_equalTo(kHeight(13.0));
    }];
    
    UILabel *priceLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",MediumFont(font(13)),HEXColor(@"#FF4400"));
        label.textAlignment = NSTextAlignmentRight;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [bottomView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView);
        make.right.equalTo(topView).offset(-kWidth(218));
        make.height.mas_equalTo(kHeight(10.0));
    }];
    self.priceLabel = priceLabel;
    
}

- (void)setModel:(HJMyOrderListModel *)model {
    _model = model;
    NSString *payTypeString = @"等待支付";
    if(model.paytype.integerValue == 1) {
        payTypeString = @"支付宝";
    } else if(model.paytype.integerValue == 2) {
        payTypeString = @"微信";
    } else if(model.paytype.integerValue == 3) {
        payTypeString = @"线下打款";
    }
    self.payTypeLabel.text = [NSString stringWithFormat:@"%@",payTypeString];
    self.goodStaticsLabel.text = [NSString stringWithFormat:@"￥%.2f",model.origintotalmoney];
    self.quanLabel.text = [NSString stringWithFormat:@"-¥%.2f",model.price.floatValue];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",model.money];
    
}


@end
