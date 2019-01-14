//
//  HJCommonOrderListCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/8.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJCommonOrderListCell.h"
#import "HJMyOrderViewModel.h"
#import "HJMyOrderListModel.h"
@interface HJCommonOrderListCell ()

@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) UILabel *orderStateLabel;
@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIView *totalMoneyView;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIView *bottomOperationView;

@property (nonatomic,strong) UIButton *detailBtn;
@property (nonatomic,strong) UIButton *operationBtn;

@property (nonatomic,strong) UILabel *totalMoneyTextLabel;
@property (nonatomic,strong) UILabel *totalMoneyLabel;

@property (nonatomic,strong) HJMyOrderViewModel *listViewModel;
@property (nonatomic,strong) HJMyOrderListModel *model;

@end

@implementation HJCommonOrderListCell

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
        label.ljTitle_font_textColor(@"订单失效",MediumFont(font(11)),HEXColor(@"#333333"));
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
        make.height.mas_equalTo(kHeight(80));
    }];

    //合计金额
    UIView *totalMoneyView = [[UIView alloc] init];
    totalMoneyView.backgroundColor = white_color;
    [self addSubview:totalMoneyView];
    [totalMoneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(_scrollView.mas_bottom);
        make.height.mas_equalTo(kHeight(45));
    }];
    self.totalMoneyView = totalMoneyView;
    
    //合集的金额
    UILabel *totalMoneyLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"￥0.00",BoldFont(font(15)),HEXColor(@"#FF4400"));
        label.textAlignment = NSTextAlignmentRight;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [totalMoneyView addSubview:totalMoneyLabel];
    [totalMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(totalMoneyView);
        make.right.equalTo(totalMoneyView).offset(-kWidth(10.0));
    }];
    self.totalMoneyLabel = totalMoneyLabel;
    
    //
    UILabel *totalMoneyTextLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"共0门课程   合计: ",MediumFont(font(11)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentRight;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [totalMoneyView addSubview:totalMoneyTextLabel];
    [totalMoneyTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(totalMoneyLabel).offset(-kHeight(1.8));
        make.right.equalTo(totalMoneyLabel.mas_left).offset(-kWidth(5.0));
    }];
    
    self.totalMoneyTextLabel = totalMoneyTextLabel;
    
    //分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = Line_Color;
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(totalMoneyView.mas_bottom);
        make.height.mas_equalTo(kHeight(0.5));
    }];
    self.lineView = lineView;
    
    //底部操作按钮的操作
    UIView *bottomOperationView = [[UIView alloc] init];
    bottomOperationView.backgroundColor = white_color;
    [self addSubview:bottomOperationView];
    [bottomOperationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(lineView.mas_bottom);
        make.height.mas_equalTo(kHeight(45));
    }];
    self.bottomOperationView = bottomOperationView;
    
    //详情的按钮
    UIButton *detailBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"详情",MediumFont(font(13)),HEXColor(@"#22476B"),0);
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            NSDictionary *para = @{@"orderId" : self.model.orderno};
            [DCURLRouter pushURLString:@"route://orderDetailVC" query:para animated:YES];
        }];
    }];
    [bottomOperationView addSubview:detailBtn];
    [detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomOperationView);
        make.left.equalTo(self).offset(kWidth(10.0));
    }];
    
    self.detailBtn = detailBtn;
    
    //删除订单的按钮
    UIButton *deleteBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@" ",MediumFont(font(13)),HEXColor(@"#666666"),0);
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if(self.model.paystatus == 0) {
                //去支付
                [self payOperation];
            } else if (self.model.paystatus == 1) {
                //去学习
                if(self.model.courseResponses.count > 1) {
                    [DCURLRouter pushURLString:@"route://selectCourseVC" query:@{@"model" : self.model,
                                                                                 @"isToStudy" : @"1"
                                                                                 } animated:YES];
                }else {
                    CourseResponsesModel *model = self.model.courseResponses.lastObject;
                    [DCURLRouter pushURLString:@"route://classDetailVC" query:@{@"courseId" : model.courseid} animated:YES];
                }
                
            } else {
                //删除订单
                [TXAlertView showAlertWithTitle:@"温馨提示" message:@"确认要删除该订单吗?" cancelButtonTitle:@"取消" style:TXAlertViewStyleAlert buttonIndexBlock:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [self.listViewModel deleteOrderWithOrderId:self.model.orderno success:^{
                            if(self.backSub) {
                                [self.backSub sendNext:@""];
                            }
                        }];
                    }
                } otherButtonTitles:@"确定", nil];
            }
        }];
    }];
    [deleteBtn clipWithCornerRadius:kHeight(5.0) borderColor:HEXColor(@"#999999") borderWidth:kHeight(1.0)];
    [bottomOperationView addSubview:deleteBtn];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomOperationView);
        make.right.equalTo(self).offset(-kWidth(10.0));
        make.size.mas_equalTo(CGSizeMake(kWidth(70), kHeight(30)));
    }];
    
    self.operationBtn = deleteBtn;
    
    //支付成功之后进行的操作
}

- (void)payOperation {
    BOOL isLargeMoney = false;
    for(CourseResponsesModel *model in _model.courseResponses) {
        //不能推广是大额度
        if(model.ispromote == 0) {
            isLargeMoney = YES;
        }
    }
    RACSubject *backSubject = [[RACSubject alloc] init];
    @weakify(self);
    [backSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self dealSureOrderBtnWithIsLargeMoney:isLargeMoney];
    }];
    NSString *orderId = self.model.orderno;
    NSDictionary *para = @{@"isLargeMoney" : @(isLargeMoney),
                           @"subject" : backSubject,
                           @"orderId" : DealNil(orderId)
                           };
    [DCURLRouter pushURLString:@"route://buyCourseProtocolVC" query:para animated:YES];
}

//判断是小额还是大额
- (void)dealSureOrderBtnWithIsLargeMoney:(BOOL)isLargeMoney {
    //判断是大额支付还是小额支付
    if(isLargeMoney) {
        //大额联系客户
        [TXAlertView showAlertWithTitle:@"温馨提示" message:@"您现在购买的慧鲸学堂专属课程金额较大，请联系慧鲸客服(0571-57571670)完成支付，谢谢合作。" cancelButtonTitle:nil style:TXAlertViewStyleAlert buttonIndexBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                
            }
        } otherButtonTitles:@"我知道了", nil];
    } else {
        //小额支付
        NSString *orderId = self.model.orderno;
        NSString *couponid = self.model.cashcouponid.length > 0 ? self.model.cashcouponid : @"";
        [[HJPayTool shareInstance] payWithOrderId:orderId couponid:couponid];
    }
}

- (RACSubject *)backSub {
    if (!_backSub) {
        _backSub = [[RACSubject alloc] init];
    }
    return _backSub;
}

- (void)reloadScrollViewWithImageArr:(NSArray *)assets{
    [[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSUInteger assetCount = assets.count;
    CGFloat width = Screen_Width;
    CGFloat height = kHeight(80);
    for (NSInteger i = 0; i < assetCount; i++) {
        UIView *backView = [[UIView alloc] init];
        backView.frame = CGRectMake(0, i * height, width, height);
        backView.tag = i;
        backView.opaque = YES;
        backView.backgroundColor = HEXColor(@"#F5F5F5");
        UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTap:)];
        backView.userInteractionEnabled = YES;
        [backView addGestureRecognizer:backTap];
        [self.scrollView addSubview:backView];
        
        CourseResponsesModel *model = assets[i];
        
        UIImageView *imaV = [[UIImageView alloc] init];
        [imaV sd_setImageWithURL:URL(model.coursepic) placeholderImage:V_IMAGE(@"占位图") options:SDWebImageRefreshCached];
        imaV.backgroundColor = Background_Color;
        [backView addSubview:imaV];
        [imaV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(backView);
            make.left.equalTo(backView).offset(kWidth(10.0));
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
        [backView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imaV).offset(kHeight(5.0));
            make.left.equalTo(imaV.mas_right).offset(kWidth(10.0));
            make.right.equalTo(backView).offset(-kWidth(10));
        }];
        
        //有效期
        UILabel *limitTimeLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(@"",MediumFont(font(11.0)),HEXColor(@"#666666"));
            label.textAlignment = NSTextAlignmentLeft;
            [label sizeToFit];
        }];
        if(model.periods.integerValue <= 0) {
            limitTimeLabel.text = @"有效期限：";
        } else {
            limitTimeLabel.text = [NSString stringWithFormat:@"有效期限：%ld天",model.periods.integerValue];
        }
    
        [backView addSubview:limitTimeLabel];
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
        [backView addSubview:priceLabel];
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(limitTimeLabel);
            make.right.equalTo(backView).offset(-kWidth(10.0));
            make.height.mas_equalTo(kHeight(13.0));
        }];
        
        //原价的价格
        UILabel *originPriceLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor([NSString stringWithFormat:@"￥%.2f",originPrice],MediumFont(font(10)),HEXColor(@"#999999"));
            label.textAlignment = NSTextAlignmentRight;
            [label sizeToFit];
        }];
        [backView addSubview:originPriceLabel];
        [originPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(priceLabel.mas_left).offset(-kWidth(8.0));
            make.centerY.equalTo(priceLabel);
        }];
        
        //画线
        UIView *priceLineView= [[UIView alloc] init];
        priceLineView.backgroundColor = HEXColor(@"#999999");
        [backView addSubview:priceLineView];
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
    }
    self.scrollView.contentSize = CGSizeMake(Screen_Width , kHeight(80) * assetCount);
    [_scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self.topView.mas_bottom);
        make.height.mas_equalTo(kHeight(80) * assetCount);
    }];
}

- (void)setViewModel:(BaseViewModel *)viewModel indexPath:(NSIndexPath *)indexPath {
    HJMyOrderViewModel *listViewModel = (HJMyOrderViewModel *)viewModel;
    self.listViewModel = listViewModel;
    HJMyOrderListModel *model = (HJMyOrderListModel *)listViewModel.orderListArray[indexPath.row];
    self.model = model;
    
    NSDate *date = [NSDate dateWithString:model.ordercreatetime formatString:@"yyyy-MM-dd HH:mm:ss"];
    self.dateLabel.text = [NSString stringWithFormat:@"订单日期：  %ld.%@.%@",date.year,[NSString convertDateSingleData:date.month],[NSString convertDateSingleData:date.day]];
    if(model.paystatus == 0) {
        self.orderStateLabel.text = @"等待付款";
        self.orderStateLabel.textColor = HEXColor(@"#FF4400");
        
        [self.operationBtn setTitle:@"去支付" forState:UIControlStateNormal];
        [self.operationBtn setTitleColor:white_color forState:UIControlStateNormal];
        self.operationBtn.backgroundColor = HEXColor(@"#F12C2C");
        [self.operationBtn clipWithCornerRadius:kHeight(5.0) borderColor:HEXColor(@"#DD4F50") borderWidth:kHeight(1.0)];
    } else if (model.paystatus == 1) {
        self.orderStateLabel.text = @"购买成功";
        self.orderStateLabel.textColor = HEXColor(@"#333333");
        
        [self.operationBtn setTitle:@"去学习" forState:UIControlStateNormal];
        [self.operationBtn setTitleColor:white_color forState:UIControlStateNormal];
        self.operationBtn.backgroundColor = HEXColor(@"#22476B");
        [self.operationBtn clipWithCornerRadius:kHeight(5.0) borderColor:HEXColor(@"#22476B") borderWidth:kHeight(1.0)];
    } else {
        self.orderStateLabel.text = @"订单失效";
        self.orderStateLabel.textColor = HEXColor(@"#333333");
        
        [self.operationBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        [self.operationBtn setTitleColor:HEXColor(@"#666666") forState:UIControlStateNormal];
        self.operationBtn.backgroundColor = white_color;
        [self.operationBtn clipWithCornerRadius:kHeight(5.0) borderColor:HEXColor(@"#999999") borderWidth:kHeight(1.0)];
    }
    [self reloadScrollViewWithImageArr:model.courseResponses];
    
    //合计的价格
    NSString *totalMoney = [NSString stringWithFormat:@"¥%.2f",model.money];
    self.totalMoneyLabel.attributedText = [totalMoney attributeWithStr:@"¥" color:HEXColor(@"#FF4400") font:MediumFont(font(11))];
    //共计多少门课
    self.totalMoneyTextLabel.text = [NSString stringWithFormat:@"共%ld门课程   合计：  ",(unsigned long)model.courseResponses.count];
}

- (void)backTap:(UITapGestureRecognizer *)tap {
    CourseResponsesModel *model = self.model.courseResponses[tap.view.tag];
    [DCURLRouter pushURLString:@"route://classDetailVC" query:@{@"courseId" : model.courseid} animated:YES];
}

@end
