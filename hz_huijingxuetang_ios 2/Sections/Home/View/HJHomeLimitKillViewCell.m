//
//  HJHomeLimitKillView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/22.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJHomeLimitKillViewCell.h"
#import "HJHomeLimitKillModel.h"
#import "HJHomeViewModel.h"
@interface HJHomeLimitKillViewCell ()

@property (nonatomic,strong) HJHomeViewModel *listViewModel;
@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation HJHomeLimitKillViewCell

- (void)hj_configSubViews {
    self.backgroundColor = white_color;
    //轮播图
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = white_color;
    _scrollView.scrollEnabled = YES;
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(10));
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.height.mas_equalTo(kHeight(170 + 10.0));
    }];
}

- (void)reloadScrollViewWithImageArr:(NSArray *)assets{
    [[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSUInteger assetCount = assets.count;
    CGFloat width = kWidth(143);
    CGFloat height = kHeight(170);
    
    CGFloat padding = kWidth(10.0);
    for (NSInteger i = 0; i < assetCount; i++) {
        UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake((width + padding) * i + kWidth(5.0), kHeight(5.0), width, height)];
        shadowView.backgroundColor = clear_color;
        
        shadowView.layer.cornerRadius = 8.0;
        shadowView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        shadowView.layer.shadowOpacity = 0.2;
        shadowView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1].CGColor;
        
        [self.scrollView addSubview:shadowView];
        
        UIView *backView = [[UIView alloc] init];
        backView.frame = CGRectMake(0 , 0 , width , height);
        backView.backgroundColor = white_color;
        backView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTap:)];
        [backView addGestureRecognizer:tap];
        [shadowView addSubview:backView];

        [backView clipWithCornerRadius:kHeight(5.0) borderColor:nil borderWidth:0.0];

        HJHomeLimitKillModel *model = assets[i];
        //图片
        UIImageView *imaV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, kHeight(85.0))];
        [imaV sd_setImageWithURL:URL(model.coursepic) placeholderImage:V_IMAGE(@"占位图") options:SDWebImageRefreshCached];
        [backView addSubview:imaV];
        [imaV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(backView);
            make.height.mas_equalTo(kHeight(85));
        }];
        [imaV setCornerOnTop:kHeight(5.0)];

        //标题
        UILabel *faultCodeLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(model.coursename,BoldFont(font(14)),HEXColor(@"#333333"));
            [label sizeToFit];
        }];
        [backView addSubview:faultCodeLabel];
        [faultCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imaV.mas_bottom).offset(kHeight(10.0));
            make.left.equalTo(backView).offset(kWidth(5.0));
            make.right.equalTo(backView).offset(-kWidth(5.0));
            make.height.mas_equalTo(kHeight(14));
        }];

        //价格
        UILabel *priceLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(@"",BoldFont(font(15)),HEXColor(@"#FF4400"));
            [label sizeToFit];
        }];
        NSString *price = [NSString stringWithFormat:@"¥%.2f",model.secondprice.floatValue];
        priceLabel.attributedText = [price attributeWithStr:@"¥" color:HEXColor(@"#FF4400") font:BoldFont(font(11))];
        [backView addSubview:priceLabel];
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(faultCodeLabel.mas_bottom).offset(kHeight(9.0));
            make.left.equalTo(backView).offset(kWidth(5.0));
            make.height.mas_equalTo(kHeight(14));
        }];

        //原来的价格
        UILabel *originPriceLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor([NSString stringWithFormat:@"%.2f",model.coursemoney],MediumFont(font(11)),HEXColor(@"#999999"));
            [label sizeToFit];
        }];
        [backView addSubview:originPriceLabel];
        [originPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(priceLabel);
            make.left.equalTo(priceLabel.mas_right).offset(kWidth(5.0));
            make.height.mas_equalTo(kHeight(8.0));
        }];

        //画线
        UIView *priceLineView= [[UIView alloc] init];
        priceLineView.backgroundColor = HEXColor(@"#999999");
        [backView addSubview:priceLineView];
        [priceLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(priceLabel);
            make.left.right.equalTo(originPriceLabel);
            make.height.mas_equalTo(kHeight(0.5));
        }];

        //只剩下多少小时
        NSDate *endDate = [NSDate dateWithString:model.endtime formatString:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *startDate = [NSDate date];
        DTTimePeriod *timePeriod =[[DTTimePeriod alloc] initWithStartDate:startDate endDate:endDate];
        double  durationInSeconds  = [timePeriod durationInSeconds];
        NSInteger ms = durationInSeconds;
        NSInteger ss = 1;
        NSInteger mi = ss * 60;
        NSInteger hh = mi * 60;
        NSInteger dd = hh * 24;
        // 剩余的
        NSInteger day = ms / dd;// 天
        NSInteger hour = (ms - day * dd) / hh;// 时
        UILabel *leftTimeLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor([NSString stringWithFormat:@"只剩%@天%@小时",[NSString convertDateSingleData:day],[NSString convertDateSingleData:hour]],MediumFont(font(10)),HEXColor(@"#999999"));
            [label sizeToFit];
        }];
//        DLog(@"获取到的数据是:%ld %.0f",[endDate daysFrom:startDate],[endDate hoursFrom:startDate]);
        [backView addSubview:leftTimeLabel];
        [leftTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(backView).offset(-kHeight(11.0));
            make.left.equalTo(backView).offset(kWidth(5.0));
            make.height.mas_equalTo(kHeight(10));
        }];

        //立即抢购
        UIButton *killBtn = [UIButton creatButton:^(UIButton *button) {
            button.ljTitle_font_titleColor_state(@"立即抢购",MediumFont(font(11)),white_color,0);
            button.backgroundColor = HEXColor(@"#FF4400");
            button.userInteractionEnabled = NO;
            [button clipWithCornerRadius:kHeight(2.5) borderColor:nil borderWidth:0];

        }];
        [backView addSubview:killBtn];
        [killBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backView).offset(-kWidth(5.0));
            make.bottom.equalTo(backView).offset(-kHeight(5.0));
            make.size.mas_equalTo(CGSizeMake(kWidth(58), kHeight(23)));
        }];
    }
    self.scrollView.contentSize = CGSizeMake((width + padding) * assetCount, kHeight(170 + 5.0));
}
//
//- (void)getDetailTimeWithTimestamp:(NSInteger)timestamp{
//    NSInteger ms = timestamp;
//    NSInteger ss = 1;
//    NSInteger mi = ss * 60;
//    NSInteger hh = mi * 60;
//    NSInteger dd = hh * 24;
//    
//    // 剩余的
//    NSInteger day = ms / dd;// 天
//    NSInteger hour = (ms - day * dd) / hh;// 时
//    NSInteger minute = (ms - day * dd - hour * hh) / mi;// 分
//    NSInteger second = (ms - day * dd - hour * hh - minute * mi) / ss;// 秒
//    
//    self.dayLabel.text = [NSString stringWithFormat:@"%@",[NSString convertDateSingleData:day]];
//    self.hourLabel.text = [NSString stringWithFormat:@"%@",[NSString convertDateSingleData:hour]];
//    self.minuesLabel.text = [NSString stringWithFormat:@"%@",[NSString convertDateSingleData:minute]];
//    self.secondsLabel.text = [NSString stringWithFormat:@"%@",[NSString convertDateSingleData:second]];
//    
//}

- (void)setCornerOnTop:(CGFloat )cornerRadius view:(UIView *)view{
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                     byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                           cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}


- (void)backTap:(UITapGestureRecognizer *)tap {
    HJHomeLimitKillModel *model = self.listViewModel.limitKillArray[tap.view.tag];
    [DCURLRouter pushURLString:@"route://classDetailVC" query:@{@"courseId" : model.courseid .length > 0 ? model.courseid : @""} animated:YES];
}

- (void)setViewModel:(BaseViewModel *)viewModel indexPath:(NSIndexPath *)indexPath {
    HJHomeViewModel *listViewModel = (HJHomeViewModel *)viewModel;
    self.listViewModel = listViewModel;
    if (listViewModel.limitKillArray.count > 0) {
        [self reloadScrollViewWithImageArr:listViewModel.limitKillArray];
    }
}

@end
