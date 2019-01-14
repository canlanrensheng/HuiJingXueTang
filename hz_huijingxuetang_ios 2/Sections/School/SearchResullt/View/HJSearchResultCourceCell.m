//
//  HJSearchResultCourceCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/26.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSearchResultCourceCell.h"
#import "HJSearchResultViewModel.h"

@interface HJSearchResultCourceCell ()

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UIImageView *youhuuiImaV;
@property (nonatomic,strong) UILabel *courceLabel;
@property (nonatomic,strong) UILabel *studentCountLabel;
@property (nonatomic,strong) UILabel *originPriceLabel;
@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) UIView *priceLineView;
@property (nonatomic,strong) UILabel *dayLabel;
@property (nonatomic,strong) NSMutableArray *starImgMarr;

@end


@implementation HJSearchResultCourceCell

- (void)hj_configSubViews {
    
    //图片
    UIImageView *imaV = [[UIImageView alloc] init];
    imaV.image = V_IMAGE(@"占位图");
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
    youhuuiImaV.backgroundColor = clear_color;
    [self addSubview:youhuuiImaV];
    [youhuuiImaV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imaV).offset(kHeight(7.0));
         make.left.equalTo(imaV).offset(-kWidth(5.0));
    }];
    
    self.youhuuiImaV = youhuuiImaV;
    
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
        make.left.equalTo(imaV.mas_right).offset(kWidth(12.0));
        make.right.equalTo(self).offset(-kWidth(10));
//        make.height.mas_equalTo(kHeight(13.0));
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
        //        if(i <= 3) {
        //            starImageView.image = V_IMAGE(@"评价星亮色");
        //        } else {
        //            starImageView.image = V_IMAGE(@"评价星 暗色");
        //        }
        //        starImageView.image = V_IMAGE(@"评价星星");
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
        make.bottom.equalTo(imaV).offset(-kHeight(5.0));
        make.left.equalTo(imaV.mas_right).offset(kWidth(13.0));
        make.height.mas_equalTo(kHeight(12.0));
    }];
    self.priceLabel = priceLabel;
    
    //天数
    UILabel *dayLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"/180天",MediumFont(font(11)),HEXColor(@"#FF4400"));
        label.textAlignment = NSTextAlignmentRight;
        [label sizeToFit];
    }];
    [self addSubview:dayLabel];
    [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(priceLabel);
        make.left.equalTo(priceLabel.mas_right);
        make.height.mas_equalTo(kHeight(12.0));
    }];
    
    self.dayLabel = dayLabel;
    
    //原来的价格
    UILabel *originPriceLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"￥1980",MediumFont(font(10)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [self addSubview:originPriceLabel];
    [originPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dayLabel.mas_right).offset(kWidth(8.0));
        make.height.mas_equalTo(kHeight(10.0));
        make.centerY.equalTo(priceLabel);
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
    lineView.backgroundColor = HEXColor(@"#EAEAEA");
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(kHeight(0.5));
    }];
}

//- (void)setViewModel:(BaseViewModel *)viewModel indexPath:(NSIndexPath *)indexPath {
//    HJSearchResultViewModel *listViewModel = (HJSearchResultViewModel *)viewModel;
//    CourseResponses *model = listViewModel.model.courseResponses[indexPath.row];
//    if(model){
//        [self.imgView sd_setImageWithURL:URL(model.coursepic) placeholderImage:V_IMAGE(@"占位图")];
//        self.courceLabel.text = model.coursename;
//        if(model.hassecond == 0){
//            self.youhuuiImaV.hidden = YES;
//            self.originPriceLabel.hidden = YES;
//            self.priceLineView.hidden = YES;
//            self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",model.coursemoney];
//            self.dayLabel.text = [NSString stringWithFormat:@"/%tu天",model.periods];
//        }else{
//            self.youhuuiImaV.hidden = NO;
//            self.originPriceLabel.hidden = NO;
//            self.priceLineView.hidden = NO;
//            
//            self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",model.secondprice.floatValue];
//            self.dayLabel.text = [NSString stringWithFormat:@"/%tu天",model.periods];
//            self.originPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",model.coursemoney];
//        }
//        
//        //设置星级
//        float fStaLevel = model.starlevel.floatValue;
//        if(fStaLevel == model.starlevel.intValue) {
//            for (int i = 0;i < 5 ;i++){
//                UIImageView *imaV = self.starImgMarr[i];
//                if(i < model.starlevel.intValue) {
//                    imaV.image = V_IMAGE(@"评价星亮色");
//                } else {
//                    imaV.image = V_IMAGE(@"评价星 暗色");
//                }
//            }
//        } else{
//            for (int i = 0;i < 5 ;i++){
//                UIImageView *imaV = self.starImgMarr[i];
//                if(i < ceilf(model.starlevel.floatValue) - 1) {
//                    imaV.image = V_IMAGE(@"评价星亮色");
//                }  else if(i == ceilf(model.starlevel.floatValue) - 1){
//                    imaV.image = V_IMAGE(@"评价星亮色-1");
//                } else {
//                    imaV.image = V_IMAGE(@"评价星 暗色");
//                }
//            }
//        }
//        
//        self.studentCountLabel.text = [NSString stringWithFormat:@"%.1f   %tu人学过",model.starlevel.floatValue,model.study_count];
//    }
//}

- (void)setModel:(CourseResponses *)model {
    _model = model;
    [self.imgView sd_setImageWithURL:URL(model.coursepic) placeholderImage:V_IMAGE(@"占位图") options:SDWebImageRefreshCached];
    self.courceLabel.text = model.coursename;
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
    
    //设置星级
    float fStaLevel = model.coursescore.floatValue;
    if(fStaLevel == model.coursescore.intValue) {
        for (int i = 0;i < 5 ;i++){
            UIImageView *imaV = self.starImgMarr[i];
            if(i < model.coursescore.intValue) {
                imaV.image = V_IMAGE(@"评价星亮色");
            } else {
                imaV.image = V_IMAGE(@"评价星 暗色");
            }
        }
    } else{
        for (int i = 0;i < 5 ;i++){
            UIImageView *imaV = self.starImgMarr[i];
            if(i < ceilf(model.coursescore.floatValue) - 1) {
                imaV.image = V_IMAGE(@"评价星亮色");
            }  else if(i == ceilf(model.coursescore.floatValue) - 1){
                imaV.image = V_IMAGE(@"评价星亮色-1");
            } else {
                imaV.image = V_IMAGE(@"评价星 暗色");
            }
        }
    }
    
    self.studentCountLabel.text = [NSString stringWithFormat:@"%.1f  %tu人学过",model.coursescore.floatValue,model.browsingcount];
}


@end
