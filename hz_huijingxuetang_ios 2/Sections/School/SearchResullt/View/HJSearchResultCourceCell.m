//
//  HJSearchResultCourceCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/26.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSearchResultCourceCell.h"

@interface HJSearchResultCourceCell ()

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UIImageView *youhuuiImaV;
@property (nonatomic,strong) UILabel *courceLabel;
@property (nonatomic,strong) UILabel *studentCountLabel;
@property (nonatomic,strong) UILabel *originPriceLabel;
@property (nonatomic,strong) UILabel *priceLabel;

@end


@implementation HJSearchResultCourceCell

- (void)hj_configSubViews {
    self.backgroundColor = white_color;
    //图片
    UIImageView *imaV = [[UIImageView alloc] init];
    imaV.image = V_IMAGE(@"占位图");
    //    [imaV sd_setImageWithURL:URL(model.coursepic) placeholderImage:nil];
    imaV.backgroundColor = Background_Color;
    [self addSubview:imaV];
    [imaV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(10.0));
        make.width.mas_equalTo(kWidth(145));
        make.height.mas_equalTo(kHeight(90));
        make.centerY.equalTo(self);
    }];
    [imaV clipWithCornerRadius:kHeight(5.0) borderColor:nil borderWidth:0];
    self.imgView = imaV;
    
    //名称
    UILabel *nameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"重温经典系列之新K线战法",BoldFont(font(14)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imaV).offset(kHeight(5.0));
        make.left.equalTo(imaV.mas_right).offset(kWidth(12.0));
        make.height.mas_equalTo(kHeight(13.0));
    }];
    self.courceLabel = nameLabel;
    
    //星级
    UIView *starView = [[UIView alloc] init];
    starView.backgroundColor = white_color;
    [self addSubview:starView];
    CGFloat totalWidth = kWidth(11) * 5 + kWidth(2.0) * 4;
    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.top.equalTo(nameLabel.mas_bottom).offset(kHeight(8.0));
        make.height.mas_equalTo(kHeight(11));
        make.width.mas_equalTo(kWidth(totalWidth));
    }];
    
    for(int i = 0; i < 5;i++) {
        UIImageView *starImageView = [[UIImageView alloc] init];
        starImageView.frame = CGRectMake((kWidth(2 + 11) * i), 0, kWidth(11), kWidth(11));
        starImageView.backgroundColor = white_color;
        if(i <= 3) {
            starImageView.image = V_IMAGE(@"评价星亮色");
        } else {
            starImageView.image = V_IMAGE(@"评价星 暗色");
        }
        [starView addSubview:starImageView];
    }
    
    //星级Label
    UILabel *starCountLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor([NSString stringWithFormat:@"4.9 %tu人学过",960],MediumFont(font(11)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [self addSubview:starCountLabel];
    [starCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(starView);
        make.left.equalTo(starView.mas_right).offset(kWidth(5.0));
        make.height.mas_equalTo(kHeight(13.0));
    }];
    
    self.studentCountLabel = starCountLabel;
    
    //价格
    UILabel *priceLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"￥12800",BoldFont(font(15)),HEXColor(@"#FF4400"));
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [self addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(imaV).offset(-kHeight(5.0));
        make.left.equalTo(imaV.mas_right).offset(kWidth(13.0));
        make.height.mas_equalTo(kHeight(12.0));
    }];
    self.priceLabel = priceLabel;
    
    //天数
    UILabel *dayLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"/180天",MediumFont(font(11)),HEXColor(@"#FF4400"));
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [self addSubview:dayLabel];
    [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(priceLabel);
        make.left.equalTo(priceLabel.mas_right);
        make.height.mas_equalTo(kHeight(12.0));
    }];
}

@end
