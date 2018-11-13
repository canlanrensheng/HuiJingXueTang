//
//  HJClassDetailBottomView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/25.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJClassDetailBottomView.h"
#import "HJPicAndTextButton.h"
@implementation HJClassDetailBottomView

- (void)hj_configSubViews {
    self.backgroundColor = white_color;
    
    //立即购买
    UIButton *buyBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"立即购买",MediumFont(font(15)),white_color,0);
        button.backgroundColor = HEXColor(@"#FF4400");
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.backSubject sendNext:@(1)];
        }];
    }];
    [self addSubview:buyBtn];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.top.bottom.equalTo(self);
        make.right.equalTo(self);
        make.width.mas_equalTo(kWidth(100));
    }];
    
    //要好友砍价
    UIButton *killPriceBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"邀好友砍价\n￥6000",MediumFont(font(13)),white_color,0);
        button.titleLabel.numberOfLines = 2;
        button.backgroundColor = HEXColor(@"#F3B02F");
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.backSubject sendNext:@(1)];
        }];
    }];
    [self addSubview:killPriceBtn];
    [killPriceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.top.bottom.equalTo(self);
        make.right.equalTo(buyBtn.mas_left);
        make.width.mas_equalTo(kWidth(100));
    }];
    
    //购物车
    HJPicAndTextButton *shopCarButton = [HJPicAndTextButton buttonWithType:UIButtonTypeCustom withSpace:kHeight(10.0)];
    shopCarButton.buttonStyle = ButtonImageTop;
    [shopCarButton setImage:V_IMAGE(@"加入购物车") forState:UIControlStateNormal];
    [shopCarButton setImage:V_IMAGE(@"已添加购物车") forState:UIControlStateSelected];
    [shopCarButton setTitle:@"购物车" forState:UIControlStateNormal];
    [shopCarButton setTitle:@"已添加" forState:UIControlStateSelected];
    [shopCarButton setTitleColor:HEXColor(@"#22476B") forState:UIControlStateNormal];
    [shopCarButton setTitleColor:HEXColor(@"#999999") forState:UIControlStateSelected];
    shopCarButton.titleLabel.font = MediumFont(font(10));
    [shopCarButton addTarget:self action:@selector(carBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shopCarButton];
    [shopCarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kWidth(50), kHeight(60)));
        make.right.equalTo(killPriceBtn.mas_left).offset(-kWidth(34.0));
    }];
    
    //原来的价格
    UILabel *originPriceLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"￥26000",MediumFont(font(11)),HEXColor(@"#999999"));
        [label sizeToFit];
    }];
    [self addSubview:originPriceLabel];
    [originPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kHeight(10));
        make.left.equalTo(self).offset(kWidth(21.0));
        make.height.mas_equalTo(kHeight(9.0));
    }];
    
    //画线
    UIView *priceLineView= [[UIView alloc] init];
    priceLineView.backgroundColor = HEXColor(@"#999999");
    [self addSubview:priceLineView];
    [priceLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(originPriceLabel);
        make.left.right.equalTo(originPriceLabel);
        make.height.mas_equalTo(kHeight(1.0));
    }];
    
    //价格
    UILabel *priceLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"￥1980",BoldFont(font(17)),HEXColor(@"#FF4400"));
        [label sizeToFit];
    }];
    [self addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(originPriceLabel.mas_bottom).offset(kHeight(8.0));
        make.left.equalTo(originPriceLabel);
        make.height.mas_equalTo(kHeight(13));
    }];

}

- (void)carBtnClick:(UIButton *)btn {
    
}

- (RACSubject *)backSubject {
    if(!_backSubject) {
        _backSubject = [[RACSubject alloc] init];
    }
    return _backSubject;
}

@end
