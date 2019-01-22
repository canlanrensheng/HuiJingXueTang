//
//  HJShopCarListCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/24.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJShopCarListCell.h"
#import "HJShopCarViewModel.h"
#import "HJShopCarListModel.h"
@interface HJShopCarListCell ()

@property (nonatomic,strong) UIButton *selectButton;
@property (nonatomic,strong) UIImageView *picImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *courceTypeLabel;
@property (nonatomic,strong) UILabel *serviceTimeLabel;
@property (nonatomic,strong) UILabel *priceLabel;

@property (nonatomic,strong) UILabel *originPriceLabel;
@property (nonatomic,strong) UIView *priceLineView;

@property (nonatomic,strong) HJShopCarListModel *model;

@end

@implementation HJShopCarListCell


- (void)hj_configSubViews {
    
    self.selectButton = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"选择",H15,clear_color,0);
        [button setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"勾选"] forState:UIControlStateSelected];
        button.userInteractionEnabled = NO;
    }];
    [self addSubview:self.selectButton];
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(kWidth(10.0));
        make.width.height.mas_equalTo(kHeight(15.0));
    }];
    
    //图片
    UIImageView *imaV = [[UIImageView alloc] init];
    imaV.image = V_IMAGE(@"占位图");
    imaV.backgroundColor = Background_Color;
    [self addSubview:imaV];
    [imaV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.selectButton.mas_right).offset(kWidth(5.0));
        make.width.mas_equalTo(kWidth(145));
        make.height.mas_equalTo(kHeight(90));
    }];
    [imaV clipWithCornerRadius:kHeight(5.0) borderColor:nil borderWidth:0];
    self.picImageView = imaV;
    
    //名称
    UILabel *nameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"重温经典系列之新K线战法",BoldFont(font(14)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 2;
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
        label.ljTitle_font_textColor(@"服务周期：一年",MediumFont(font(11.0)),HEXColor(@"#666666"));
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
        label.ljTitle_font_textColor(@"",MediumFont(font(11.0)),HEXColor(@"#666666"));
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
    
    //分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = Line_Color;
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(kHeight(0.5));
    }];
}

- (void)setViewModel:(BaseViewModel *)viewModel indexPath:(NSIndexPath *)indexPath {
    HJShopCarViewModel *listViewModel = (HJShopCarViewModel *)viewModel;
    HJShopCarListModel *model = listViewModel.shopCarListArray[indexPath.row];
    self.model = model;
    if (model) {
        [self.picImageView sd_setImageWithURL:URL(model.coursepic) placeholderImage:V_IMAGE(@"占位图") options:SDWebImageRefreshCached];
        self.nameLabel.text = model.coursename;
        _serviceTimeLabel.text = [NSString stringWithFormat:@"服务周期：%ld天",model.periods];
        
        CGFloat price = 0;
        CGFloat originPrice = 0;
        if (model.hassecond == 1) {
            //有秒杀价
            self.originPriceLabel.hidden = NO;
            self.priceLineView.hidden = NO;
            price = model.secondprice.floatValue;
            originPrice = model.coursemoney.floatValue;
            
            NSString *priceString = [NSString stringWithFormat:@"￥%.2f",price];
            self.priceLabel.attributedText = [priceString attributeWithStr:@"￥" color:HEXColor(@"#333333") font:MediumFont(font(13))];
            
            self.originPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",originPrice];
        } else {
            //没有秒杀价
            self.originPriceLabel.hidden = YES;
            self.priceLineView.hidden = YES;
            //没有秒杀价
            price = model.coursemoney.floatValue;
            NSString *priceString = [NSString stringWithFormat:@"￥%.2f",price];
            self.priceLabel.attributedText = [priceString attributeWithStr:@"￥" color:HEXColor(@"#333333") font:MediumFont(font(13))];
        }
        
        self.selectButton.selected = model.isSelect;
    }
}

- (RACSubject *)backSub {
    if(!_backSub) {
        _backSub = [[RACSubject alloc] init];
    }
    return _backSub;
}

@end
