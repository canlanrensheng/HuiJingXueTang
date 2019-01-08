//
//  HJKillPriceOrderListCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/8.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJKillPriceOrderListCell.h"
#import "HJMyOrderViewModel.h"
#import "HJMyOrderListModel.h"

@interface HJKillPriceOrderListCell ()

@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) UILabel *orderStateLabel;
@property (nonatomic,strong) UILabel *killPriceStateLabel;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UILabel *lastTimeLabel;

@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIView *totalMoneyView;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIView *bottomOperationView;

@property (nonatomic,strong) UIImageView *courseImageView;
@property (nonatomic,strong) UILabel *courseNameLabel;
@property (nonatomic,strong) UILabel *limitDateLabel;
@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) UILabel *originPriceLabel;
@property (nonatomic,strong) UIView *originLineView;

@property (nonatomic,strong) UILabel *totalMoneyLabel;
@property (nonatomic,strong) UILabel *killedLabel;

@property (nonatomic,strong) UIButton *detailBtn;
@property (nonatomic,strong) UIButton *right1Btn;
@property (nonatomic,strong) UIButton *right2Btn;

@property (nonatomic,strong) HJMyOrderListModel *model;
@property (nonatomic,strong) CourseResponsesModel *courseModel;
@property (nonatomic,strong) HJMyOrderViewModel *listViewModel;

@end

@implementation HJKillPriceOrderListCell

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
        label.ljTitle_font_textColor(@"订单日期:  2018.10.21",MediumFont(font(11)),HEXColor(@"#333333"));
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
        label.ljTitle_font_textColor(@"砍价完成",MediumFont(font(13)),HEXColor(@"#FF4400"));
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
    
    self.orderStateLabel.hidden = YES;
    
    UILabel *killPriceStateLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"砍价中",MediumFont(font(13)),HEXColor(@"#FF4400"));
        label.textAlignment = NSTextAlignmentRight;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:killPriceStateLabel];
    [killPriceStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView).offset(kHeight(9));
        make.right.equalTo(self).offset(-kWidth(10.0));
        make.height.mas_equalTo(kHeight(13));
    }];
    self.killPriceStateLabel = killPriceStateLabel;
    
    UILabel *lastTimeLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"还剩22小时60分",MediumFont(font(10)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentRight;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:lastTimeLabel];
    [lastTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(killPriceStateLabel.mas_bottom).offset(kHeight(5.0));
        make.right.equalTo(self).offset(-kWidth(10.0));
        make.height.mas_equalTo(kHeight(10));
    }];
    self.lastTimeLabel = lastTimeLabel;
    
    
    //轮播图
    UIView *courseMessageView = [[UIView alloc] init];
    courseMessageView.opaque = YES;
    courseMessageView.backgroundColor = HEXColor(@"#F5F5F5");
    [self addSubview:courseMessageView];
    
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTap:)];
    courseMessageView.userInteractionEnabled = YES;
    [courseMessageView addGestureRecognizer:backTap];
    
    [courseMessageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(topView.mas_bottom);
        make.height.mas_equalTo(kHeight(80));
    }];
    
    UIImageView *imaV = [[UIImageView alloc] init];
    imaV.image = V_IMAGE(@"占位图");
    imaV.backgroundColor = Background_Color;
    [courseMessageView addSubview:imaV];
    [imaV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(courseMessageView);
        make.left.equalTo(courseMessageView).offset(kWidth(10.0));
        make.width.mas_equalTo(kWidth(97));
        make.height.mas_equalTo(kHeight(60));
    }];
    [imaV clipWithCornerRadius:kHeight(5.0) borderColor:nil borderWidth:0];
    self.courseImageView = imaV;
    
    //名称
    UILabel *nameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",BoldFont(font(13)),HEXColor(@"#333333"));
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
    self.courseNameLabel = nameLabel;
    
    //有效期
    UILabel *limitTimeLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"有效期限：",MediumFont(font(11.0)),HEXColor(@"#666666"));
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [courseMessageView addSubview:limitTimeLabel];
    [limitTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(imaV.mas_bottom).offset(-kHeight(5.0));
        make.left.equalTo(imaV.mas_right).offset(kWidth(10.0));
        make.height.mas_equalTo(kHeight(13.0));
    }];
    self.limitDateLabel = limitTimeLabel;
    
    //价格
    UILabel *priceLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"￥0.00",MediumFont(font(11.0)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentRight;
        [label sizeToFit];
    }];
    [courseMessageView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(limitTimeLabel);
        make.right.equalTo(courseMessageView).offset(-kWidth(10.0));
        make.height.mas_equalTo(kHeight(13.0));
    }];
    self.priceLabel = priceLabel;
    //原价的价格
    UILabel *originPriceLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"￥0.00",MediumFont(font(10)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentRight;
        [label sizeToFit];
    }];
    [courseMessageView addSubview:originPriceLabel];
    [originPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(priceLabel.mas_left).offset(-kWidth(8.0));
        make.centerY.equalTo(priceLabel);
    }];
    self.originPriceLabel = originPriceLabel;
    
    //画线
    UIView *priceLineView= [[UIView alloc] init];
    priceLineView.backgroundColor = HEXColor(@"#999999");
    [courseMessageView addSubview:priceLineView];
    [priceLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(originPriceLabel);
        make.left.right.equalTo(originPriceLabel);
        make.height.mas_equalTo(kHeight(0.5));
    }];
    self.originLineView = priceLineView;
    
    //合计金额
    UIView *totalMoneyView = [[UIView alloc] init];
    totalMoneyView.backgroundColor = white_color;
    [self addSubview:totalMoneyView];
    [totalMoneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(courseMessageView.mas_bottom);
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
        label.ljTitle_font_textColor(@"当前价格: ",MediumFont(font(11)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentRight;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [totalMoneyView addSubview:totalMoneyTextLabel];
    [totalMoneyTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(totalMoneyView);
        make.right.equalTo(totalMoneyLabel.mas_left);
    }];
    
    //已经砍的价格
    UILabel *killedLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"已砍0.00元   ",MediumFont(font(11)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentRight;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [totalMoneyView addSubview:killedLabel];
    [killedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(totalMoneyView);
        make.right.equalTo(totalMoneyTextLabel.mas_left);
    }];
    self.killedLabel = killedLabel;
    
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
        button.ljTitle_font_titleColor_state(@"最低可至0.00元!",BoldFont(font(14)),HEXColor(@"#F12C2C"),0);
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
    UIButton *right1Btn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@" ",MediumFont(font(13)),white_color,0);
        button.backgroundColor = HEXColor(@"#F12C2C");
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if(self.model.paystatus == 2) {
                //订单失效 删除订单的操作
                [TXAlertView showAlertWithTitle:@"温馨提示" message:@"确认要删除该订单吗?" cancelButtonTitle:@"取消" style:TXAlertViewStyleAlert buttonIndexBlock:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [self.listViewModel deleteOrderWithOrderId:self.model.orderno success:^{
                            [self.backSub sendNext:@""];
                        }];
                    }
                } otherButtonTitles:@"确定", nil];
            } else if (self.model.paystatus == 1) {
                //支付完成 去学习按钮
                CourseResponsesModel *model = self.model.courseResponses.lastObject;
                [DCURLRouter pushURLString:@"route://classDetailVC" query:@{@"courseId" : model.courseid} animated:YES];
            }else {
                //订单有效 砍价中 或者砍价已完成
                if(self.courseModel.bargainstatus.integerValue == 1) {
                    //砍价结束 去支付
                    [[HJPayTool shareInstance] payWithOrderId:self.model.orderno couponid:self.model.cashcouponid.length > 0 ? self.model.cashcouponid : @""];
                } else {
                    //砍价中的操作 继续砍价
                    NSString *courceName = @"动动手，快来帮我砍一刀";
                    NSString *coursedes = @"慧鲸学堂 全民砍价 乐享好课！在有效时限内砍价到最低价，即可享受最大购课优惠！";
                    id shareImg = self.courseModel.coursepic;
                    if(self.courseModel.coursepic.length <= 0) {
                        shareImg = V_IMAGE(@"shareImg");
                    }
                    
                    NSString *shareUrl = [NSString stringWithFormat:@"%@bargain?orderid=%@",API_SHAREURL,self.courseModel.orderid];
                    if([APPUserDataIofo UserID].length > 0) {
                        shareUrl = [NSString stringWithFormat:@"%@&userid=%@",shareUrl,[APPUserDataIofo UserID]];
                    }
                    [HJShareTool shareWithTitle:courceName content:coursedes images:@[shareImg] url:shareUrl];
                }
            }
        }];
    }];
    [right1Btn clipWithCornerRadius:kHeight(5.0) borderColor:HEXColor(@"#DD4F50") borderWidth:kHeight(1.0)];
    [bottomOperationView addSubview:right1Btn];
    [right1Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomOperationView);
        make.right.equalTo(self).offset(-kWidth(10.0));
        make.size.mas_equalTo(CGSizeMake(kWidth(70), kHeight(30)));
    }];
    
    self.right1Btn = right1Btn;
    
    //去支付的凑澳洲
    UIButton *right2Btn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@" ",MediumFont(font(13)),HEXColor(@"#666666"),0);
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            //订单有效 砍价中
//            if(self.courseModel.bargainstatus.integerValue == 0) {
                [[HJPayTool shareInstance] payWithOrderId:self.model.orderno couponid:self.model.cashcouponid.length > 0 ? self.model.cashcouponid : @""];
//            }
        }];
    }];
    [right2Btn clipWithCornerRadius:kHeight(5.0) borderColor:HEXColor(@"#999999") borderWidth:kHeight(1.0)];
    [bottomOperationView addSubview:right2Btn];
    [right2Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomOperationView);
        make.right.equalTo(right1Btn.mas_left).offset(-kWidth(10.0));
        make.size.mas_equalTo(CGSizeMake(kWidth(70), kHeight(30)));
    }];
    self.right2Btn = right2Btn;
}

- (RACSubject *)backSub {
    if (!_backSub) {
        _backSub = [[RACSubject alloc] init];
    }
    return _backSub;
}

- (void)setViewModel:(BaseViewModel *)viewModel indexPath:(NSIndexPath *)indexPath {
    HJMyOrderViewModel *listViewModel = (HJMyOrderViewModel *)viewModel;
    self.listViewModel = listViewModel;
    HJMyOrderListModel *model = (HJMyOrderListModel *)listViewModel.orderListArray[indexPath.row];
    self.model = model;
    
    NSDate *date = [NSDate dateWithString:model.ordercreatetime formatString:@"yyyy-MM-dd HH:mm:ss"];
    self.dateLabel.text = [NSString stringWithFormat:@"订单日期:  %ld.%@.%@",date.year,[NSString convertDateSingleData:date.month],[NSString convertDateSingleData:date.day]];
    
    CourseResponsesModel *courseModel = model.courseResponses.firstObject;
    self.courseModel = courseModel;
    
    if(model.paystatus == 2) {
        //订单失效
        self.orderStateLabel.hidden = NO;
        self.killPriceStateLabel.hidden = YES;
        self.lastTimeLabel.hidden = YES;
        
        self.orderStateLabel.text = @"订单失效";
        self.orderStateLabel.textColor = HEXColor(@"#333333");
        
        //详情按钮的展示
        self.detailBtn.userInteractionEnabled = YES;
        self.detailBtn.titleLabel.font = MediumFont(font(13));
        [self.detailBtn setTintColor:HEXColor(@"#22476B")];
        [self.detailBtn setTitle:@"详情" forState:UIControlStateNormal];
        
        //右边按钮的展示 //删除按钮
        self.right1Btn.hidden = NO;
        self.right2Btn.hidden = YES;
        [self.right1Btn setTitle:@"删除订单" forState:UIControlStateNormal];
        [self.right1Btn setTitleColor:HEXColor(@"#666666") forState:UIControlStateNormal];
        self.right1Btn.backgroundColor = white_color;
        [self.right1Btn clipWithCornerRadius:kHeight(5.0) borderColor:HEXColor(@"#999999") borderWidth:kHeight(1.0)];
        
    }else if (model.paystatus == 1) {
        //订单已完成
        self.right1Btn.hidden = NO;
        self.right2Btn.hidden = YES;
        [self.right1Btn setTitle:@"去学习" forState:UIControlStateNormal];
        [self.right1Btn setTitleColor:white_color forState:UIControlStateNormal];
        self.right1Btn.backgroundColor = HEXColor(@"#22476B");
        [self.right1Btn clipWithCornerRadius:kHeight(5.0) borderColor:HEXColor(@"#22476B") borderWidth:kHeight(1.0)];
    }else {
        //订单有效 砍价中 或者砍价已完成
        if(courseModel.bargainstatus.integerValue == 1) {
            //砍价结束
            self.orderStateLabel.hidden = NO;
            self.killPriceStateLabel.hidden = YES;
            self.lastTimeLabel.hidden = YES;
            
            self.orderStateLabel.text = @"砍价完成";
            self.orderStateLabel.textColor = HEXColor(@"#FF4400");
            
            self.detailBtn.userInteractionEnabled = NO;
            self.detailBtn.titleLabel.font = BoldFont(font(14));
            [self.detailBtn setTintColor:HEXColor(@"#F12C2C")];
            [self.detailBtn setTitle:@"已至最低!" forState:UIControlStateNormal];
            
            //右边按钮的展示 //去支付按钮
            self.right1Btn.hidden = NO;
            self.right2Btn.hidden = YES;
            [self.right1Btn setTitle:@"去支付" forState:UIControlStateNormal];
            [self.right1Btn setTitleColor:white_color forState:UIControlStateNormal];
            self.right1Btn.backgroundColor = HEXColor(@"#F12C2C");
            [self.right1Btn clipWithCornerRadius:kHeight(5.0) borderColor:HEXColor(@"#DD4F50") borderWidth:kHeight(1.0)];
        } else{
            //砍价中的操作
            self.orderStateLabel.hidden = YES;
            self.killPriceStateLabel.hidden = NO;
            self.lastTimeLabel.hidden = NO;
            
            self.detailBtn.userInteractionEnabled = NO;
            self.detailBtn.titleLabel.font = BoldFont(font(14));
            [self.detailBtn setTintColor:HEXColor(@"#F12C2C")];
            [self.detailBtn setTitle:[NSString stringWithFormat:@"最低可至%.2f元!" ,courseModel.bargaintoprice] forState:UIControlStateNormal];
            
            self.lastTimeLabel.text = courseModel.littiletime;
            
            self.right1Btn.hidden = NO;
            self.right2Btn.hidden = NO;
            //继续砍价
            [self.right1Btn setTitle:@"继续砍价" forState:UIControlStateNormal];
            [self.right1Btn setTitleColor:white_color forState:UIControlStateNormal];
            self.right1Btn.backgroundColor = HEXColor(@"#F12C2C");
            [self.right1Btn clipWithCornerRadius:kHeight(5.0) borderColor:HEXColor(@"#DD4F50") borderWidth:kHeight(1.0)];
            //去支付
            [self.right2Btn setTitle:@"去支付" forState:UIControlStateNormal];
            [self.right2Btn setTitleColor:HEXColor(@"#666666") forState:UIControlStateNormal];
            self.right2Btn.backgroundColor = white_color;
            [self.right2Btn clipWithCornerRadius:kHeight(5.0) borderColor:HEXColor(@"#999999") borderWidth:kHeight(1.0)];
        }
    }
    
    [self.courseImageView sd_setImageWithURL:URL(courseModel.coursepic) placeholderImage:V_IMAGE(@"占位图")];
    self.courseNameLabel.text = courseModel.coursename;
    if(courseModel.periods.integerValue <= 0) {
        self.limitDateLabel.text = @"有效期限：";
    } else {
        self.limitDateLabel.text = [NSString stringWithFormat:@"有效期限：%ld天",courseModel.periods.integerValue];
    }
    
    
    CGFloat price = 0;
    CGFloat originPrice = 0;
    if (courseModel.hassecond == 1) {
        //有秒杀价
        price  = courseModel.secondprice;
        originPrice = courseModel.purchasemoney;
        
        self.originLineView.hidden = NO;
        self.originPriceLabel.hidden = NO;
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",price];
        self.originPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",originPrice];
    } else {
        //没有秒杀价
        price = courseModel.purchasemoney;
        
        self.originLineView.hidden = YES;
        self.originPriceLabel.hidden = YES;
        
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",price];
    }
    
    //当前的价格
    NSString *totalMoney = [NSString stringWithFormat:@"¥%.2f",courseModel.currentprice];
    self.totalMoneyLabel.attributedText = [totalMoney attributeWithStr:@"¥" color:HEXColor(@"#FF4400") font:MediumFont(font(11))];
    
    //已经砍到的价格
    NSString *killPrice = [NSString stringWithFormat:@"已砍%.2f元   ",courseModel.feepromotemoney];
    self.killedLabel.attributedText = [killPrice attributeWithStr:@"¥" color:HEXColor(@"#FF4400") font:MediumFont(font(11))];
}

- (void)backTap:(UITapGestureRecognizer *)tap {
    CourseResponsesModel *model = self.model.courseResponses[tap.view.tag];
    [DCURLRouter pushURLString:@"route://classDetailVC" query:@{@"courseId" : model.courseid} animated:YES];
}

@end
