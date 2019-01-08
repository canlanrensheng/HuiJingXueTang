//
//  HJMyCardVoucherCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/9.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJMyCardVoucherCell.h"
#import "HJMyCardVoucherViewModel.h"
#import "HJMyCardVoucherModel.h"

@interface HJMyCardVoucherCell ()

@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) UILabel *diYongLabel;
@property (nonatomic,strong) UILabel *quanNameLabel;
@property (nonatomic,strong) UILabel *dateLabel;

@end

@implementation HJMyCardVoucherCell

- (void)hj_configSubViews {
    
    self.backgroundColor = HEXColor(@"#F5F5F5");
    
    //图片
    UIImageView *imaV = [[UIImageView alloc] init];
    imaV.image = V_IMAGE(@"优惠券可使用");
    imaV.backgroundColor = clear_color;
    imaV.userInteractionEnabled = YES;
    [self addSubview:imaV];
    [imaV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(kWidth(10));
        make.right.equalTo(self).offset(-kWidth(10));
        make.height.mas_equalTo(kHeight(100));
    }];
    [imaV clipWithCornerRadius:kHeight(5.0) borderColor:nil borderWidth:0];
    self.imgV = imaV;

    //名称
    UILabel *priceLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"0",BoldFont(font(30)),HEXColor(@"#FF3C00"));
        label.textAlignment = NSTextAlignmentCenter;
        [label sizeToFit];
    }];
    [self addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imaV).offset(kHeight(27.0));
        make.left.equalTo(imaV).offset(kWidth(21.0));
        make.height.mas_equalTo(kHeight(23.0));
    }];
//    NSString *priceString = @"129元";
//    priceLabel.attributedText = [priceString attributeWithStr:@"元" color:HEXColor(@"#333333") font:BoldFont(font(10))];
    self.priceLabel = priceLabel;
    
    //满1000抵用
    UILabel *diYongLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",MediumFont(font(11)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentCenter;
        [label sizeToFit];
    }];
    [self addSubview:diYongLabel];
    [diYongLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceLabel.mas_bottom).offset(kHeight(10.0));
        make.centerX.equalTo(priceLabel);
        make.height.mas_equalTo(kHeight(11.0));
    }];
    self.diYongLabel = diYongLabel;
    
    //新学员抵用券
    UILabel *quanNameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"新学员抵用券",MediumFont(font(15)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [self addSubview:quanNameLabel];
    [quanNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(priceLabel.mas_right).offset(kWidth(44));
        make.centerX.equalTo(self);
        make.centerY.equalTo(priceLabel);
        make.height.mas_equalTo(kHeight(15.0));
    }];
    self.quanNameLabel = quanNameLabel;
    
    //日期
    UILabel *dateLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"8月21日-9月10日",[UIFont fontWithName:@"PingFangSC-Regular" size:font(11)],HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [self addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(quanNameLabel);
        make.centerY.equalTo(diYongLabel);
        make.height.mas_equalTo(kHeight(10.0));
    }];
    self.dateLabel = dateLabel;
    
}

- (void)setViewModel:(BaseViewModel *)viewModel indexPath:(NSIndexPath *)indexPath {
    HJMyCardVoucherViewModel *listViewModel = (HJMyCardVoucherViewModel *)viewModel;
    HJMyCardVoucherModel *model = nil;
    if(listViewModel.myCardVoucherType == MyCardVoucherTypeValid) {
        if(indexPath.row < listViewModel.validVoucherArray.count) {
            model = listViewModel.validVoucherArray[indexPath.row];
        }
    } else if (listViewModel.myCardVoucherType == MyCardVoucherTypeUsed) {
        if (indexPath.row < listViewModel.usedVoucherArray.count) {
             model = listViewModel.usedVoucherArray[indexPath.row];
        }
    } else {
        if(indexPath.row < listViewModel.invalidVoucherArray.count) {
            model = listViewModel.invalidVoucherArray[indexPath.row];
        }
    }
    if (model) {
        NSString *priceString = [NSString stringWithFormat:@"%.0f元",model.price.floatValue];
        self.priceLabel.attributedText = [priceString attributeWithStr:@"元" color:HEXColor(@"#333333") font:BoldFont(font(10))];
        self.quanNameLabel.text = model.cpname;
        self.diYongLabel.text = [NSString stringWithFormat:@"满%ld抵用",model.pricecondition];
        if (listViewModel.myCardVoucherType == MyCardVoucherTypeValid) {
            //可用
            self.imgV.image = V_IMAGE(@"优惠券可使用");
        } else if (listViewModel.myCardVoucherType == MyCardVoucherTypeUsed) {
            //已使用
            self.imgV.image = V_IMAGE(@"优惠券已使用");
        } else if(listViewModel.myCardVoucherType == MyCardVoucherTypeInvalid){
            //已过期
            self.imgV.image = V_IMAGE(@"优惠券已过期");
        }
        NSDate *startDate = [NSDate dateWithString:model.beginuseredtime formatString:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *endDate = [NSDate dateWithString:model.expire formatString:@"yyyy-MM-dd HH:mm:ss"];
        self.dateLabel.text = [NSString stringWithFormat:@"%@月%@日-%@月%@日",[NSString convertDateSingleData:startDate.month],[NSString convertDateSingleData:startDate.day],[NSString convertDateSingleData:endDate.month],[NSString convertDateSingleData:endDate.day]];
    }
}

@end
