//
//  HJSchoolClassCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/23.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSchoolClassCell.h"

@interface HJSchoolClassCell ()

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UIImageView *youhuuiImaV;
@property (nonatomic,strong) UILabel *courceLabel;
@property (nonatomic,strong) UILabel *studentCountLabel;
@property (nonatomic,strong) UILabel *originPriceLabel;
@property (nonatomic,strong) UILabel *priceLabel;

@end


@implementation HJSchoolClassCell

- (void)hj_configSubViews {
    
    //图片
    UIImageView *imaV = [[UIImageView alloc] init];
    imaV.image = V_IMAGE(@"占位图");
//    [imaV sd_setImageWithURL:URL(model.coursepic) placeholderImage:nil];
    imaV.backgroundColor = Background_Color;
    [self addSubview:imaV];
    [imaV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kHeight(11.0));
        make.left.equalTo(self).offset(kWidth(10.0));
        make.width.mas_equalTo(kWidth(145));
        make.height.mas_equalTo(kHeight(90));
    }];
    [imaV clipWithCornerRadius:kHeight(5.0) borderColor:nil borderWidth:0];
    self.imgView = imaV;
    
    UIImageView *youhuuiImaV = [[UIImageView alloc] init];
    youhuuiImaV.image = V_IMAGE(@"优惠标签");
    //    [imaV sd_setImageWithURL:URL(model.coursepic) placeholderImage:nil];
    youhuuiImaV.backgroundColor = Background_Color;
    [imaV addSubview:youhuuiImaV];
    [youhuuiImaV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imaV).offset(kHeight(7.0));
        make.left.equalTo(self).offset(kWidth(6.0));
    }];

    self.youhuuiImaV = imaV;
    
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
    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.top.equalTo(nameLabel.mas_bottom).offset(kHeight(8.0));
        make.height.mas_equalTo(kHeight(11));
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
//        starImageView.image = V_IMAGE(@"评价星星");
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
        //            make.top.equalTo(nameLabel.mas_bottom).offset(kHeight(10.0));
        make.centerY.equalTo(starView);
        make.left.equalTo(imaV.mas_right).offset(kWidth(87.0));
        make.height.mas_equalTo(kHeight(13.0));
    }];
    
    self.studentCountLabel = starCountLabel;
    
    //讲师
    UILabel *teacherLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"讲师：金建",MediumFont(font(13)),HEXColor(@"#666666"));
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [self addSubview:teacherLabel];
    
    [teacherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(imaV).offset(-kHeight(5.0));
        make.left.equalTo(imaV.mas_right).offset(kWidth(13.0));
        make.height.mas_equalTo(kHeight(12.0));
    }];
    
    //天数
    UILabel *dayLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"/180天",MediumFont(font(11)),HEXColor(@"#FF4400"));
        label.textAlignment = NSTextAlignmentRight;
        [label sizeToFit];
    }];
    [self addSubview:dayLabel];
    [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-kWidth(10.0));
        make.centerY.equalTo(teacherLabel);
        make.height.mas_equalTo(kHeight(12.0));
    }];
    
    //价格
    UILabel *priceLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"￥12800",BoldFont(font(15)),HEXColor(@"#FF4400"));
        label.textAlignment = NSTextAlignmentRight;
        [label sizeToFit];
    }];
    //        NSString *price = [NSString stringWithFormat:@"¥ %.0f",model.coursemoney];
    //        priceLabel.attributedText = [price attributeWithStr:@"¥" color:HEXColor(@"#666666") font:BoldFont(font(13))];
    [self addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(dayLabel.mas_left);
        make.centerY.equalTo(teacherLabel);
        make.height.mas_equalTo(kHeight(12.0));
    }];
    self.priceLabel = priceLabel;
    
    

    //原来的价格
    UILabel *originPriceLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"￥1980",MediumFont(font(10)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentRight;
        [label sizeToFit];
    }];
    [self addSubview:originPriceLabel];
    [originPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-kWidth(10.0));
        make.height.mas_equalTo(kHeight(10.0));
        make.bottom.equalTo(priceLabel.mas_top).offset(-kHeight(5.0));
    }];
    
    self.originPriceLabel = originPriceLabel;
    
    //画线
    UIView *priceLineView= [[UIView alloc] init];
    priceLineView.backgroundColor = HEXColor(@"#999999");
    [self addSubview:priceLineView];
    [priceLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(originPriceLabel);
        make.left.right.equalTo(originPriceLabel);
        make.height.mas_equalTo(kHeight(1.0));
    }];
    

//    NSString *price = [NSString stringWithFormat:@"¥ %.0f",model.coursemoney];
//    priceLabel.attributedText = [price attributeWithStr:@"¥" color:HEXColor(@"#FF4400") font:BoldFont(font(13))];
}

@end
