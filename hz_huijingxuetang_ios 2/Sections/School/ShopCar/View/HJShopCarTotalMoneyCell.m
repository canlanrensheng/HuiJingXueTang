//
//  HJShopCarTotalMoneyCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/24.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJShopCarTotalMoneyCell.h"

@interface HJShopCarTotalMoneyCell ()

@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) UILabel *desLabel;

@end

@implementation HJShopCarTotalMoneyCell

- (void)hj_configSubViews {
    
    //名称
    _priceLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"￥1299",MediumFont(font(13.0)),HEXColor(@"#FF4400"));
        label.textAlignment = NSTextAlignmentRight;
        [label sizeToFit];
    }];
    [self addSubview:_priceLabel];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-kWidth(10.0));
        make.height.mas_equalTo(kHeight(13.0));
    }];
    
    _desLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"优惠卷抵扣:",MediumFont(font(13.0)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentRight;
        [label sizeToFit];
    }];
    [self addSubview:_desLabel];
    [_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(_priceLabel.mas_left).offset(-kWidth(10.0));
        make.height.mas_equalTo(kHeight(13.0));
    }];
    
}

@end
