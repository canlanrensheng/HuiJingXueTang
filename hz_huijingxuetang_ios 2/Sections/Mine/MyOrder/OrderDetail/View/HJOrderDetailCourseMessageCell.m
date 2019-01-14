//
//  HJOrderDetailCourseMessageCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/8.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJOrderDetailCourseMessageCell.h"

@interface HJOrderDetailCourseMessageCell ()

@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) UILabel *orderStateLabel;
@property (nonatomic,strong) UILabel *finishDateLabel;
@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIView *totalMoneyView;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIView *bottomOperationView;

@end

@implementation HJOrderDetailCourseMessageCell

- (void)hj_configSubViews {
    self.backgroundColor = Background_Color;
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = white_color;
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(kHeight(45));
    }];
    
    self.topView = topView;
    //时间
    UILabel *timeLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"订单日期:  ",MediumFont(font(11)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.left.equalTo(self).offset(kWidth(10.0));
    }];
    self.dateLabel = timeLabel;
    
    //订单的状态
    UILabel *orderStateLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"购买成功",MediumFont(font(13)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentRight;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:orderStateLabel];
    [orderStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.right.equalTo(self).offset(-kWidth(10.0));
    }];
    self.orderStateLabel = orderStateLabel;
    
    //轮播图
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = white_color;
    _scrollView.opaque = YES;
    _scrollView.scrollEnabled = YES;
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(topView.mas_bottom);
        make.height.mas_equalTo(kHeight(125.0));
    }];
    
}

- (void)reloadScrollViewWithImageArr:(NSArray *)assets{
    [[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSUInteger assetCount = assets.count;
    CGFloat width = Screen_Width;
    CGFloat height = kHeight(80 + 45.0);
    for (NSInteger i = 0; i < assetCount; i++) {
        UIView *backView = [[UIView alloc] init];
        backView.frame = CGRectMake(0, i * height, width, height);
        backView.tag = i;
        backView.opaque = YES;
        backView.backgroundColor = white_color;
        [self.scrollView addSubview:backView];
        
        UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTap:)];
        backView.userInteractionEnabled = YES;
        [backView addGestureRecognizer:backTap];
        
        CourseResponsesModel *model = assets[i];
        
        UIView *courseMessageView = [[UIView alloc] init];
        courseMessageView.backgroundColor = HEXColor(@"#F5F5F5");
        [backView addSubview:courseMessageView];
        [courseMessageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(backView);
            make.height.mas_equalTo(kHeight(80.0));
        }];
        
        UIImageView *imaV = [[UIImageView alloc] init];
        [imaV sd_setImageWithURL:URL(model.coursepic) placeholderImage:V_IMAGE(@"占位图") options:SDWebImageRefreshCached];
        imaV.backgroundColor = Background_Color;
        [courseMessageView addSubview:imaV];
        [imaV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(courseMessageView);
            make.left.equalTo(courseMessageView).offset(kWidth(10.0));
            make.width.mas_equalTo(kWidth(97));
            make.height.mas_equalTo(kHeight(60));
        }];
        [imaV clipWithCornerRadius:kHeight(5.0) borderColor:nil borderWidth:0];
        
        //名称
        UILabel *nameLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(model.coursename,BoldFont(font(13)),HEXColor(@"#333333"));
            label.textAlignment = NSTextAlignmentLeft;
            label.numberOfLines = 2.0;
            [label sizeToFit];
        }];
        [courseMessageView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imaV).offset(kHeight(5.0));
            make.left.equalTo(imaV.mas_right).offset(kWidth(10.0));
            make.right.equalTo(courseMessageView).offset(-kWidth(10));
        }];
        
        //有效期
        UILabel *limitTimeLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor([NSString stringWithFormat:@"有效期限：%@天",model.periods],MediumFont(font(11.0)),HEXColor(@"#666666"));
            label.textAlignment = NSTextAlignmentLeft;
            [label sizeToFit];
        }];
        [courseMessageView addSubview:limitTimeLabel];
        [limitTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(imaV.mas_bottom).offset(-kHeight(5.0));
            make.left.equalTo(imaV.mas_right).offset(kWidth(10.0));
            make.height.mas_equalTo(kHeight(13.0));
        }];
        
        CGFloat price = 0;
        CGFloat originPrice = 0;
        if (model.hassecond == 1) {
            //有秒杀价
            price  = model.secondprice;
            originPrice = model.purchasemoney;
        } else {
            //没有秒杀价
            price = model.purchasemoney;
        }
        
        //价格
        UILabel *priceLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor([NSString stringWithFormat:@"￥%.2f",price],MediumFont(font(11.0)),HEXColor(@"#333333"));
            label.textAlignment = NSTextAlignmentRight;
            [label sizeToFit];
        }];
        [courseMessageView addSubview:priceLabel];
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(limitTimeLabel);
            make.right.equalTo(courseMessageView).offset(-kWidth(10.0));
            make.height.mas_equalTo(kHeight(13.0));
        }];
        
        //原价的价格
        UILabel *originPriceLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor([NSString stringWithFormat:@"￥%.2f",originPrice],MediumFont(font(10)),HEXColor(@"#999999"));
            label.textAlignment = NSTextAlignmentRight;
            [label sizeToFit];
        }];
        [courseMessageView addSubview:originPriceLabel];
        [originPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(priceLabel.mas_left).offset(-kWidth(8.0));
            make.centerY.equalTo(priceLabel);
        }];
        
        //画线
        UIView *priceLineView= [[UIView alloc] init];
        priceLineView.backgroundColor = HEXColor(@"#999999");
        [courseMessageView addSubview:priceLineView];
        [priceLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(originPriceLabel);
            make.left.right.equalTo(originPriceLabel);
            make.height.mas_equalTo(kHeight(0.5));
        }];
        
        if (model.hassecond == 1) {
            //有秒杀价
            originPriceLabel.hidden = NO;
            priceLineView.hidden = NO;
        } else {
            //没有秒杀价
            originPriceLabel.hidden = YES;
            priceLineView.hidden = YES;
        }
        
        //合计金额
        UIView *totalMoneyView = [[UIView alloc] init];
        totalMoneyView.backgroundColor = white_color;
        [backView addSubview:totalMoneyView];
        [totalMoneyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(courseMessageView.mas_bottom);
            make.height.mas_equalTo(kHeight(45));
        }];
        
        //订单的状态
        UILabel *finishDateLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(@"成交日期:      等待支付",MediumFont(font(11)),HEXColor(@"#333333"));
            label.textAlignment = NSTextAlignmentRight;
            label.numberOfLines = 0;
            [label sizeToFit];
        }];
        [totalMoneyView addSubview:finishDateLabel];
        [finishDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(totalMoneyView);
            make.right.equalTo(totalMoneyView).offset(-kWidth(10.0));
            make.height.mas_equalTo(kHeight(11.0));
        }];
        
        NSString *finishDataString =  @"成交日期:      等待支付";
        finishDateLabel.attributedText = [finishDataString attributeWithStr:@"成交日期:" color:HEXColor(@"#999999") font:MediumFont(font(11))];
        finishDateLabel.hidden = YES;
        
        //成交日期
        NSDate *date = [NSDate dateWithString:self.model.paytime formatString:@"yyyy-MM-dd HH:mm:ss"];
        UILabel *buySuccessFinishDateLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(@"",MediumFont(font(11)),HEXColor(@"#333333"));
            label.textAlignment = NSTextAlignmentRight;
            label.numberOfLines = 0;
            [label sizeToFit];
        }];
        NSString *dateString = [NSString stringWithFormat:@"成交日期：  %@.%@.%@",[NSString stringWithFormat:@"%ld",(long)date.year],[NSString convertDateSingleData:date.month],[NSString convertDateSingleData:date.day]];
        buySuccessFinishDateLabel.attributedText = [dateString attributeWithStr:@"成交日期：" color:HEXColor(@"#999999") font:MediumFont(font(11))];
        [totalMoneyView addSubview:buySuccessFinishDateLabel];
        [buySuccessFinishDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(totalMoneyView).offset(kHeight(9));
            make.right.equalTo(totalMoneyView).offset(-kWidth(10.0));
            make.height.mas_equalTo(kHeight(11.0));
        }];

        
        NSDate *lastTimeDate = [NSDate dateWithString:model.courseexpirydate formatString:@"yyyy-MM-dd HH:mm:ss"];
        UILabel *lastTimeLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(@"",MediumFont(font(11)),HEXColor(@"#333333"));
            label.textAlignment = NSTextAlignmentRight;
            label.numberOfLines = 0;
            [label sizeToFit];
        }];
        
        NSString *lastTimeDateString = [NSString stringWithFormat:@"有效期至：  %@.%@.%@",[NSString stringWithFormat:@"%ld",(long)lastTimeDate.year],[NSString convertDateSingleData:lastTimeDate.month],[NSString convertDateSingleData:lastTimeDate.day]];
        lastTimeLabel.attributedText = [lastTimeDateString attributeWithStr:@"有效期至：" color:HEXColor(@"#999999") font:MediumFont(font(11))];
        [totalMoneyView addSubview:lastTimeLabel];
        [lastTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(buySuccessFinishDateLabel.mas_bottom).offset(kHeight(4.0));
            make.right.equalTo(totalMoneyView).offset(-kWidth(10.0));
            make.height.mas_equalTo(kHeight(11.0));
        }];
        
        if (self.model.paystatus == 1) {
            //已支付
            finishDateLabel.hidden = YES;
            buySuccessFinishDateLabel.hidden = NO;
            lastTimeLabel.hidden = NO;
        } else {
            //待支付或者订单失效
            finishDateLabel.hidden = NO;
            buySuccessFinishDateLabel.hidden = YES;
            lastTimeLabel.hidden = YES;
        }
    }
    self.scrollView.contentSize = CGSizeMake(Screen_Width , kHeight(80) * assetCount);
    [_scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self.topView.mas_bottom);
        make.height.mas_equalTo(kHeight(80 + 45) * assetCount);
    }];
}

- (void)setModel:(HJMyOrderListModel *)model {
    _model = model;
    NSDate *date = [NSDate dateWithString:model.ordercreatetime formatString:@"yyyy-MM-dd HH:mm:ss"];
    self.dateLabel.text = [NSString stringWithFormat:@"订单日期:  %ld.%@.%@",(long)date.year,[NSString convertDateSingleData:date.month],[NSString convertDateSingleData:date.day]];
    if(model.paystatus == 0) {
        self.orderStateLabel.text = @"等待付款";
        self.orderStateLabel.textColor = HEXColor(@"#FF4400");
    } else if (model.paystatus == 1) {
        self.orderStateLabel.text = @"购买成功";
        self.orderStateLabel.textColor = HEXColor(@"#333333");
    } else {
        self.orderStateLabel.text = @"订单失效";
        self.orderStateLabel.textColor = HEXColor(@"#333333");
    }
    [self reloadScrollViewWithImageArr:_model.courseResponses];
}

- (void)backTap:(UITapGestureRecognizer *)tap {
    CourseResponsesModel *model = self.model.courseResponses[tap.view.tag];
    [DCURLRouter pushURLString:@"route://classDetailVC" query:@{@"courseId" : model.courseid} animated:YES];
}



@end
