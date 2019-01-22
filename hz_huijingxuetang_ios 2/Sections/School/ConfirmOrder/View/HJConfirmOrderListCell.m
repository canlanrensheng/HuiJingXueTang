//
//  HJConfirmOrderListCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/24.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJConfirmOrderListCell.h"
#import "HJConfirmOrderViewModel.h"
#import "HJConfirmOrderModel.h"
@interface HJConfirmOrderListCell ()

@property (nonatomic,strong) UIButton *selectButton;
@property (nonatomic,strong) UIImageView *picImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *courceTypeLabel;
@property (nonatomic,strong) UILabel *serviceTimeLabel;
@property (nonatomic,strong) UILabel *priceLabel;

@property (nonatomic,strong) UILabel *originPriceLabel;
@property (nonatomic,strong) UIView *priceLineView;

@end

@implementation HJConfirmOrderListCell


- (void)hj_configSubViews {
    
    //图片
    UIImageView *imaV = [[UIImageView alloc] init];
    imaV.image = V_IMAGE(@"占位图");
    imaV.backgroundColor = Background_Color;
    [self addSubview:imaV];
    [imaV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(kWidth(10.0));
        make.width.mas_equalTo(kWidth(145));
        make.height.mas_equalTo(kHeight(90));
    }];
    [imaV clipWithCornerRadius:kHeight(5.0) borderColor:nil borderWidth:0];
    self.picImageView = imaV;
    
    //名称
    UILabel *nameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",BoldFont(font(14)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 2.0;
        [label sizeToFit];
    }];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imaV).offset(kHeight(5.0));
        make.left.equalTo(imaV.mas_right).offset(kWidth(10.0));
        make.right.equalTo(self).offset(-kWidth(10));
//        make.height.mas_equalTo(kHeight(13.0));
    }];
    
    self.nameLabel = nameLabel;
    
    
    //服务周期：
    _serviceTimeLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"服务周期：一年",MediumFont(font(11.0)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [self addSubview:_serviceTimeLabel];
    [_serviceTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(imaV.mas_bottom).offset(-kHeight(5.0));
        make.left.equalTo(imaV.mas_right).offset(kWidth(10.0));
        make.height.mas_equalTo(kHeight(13.0));
    }];
    
    //课程类型：直播：
    _courceTypeLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"课程类型：直播",MediumFont(font(11.0)),HEXColor(@"#666666"));
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [self addSubview:_courceTypeLabel];
    [_courceTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_serviceTimeLabel.mas_top).offset(-kHeight(5.0));
        make.left.equalTo(imaV.mas_right).offset(kWidth(10.0));
        make.height.mas_equalTo(kHeight(13.0));
    }];
    
    //价格
    _priceLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"￥1299",MediumFont(font(15.0)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [self addSubview:_priceLabel];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_serviceTimeLabel);
        make.right.equalTo(self).offset(-kWidth(10.0));
        make.height.mas_equalTo(kHeight(13.0));
    }];
    
    //原价的价格
    UILabel *originPriceLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"",MediumFont(font(10)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentRight;
        [label sizeToFit];
    }];
    [self addSubview:originPriceLabel];
    [originPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_priceLabel);
        make.bottom.equalTo(_priceLabel.mas_top).offset(-kHeight(5.0));
        make.height.mas_equalTo(kHeight(8.0));
    }];
    
    self.originPriceLabel = originPriceLabel;
    //画线
    UIView *priceLineView= [[UIView alloc] init];
    priceLineView.backgroundColor = HEXColor(@"#999999");
    [self addSubview:priceLineView];
    [priceLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(originPriceLabel);
        make.left.right.equalTo(originPriceLabel);
        make.height.mas_equalTo(kHeight(0.5));
    }];
    self.priceLineView = priceLineView;
}

- (void)setViewModel:(BaseViewModel *)viewModel indexPath:(NSIndexPath *)indexPath {
    HJConfirmOrderViewModel *listViewModel = (HJConfirmOrderViewModel *)viewModel;
    CourselistModel *courseModel = listViewModel.model.courselist[indexPath.row];
    if (courseModel) {
        [self.picImageView sd_setImageWithURL:URL(courseModel.coursepic) placeholderImage:V_IMAGE(@"占位图") options:SDWebImageRefreshCached];
        self.nameLabel.text = courseModel.coursename;
        NSString *serviceTimeString = [NSString stringWithFormat:@"服务周期：%ld天",courseModel.periods];
        self.serviceTimeLabel.attributedText = [serviceTimeString attributeWithStr:@"服务周期：" color:HEXColor(@"#999999") font:MediumFont(font(11.0))];
//        self.serviceTimeLabel.text = [NSString stringWithFormat:@"服务周期：%ld天",courseModel.periods];
        self.courceTypeLabel.text = @"";
//        NSString *price = [NSString stringWithFormat:@"￥%.2f",courseModel.coursemoney.floatValue];
//        self.priceLabel.attributedText = [price attributeWithStr:@"￥" color:HEXColor(@"#333333") font:MediumFont(font(13))];
        CGFloat price = 0;
        CGFloat originPrice = 0;
        if (courseModel.hassecond == 1) {
            //有秒杀价
            self.originPriceLabel.hidden = NO;
            self.priceLineView.hidden = NO;
            price = courseModel.secondprice.floatValue;
            originPrice = courseModel.coursemoney.floatValue;
            
            NSString *priceString = [NSString stringWithFormat:@"￥%.2f",price];
            self.priceLabel.attributedText = [priceString attributeWithStr:@"￥" color:HEXColor(@"#333333") font:MediumFont(font(13))];
            
            self.originPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",originPrice];
        } else {
            //没有秒杀价
            self.originPriceLabel.hidden = YES;
            self.priceLineView.hidden = YES;
            //没有秒杀价
            price = courseModel.coursemoney.floatValue;
            NSString *priceString = [NSString stringWithFormat:@"￥%.2f",price];
            self.priceLabel.attributedText = [priceString attributeWithStr:@"￥" color:HEXColor(@"#333333") font:MediumFont(font(13))];
        }
    }
}

@end

