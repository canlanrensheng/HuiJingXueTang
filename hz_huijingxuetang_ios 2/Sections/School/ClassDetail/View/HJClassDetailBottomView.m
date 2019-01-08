//
//  HJClassDetailBottomView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/25.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJClassDetailBottomView.h"

@implementation HJClassDetailBottomView

- (void)hj_configSubViews {
    self.backgroundColor = white_color;
    //购物车按钮
//    HJPicAndTextButton *shopCarButton = [HJPicAndTextButton buttonWithType:UIButtonTypeCustom withSpace:kHeight(10.0)];
//    shopCarButton.buttonStyle = ButtonImageTop;
//    [shopCarButton setImage:V_IMAGE(@"加入购物车") forState:UIControlStateNormal];
//    [shopCarButton setImage:V_IMAGE(@"已添加购物车") forState:UIControlStateSelected];
//    [shopCarButton setTitle:@"购物车" forState:UIControlStateNormal];
//    [shopCarButton setTitle:@"已添加" forState:UIControlStateSelected];
//    [shopCarButton setTitleColor:HEXColor(@"#22476B") forState:UIControlStateNormal];
//    [shopCarButton setTitleColor:HEXColor(@"#999999") forState:UIControlStateSelected];
//    shopCarButton.titleLabel.font = MediumFont(font(10));
//    [shopCarButton addTarget:self action:@selector(carBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    HJTextAndPicButoton *shopCarButton = [[HJTextAndPicButoton alloc] initWithFrame:CGRectMake(0, 0, kWidth(60.0), kHeight(35.0)) type:HJTextAndPicButotonTypePicTop picSize:CGSizeMake(kWidth(22.0), kHeight(20.0)) textSize:CGSizeMake(60, 10) space:kHeight(5.0) picName:@"加入购物车" selctPicName:@"已添加购物车" text:@"购物车" selectText:@"已添加"  textColor:HEXColor(@"#22476B") selectTextColor:HEXColor(@"#999999") font:MediumFont(font(10)) selectFont:MediumFont(font(10))];
    [shopCarButton addTarget:self action:@selector(carBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shopCarButton];
    [shopCarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kWidth(29.0), kHeight(35)));
        make.left.equalTo(self).offset(kWidth(50.0));
    }];
    
    self.carBtn = shopCarButton;
    
    //立即购买
//    立即购买\n￥61000
    UIButton *buyBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"",MediumFont(font(15)),white_color,0);
//        button.titleLabel.numberOfLines = 2;
        button.backgroundColor = HEXColor(@"#FF4400");
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.backSubject sendNext:@(3)];
        }];
    }];
    [self addSubview:buyBtn];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.top.bottom.equalTo(self);
        make.right.equalTo(self);
        make.width.mas_equalTo(kWidth(120));
    }];
    
    //立即购买的按钮
    self.buyBtn = buyBtn;
    
    //立即购买文字
    UILabel *buyTextLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"立即购买",MediumFont(font(13)),white_color);
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [buyBtn addSubview:buyTextLabel];
    [buyTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(buyBtn);
        make.top.equalTo(buyBtn).offset(kHeight(12.0));
        make.height.mas_equalTo(kHeight(13.0));
    }];
    
    //没有砍价的价格的试图
    UILabel *noKillPriceLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"￥0",MediumFont(font(13)),white_color);
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [buyBtn addSubview:noKillPriceLabel];
    [noKillPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buyTextLabel.mas_bottom).offset(kHeight(5.0));
        make.centerX.equalTo(buyBtn);
        make.height.mas_equalTo(kHeight(10));
    }];
    self.noKillPriceLabel = noKillPriceLabel;
    
    //原价
    UILabel *originPriceLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"￥0",MediumFont(font(10)),RGBA(255, 255, 255, 0.6));
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [buyBtn addSubview:originPriceLabel];
    [originPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buyTextLabel.mas_bottom).offset(kHeight(7.0));
        make.height.mas_equalTo(kHeight(8.0));
        make.right.equalTo(buyTextLabel.mas_centerX);
    }];
    originPriceLabel.hidden = YES;
    self.originPriceLabel = originPriceLabel;
    
    //划线的操作
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGBA(255, 255, 255, 0.6);
    [originPriceLabel addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.right.equalTo(originPriceLabel);
        make.height.mas_equalTo(kHeight(0.5));
    }];
    lineView.hidden = YES;
    self.originLineView = lineView;
    
    //现价的按钮
    UILabel *priceLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"￥8000",MediumFont(font(13)),white_color);
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [buyBtn addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(originPriceLabel);
        make.height.mas_equalTo(kHeight(10.0));
        make.left.equalTo(originPriceLabel.mas_right).offset(kHeight(5.0));
    }];
    priceLabel.hidden = YES;
    self.afterSecondKillPriceLabel = priceLabel;
    
    //要好友砍价
    UIButton *killPriceBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"",MediumFont(font(13)),white_color,0);
        button.backgroundColor = HEXColor(@"#F3B02F");
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.backSubject sendNext:@(2)];
        }];
    }];
    [self addSubview:killPriceBtn];
    [killPriceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.top.bottom.equalTo(self);
        make.right.equalTo(buyBtn.mas_left);
        make.width.mas_equalTo(kWidth(120));
    }];
    
    //砍价的文本
    UILabel *killPriceTextLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"邀好友砍价",MediumFont(font(13)),white_color);
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 1;
        [label sizeToFit];
    }];
    [killPriceBtn addSubview:killPriceTextLabel];
    [killPriceTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(killPriceBtn);
        make.top.equalTo(killPriceBtn).offset(kHeight(12.0));
        make.height.mas_equalTo(kHeight(13.0));
    }];
    
    //砍价的价格
    UILabel *killPriceLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"￥0",MediumFont(font(13)),RGBA(255, 255, 255, 0.6));
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [killPriceBtn addSubview:killPriceLabel];
    [killPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(killPriceTextLabel.mas_bottom).offset(kHeight(5.0));
        make.height.mas_equalTo(kHeight(10.0));
        make.centerX.equalTo(killPriceTextLabel);
    }];
    self.killPriceLabel = killPriceLabel;
    self.killPriceBtn = killPriceBtn;
    
    //免费领取按钮
    UIButton *freeGetBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"免费领取",MediumFont(font(13)),white_color,0);
        button.backgroundColor = HEXColor(@"#FF4400");
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.backSubject sendNext:@(4)];
        }];
    }];
    [self addSubview:freeGetBtn];
    [freeGetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.bottom.equalTo(self);
    }];
    freeGetBtn.hidden = YES;
    //免费领取的按钮
    self.freeGetBtn = freeGetBtn;

}

//加入购物车按钮
- (void)carBtnClick:(UIButton *)btn {
    [self.backSubject sendNext:@(1)];
}

- (RACSubject *)backSubject {
    if(!_backSubject) {
        _backSubject = [[RACSubject alloc] init];
    }
    return _backSubject;
}

@end
