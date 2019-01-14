//
//  HJHomeCourseRecommendedView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/22.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJHomeCourseRecommendedViewCell.h"
#import "HJHomeViewModel.h"
#import "HJHomeCourseRecommendedModel.h"
@interface HJHomeCourseRecommendedViewCell ()

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

@end


@implementation HJHomeCourseRecommendedViewCell

- (void)hj_configSubViews {
    
    //图片
    UIImageView *imaV = [[UIImageView alloc] init];
    imaV.opaque = YES;
    //    imaV.image = V_IMAGE(@"占位图");
    imaV.backgroundColor = Background_Color;
    [self addSubview:imaV];
    [imaV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self);
//        make.left.equalTo(self).offset(kWidth(10.0));
//        make.width.mas_equalTo(kWidth(145));
//        make.height.mas_equalTo(kHeight(90));
        make.top.equalTo(self).offset(kHeight(10.0));
        make.left.equalTo(self).offset(kWidth(10.0));
        make.width.mas_equalTo(kWidth(145));
        make.height.mas_equalTo(kHeight(90));
    }];
    [imaV clipWithCornerRadius:kHeight(5.0) borderColor:nil borderWidth:0];
    self.imgV = imaV;
    
    UIImageView *youhuuiImaV = [[UIImageView alloc] init];
    youhuuiImaV.image = V_IMAGE(@"优惠标签");
    youhuuiImaV.opaque = YES;
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
        label.opaque = YES;
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
    starView.opaque = YES;
    [self addSubview:starView];
    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.top.equalTo(nameLabel.mas_bottom).offset(kHeight(8.0));
        make.height.mas_equalTo(kHeight(11));
    }];
    
    self.starImgMarr = [NSMutableArray array];
    for(int i = 0; i < 5;i++) {
        UIImageView *starImageView = [[UIImageView alloc] init];
        starImageView.opaque = YES;
        starImageView.frame = CGRectMake((kWidth(2 + 11) * i), 0, kWidth(11), kWidth(11));
        starImageView.backgroundColor = white_color;
        [starView addSubview:starImageView];
        [self.starImgMarr addObject:starImageView];
    }
    
    //星级Label
    CGFloat leftWith = kWidth(11) * 5 + kWidth(2) * 4 + kWidth(12) + kWidth(5.0);
    UILabel *starCountLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor([NSString stringWithFormat:@"4.9 %tu人学过",960],MediumFont(font(11)),HEXColor(@"#999999"));
        label.opaque = YES;
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
        label.opaque = YES;
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
        label.opaque = YES;
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
        label.opaque = YES;
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
        label.opaque = YES;
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
    priceLineView.opaque = YES;
    [self addSubview:priceLineView];
    [priceLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(originPriceLabel);
        make.left.right.equalTo(originPriceLabel);
        make.height.mas_equalTo(kHeight(0.5));
    }];
    self.priceLineView = priceLineView;
    
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = Line_Color;
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(10.0));
        make.bottom.equalTo(self);
        make.right.equalTo(self).offset(-kWidth(10.0));
        make.height.mas_equalTo(kHeight(0.5));
    }];
}

//fuyu
- (void)setViewModel:(BaseViewModel *)viewModel indexPath:(NSIndexPath *)indexPath {
    HJHomeViewModel *listViewModel = (HJHomeViewModel *)viewModel;
    HJHomeCourseRecommendedModel *model = listViewModel.recommongCourceDataArray[indexPath.row];
    if(model){
        [self.imgV sd_setImageWithURL:URL(model.coursepic) placeholderImage:V_IMAGE(@"占位图") options:SDWebImageRefreshCached];
        self.courceLabel.text = model.coursename;
        
        if(MaJia) {
            self.youhuuiImaV.hidden = YES;
            self.originPriceLabel.hidden = YES;
            self.priceLineView.hidden = YES;
            self.priceLabel.hidden = YES;
            self.dayLabel.hidden = YES;
        } else {
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
        }
        
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
        
        self.studentCountLabel.text = [NSString stringWithFormat:@"%.1f   %tu人学过",model.starlevel.floatValue,model.study_count];
        self.teacherLabel.text = [NSString stringWithFormat:@"讲师：%@",model.realname];
    }
    
    if(indexPath.row == 0) {
//        self.backgroundColor = red_color;
        [self.imgV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(0);
            make.left.equalTo(self).offset(kWidth(10.0));
            make.width.mas_equalTo(kWidth(145));
            make.height.mas_equalTo(kHeight(90));
        }];
    } else {
//        self.backgroundColor = yellow_color;
        [self.imgV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(kHeight(10.0));
            make.left.equalTo(self).offset(kWidth(10.0));
            make.width.mas_equalTo(kWidth(145));
            make.height.mas_equalTo(kHeight(90));
        }];
    }
}

@end
