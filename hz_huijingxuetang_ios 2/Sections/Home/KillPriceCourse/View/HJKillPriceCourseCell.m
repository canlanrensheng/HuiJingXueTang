//
//  HJKillPriceCourseCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2019/1/11.
//  Copyright © 2019年 Junier. All rights reserved.
//

#import "HJKillPriceCourseCell.h"

#import "HJKillPriceModel.h"
#import "HJKillPriceCourseViewModel.h"
@interface HJKillPriceCourseCell ()

@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UIImageView *youhuuiImaV;
@property (nonatomic,strong) UILabel *courceLabel;
@property (nonatomic,strong) UILabel *studentCountLabel;
@property (nonatomic,strong) UILabel *originPriceLabel;
@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) UILabel *teacherLabel;
@property (nonatomic,strong) UILabel *dayLabel;

@property (nonatomic,strong) UIView *priceLineView;

@property (nonatomic,strong) NSMutableArray *starImgMarr;

//砍价剩下多少钱背景
@property (nonatomic,strong)UIImageView *moneyLeftImageView;
@property (nonatomic,strong) UILabel *moneyLeftLabel;

@end


@implementation HJKillPriceCourseCell

- (void)hj_configSubViews {
    
    //图片
    UIImageView *imaV = [[UIImageView alloc] init];
    //    imaV.image = V_IMAGE(@"占位图");
    imaV.backgroundColor = Background_Color;
    [self addSubview:imaV];
    [imaV mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.equalTo(self).offset(kHeight(11.0));
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(kWidth(10.0));
        make.width.mas_equalTo(kWidth(145));
        make.height.mas_equalTo(kHeight(90));
    }];
    [imaV clipWithCornerRadius:kHeight(5.0) borderColor:nil borderWidth:0];
    self.imgV = imaV;
    
    UIImageView *youhuuiImaV = [[UIImageView alloc] init];
    youhuuiImaV.image = V_IMAGE(@"优惠标签");
    youhuuiImaV.backgroundColor = clear_color;
    [self addSubview:youhuuiImaV];
    [youhuuiImaV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imaV).offset(kHeight(7.0));
        make.left.equalTo(imaV).offset(-kWidth(5.0));
    }];
    
    self.youhuuiImaV = youhuuiImaV;
    
    
    //砍价剩下多少钱背景
    UIImageView *moneyLeftImageView = [[UIImageView alloc] init];
    moneyLeftImageView.image = V_IMAGE(@"矩形 3041");
    [imaV addSubview:moneyLeftImageView];
    [moneyLeftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(imaV);
        make.height.mas_equalTo(kHeight(20.0));
    }];
    self.moneyLeftImageView = moneyLeftImageView;
    
    //砍价立剩多少钱
    UILabel *moneyLeftLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"砍价立省1000元",MediumFont(font(11.0)),white_color);
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [moneyLeftImageView addSubview:moneyLeftLabel];
    [moneyLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(moneyLeftImageView).offset(kWidth(6.0));
        make.centerY.equalTo(moneyLeftImageView);
        make.height.mas_equalTo(kHeight(11.0));
    }];
    self.moneyLeftLabel = moneyLeftLabel;
    
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
    
    self.starImgMarr = [NSMutableArray array];
    for(int i = 0; i < 5;i++) {
        UIImageView *starImageView = [[UIImageView alloc] init];
        starImageView.frame = CGRectMake((kWidth(2 + 11) * i), 0, kWidth(11), kWidth(11));
        starImageView.backgroundColor = white_color;
        [starView addSubview:starImageView];
        [self.starImgMarr addObject:starImageView];
    }
    
    //星级Label
    CGFloat leftWith = kWidth(11) * 5 + kWidth(2) * 4 + kWidth(12) + kWidth(5.0);
    UILabel *starCountLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor([NSString stringWithFormat:@"4.9 %tu人学过",960],MediumFont(font(11)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [self addSubview:starCountLabel];
    [starCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.equalTo(nameLabel.mas_bottom).offset(kHeight(10.0));
        make.centerY.equalTo(starView);
        make.left.equalTo(imaV.mas_right).offset(leftWith);
        make.height.mas_equalTo(kHeight(13.0));
    }];
    
    self.studentCountLabel = starCountLabel;
    
    //讲师
    UILabel *teacherLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"讲师：",MediumFont(font(10)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [self addSubview:teacherLabel];
    
    [teacherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(imaV).offset(-kHeight(5.0));
        make.left.equalTo(imaV.mas_right).offset(kWidth(13.0));
        make.height.mas_equalTo(kHeight(12.0));
    }];
    self.teacherLabel = teacherLabel;
    
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
    self.dayLabel = dayLabel;
    
    //价格
    UILabel *priceLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"￥0",BoldFont(font(15)),HEXColor(@"#FF4400"));
        label.textAlignment = NSTextAlignmentRight;
        [label sizeToFit];
    }];
    
    [self addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(dayLabel.mas_left);
        make.centerY.equalTo(teacherLabel);
        make.height.mas_equalTo(kHeight(12.0));
    }];
    self.priceLabel = priceLabel;
    
    //原来的价格
    UILabel *originPriceLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"￥0",MediumFont(font(10)),HEXColor(@"#999999"));
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
    UIView *priceLineView = [[UIView alloc] init];
    priceLineView.backgroundColor = HEXColor(@"#999999");
    [self addSubview:priceLineView];
    [priceLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(originPriceLabel);
        make.left.right.equalTo(originPriceLabel);
        make.height.mas_equalTo(kHeight(0.5));
    }];
    self.priceLineView = priceLineView;
    
}

//fuyu
- (void)setViewModel:(BaseViewModel *)viewModel indexPath:(NSIndexPath *)indexPath {
    HJKillPriceCourseViewModel *listViewModel = (HJKillPriceCourseViewModel *)viewModel;
    HJKillPriceModel *model = listViewModel.courseListArray[indexPath.row];
    if(model){
        [self.imgV sd_setImageWithURL:URL(model.coursepic) placeholderImage:V_IMAGE(@"占位图") options:SDWebImageRefreshCached];
        self.courceLabel.text = model.coursename;
        //没有限时特惠
        if(model.hassecond == 0){
            self.youhuuiImaV.hidden = YES;
            self.originPriceLabel.hidden = YES;
            self.priceLineView.hidden = YES;
            self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",model.coursemoney];
            self.dayLabel.text = [NSString stringWithFormat:@"/%tu天",model.periods];
        }else{
            self.youhuuiImaV.hidden = NO;
            self.originPriceLabel.hidden = NO;
            self.priceLineView.hidden = NO;
            
            self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",model.secondprice.floatValue];
            self.dayLabel.text = [NSString stringWithFormat:@"/%tu天",model.periods];
            self.originPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",model.coursemoney];
        }
        
        NSString *moneyLeftText = [NSString stringWithFormat:@"砍价立省%.2f元",model.savedAmount];
        self.moneyLeftLabel.attributedText = [moneyLeftText attributeWithStr:[NSString stringWithFormat:@"%.2f",model.savedAmount] color:white_color font:BoldFont(font(11))];
        
        //设置星级
        float fStaLevel = model.starlevel.floatValue;
        if(fStaLevel == model.starlevel.intValue) {
            for (int i = 0;i < 5 ;i++){
                UIImageView *imaV = self.starImgMarr[i];
                if(i < model.starlevel.intValue) {
                    imaV.image = V_IMAGE(@"评价星亮色");
                } else {
                    imaV.image = V_IMAGE(@"评价星 暗色");
                }
            }
        } else{
            for (int i = 0;i < 5 ;i++){
                UIImageView *imaV = self.starImgMarr[i];
                if(i < ceilf(model.starlevel.floatValue) - 1) {
                    imaV.image = V_IMAGE(@"评价星亮色");
                }  else if(i == ceilf(model.starlevel.floatValue) - 1){
                    imaV.image = V_IMAGE(@"评价星亮色-1");
                } else {
                    imaV.image = V_IMAGE(@"评价星 暗色");
                }
            }
        }
        
        self.studentCountLabel.text = [NSString stringWithFormat:@"%.1f   %tu人学过",model.starlevel.floatValue,model.browsingcount];
        self.teacherLabel.text = [NSString stringWithFormat:@"讲师：%@",model.realname];
        
    }
    
}

@end
