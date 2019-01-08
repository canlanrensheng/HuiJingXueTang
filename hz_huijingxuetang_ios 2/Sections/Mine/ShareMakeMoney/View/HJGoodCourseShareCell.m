//
//  HJGoodCourseShareCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/23.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJGoodCourseShareCell.h"
#import "HJShareViewModel.h"
#import "HJShareCourseModel.h"
@interface HJGoodCourseShareCell ()

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *courceLabel;
@property (nonatomic,strong) UILabel *teacherNameLabel;
@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) UILabel *dayLabel;

@end


@implementation HJGoodCourseShareCell

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

    
    //名称
    UILabel *nameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"重温经典系列之新K线战法",BoldFont(font(14)),HEXColor(@"#333333"));
        label.numberOfLines = 2;
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imaV).offset(kHeight(5.0));
        make.left.equalTo(imaV.mas_right).offset(kWidth(12.0));
        make.right.equalTo(self).offset(-kWidth(10.0));
    }];
    
    self.courceLabel = nameLabel;
    
    UILabel *teacherNameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"讲师：汪伟峰",MediumFont(font(11)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [self addSubview:teacherNameLabel];
    [teacherNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(kHeight(11.0));
        make.left.equalTo(nameLabel);
        make.height.mas_equalTo(kHeight(13.0));
    }];
    
    self.teacherNameLabel = teacherNameLabel;

    //价格
    UILabel *priceLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"￥12800",BoldFont(font(15)),HEXColor(@"#FF4400"));
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    //        NSString *price = [NSString stringWithFormat:@"¥ %.0f",model.coursemoney];
    //        priceLabel.attributedText = [price attributeWithStr:@"¥" color:HEXColor(@"#666666") font:BoldFont(font(13))];
    [self addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(imaV).offset(-kHeight(5.0));
        make.left.equalTo(nameLabel);
        make.height.mas_equalTo(kHeight(12.0));
    }];
    self.priceLabel = priceLabel;
    
    //天数
    UILabel *dayLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"/180天",MediumFont(font(10)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [self addSubview:dayLabel];
    [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(priceLabel);
        make.left.equalTo(priceLabel.mas_right);
        make.height.mas_equalTo(kHeight(12.0));
    }];
    
    self.dayLabel = dayLabel;
    
    //赚取佣金的提示
    UILabel *makeBrokerageLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"赚取佣金",MediumFont(font(13)),white_color);
        label.backgroundColor = HEXColor(@"#F57159");
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:makeBrokerageLabel];
    [makeBrokerageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(dayLabel);
        make.right.equalTo(self).offset(-kWidth(10.0));
        make.size.mas_equalTo(CGSizeMake(kWidth(80), kHeight(24)));
    }];
    [makeBrokerageLabel clipWithCornerRadius:kHeight(12) borderColor:nil borderWidth:0];
}

- (void)setViewModel:(BaseViewModel *)viewModel indexPath:(NSIndexPath *)indexPath {
    HJShareViewModel *listViewModel = (HJShareViewModel *)viewModel;
    HJShareCourseModel *model = listViewModel.courseListArray[indexPath.row];
    
    [self.imgView sd_setImageWithURL:URL(model.coursepic) placeholderImage:V_IMAGE(@"占位图")];
    self.courceLabel.text = model.coursename;
    self.teacherNameLabel.text = [NSString stringWithFormat:@"讲师：%@",model.realname];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",model.coursemoney];
    self.dayLabel.text = [NSString stringWithFormat:@"/%ld天",model.periods];
}

@end
