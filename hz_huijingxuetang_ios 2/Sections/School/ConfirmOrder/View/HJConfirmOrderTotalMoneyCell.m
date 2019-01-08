//
//  HJConfirmOrderTotalMoneyCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/24.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJConfirmOrderTotalMoneyCell.h"
#import "HJConfirmOrderViewModel.h"
#import "HJConfirmOrderModel.h"
@interface HJConfirmOrderTotalMoneyCell ()

@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) UILabel *desLabel;

@end

@implementation HJConfirmOrderTotalMoneyCell

- (void)hj_configSubViews {
    
    //名称
    _priceLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"￥1299",MediumFont(font(17.0)),HEXColor(@"#FF4400"));
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
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = HEXColor(@"#EAEAEA");
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.left.equalTo(self).offset(kWidth(10.0));
        make.bottom.equalTo(self).offset(- kHeight(0.5));
        make.height.mas_equalTo(kHeight(0.5));
    }];
}

- (void)setViewModel:(BaseViewModel *)viewModel indexPath:(NSIndexPath *)indexPath {
    HJConfirmOrderViewModel *listViewModel = (HJConfirmOrderViewModel *)viewModel;
    HJConfirmOrderModel *model = listViewModel.model;
    if(indexPath.row == 0) {
        //优惠券抵扣
        _desLabel.text = @"优惠卷抵扣：";
        NSString *price = [NSString stringWithFormat:@"￥%.2f",model.price.floatValue];
        self.priceLabel.attributedText = [price attributeWithStr:@"￥" color:HEXColor(@"#FF4400") font:MediumFont(font(13))];
    } else {
        //合计金额
        _desLabel.text = @"合计：";
        NSString *price = [NSString stringWithFormat:@"￥%.2f",model.money - model.price.floatValue];
        self.priceLabel.attributedText = [price attributeWithStr:@"￥" color:HEXColor(@"#FF4400") font:MediumFont(font(13))];
    }
    
}

@end
