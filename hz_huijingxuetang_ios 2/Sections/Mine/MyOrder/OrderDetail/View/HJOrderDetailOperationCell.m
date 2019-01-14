//
//  HJOrderDetailOperationCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/8.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJOrderDetailOperationCell.h"

@interface HJOrderDetailOperationCell ()

@property (nonatomic,strong) UIButton *right1Btn;
@property (nonatomic,strong) UIButton *right2Btn;

@end

@implementation HJOrderDetailOperationCell

- (void)hj_configSubViews {
    self.backgroundColor = Background_Color;
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = white_color;
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(kHeight(45.0));
    }];
    
    //右一按钮
    UIButton *right1Btn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"",MediumFont(font(13)),white_color,0);
        button.backgroundColor = HEXColor(@"#F12C2C");
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if(_model.paystatus == 0) {
                //等待支付 去支付按钮
                [self payOperation];
            } else if (_model.paystatus == 1) {
                //购买成功 去学习
                if(self.model.courseResponses.count > 1) {
                    [DCURLRouter pushURLString:@"route://selectCourseVC" query:@{@"model" : self.model,
                                                                                 @"isToStudy" : @"1"
                                                                                 } animated:YES];
                } else {
                    CourseResponsesModel *model = self.model.courseResponses.lastObject;
                    [DCURLRouter pushURLString:@"route://classDetailVC" query:@{@"courseId" : model.courseid} animated:YES];
                }
               
            } else {
                //订单失效 删除订单
                [TXAlertView showAlertWithTitle:@"温馨提示" message:@"确认要删除该订单吗?" cancelButtonTitle:@"取消" style:TXAlertViewStyleAlert buttonIndexBlock:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [self.viewModel deleteOrderWithOrderId:self.model.orderno success:^{
                           [self.backSub sendNext:@""];
                        }];
                    }
                } otherButtonTitles:@"确定", nil];
            }
        }];
    }];
    [right1Btn clipWithCornerRadius:kHeight(5.0) borderColor:HEXColor(@"#DD4F50") borderWidth:kHeight(1.0)];
    [topView addSubview:right1Btn];
    [right1Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.right.equalTo(self).offset(-kWidth(10.0));
        make.size.mas_equalTo(CGSizeMake(kWidth(70), kHeight(30)));
    }];
    self.right1Btn = right1Btn;
    
    //右二按钮
    UIButton *right2Btn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"",MediumFont(font(13)),HEXColor(@"#666666"),0);
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            //去评价的操作
            if (_model.paystatus == 1) {
                //购买成功 去评价
                 if(self.model.courseResponses.count > 1) {
                     [DCURLRouter pushURLString:@"route://selectCourseVC" query:@{@"model" : self.model,
                                                                                  @"isToStudy" : @"0"
                                                                                  } animated:YES];
                 } else {
                     RACSubject *backSubject = [[RACSubject alloc] init];
                     [backSubject subscribeNext:^(id  _Nullable x) {
                         [self.backSub sendNext:nil];
                     }];
                     CourseResponsesModel *model = self.model.courseResponses.lastObject;
                     [DCURLRouter pushURLString:@"route://postEvaluationVC" query:@{@"subject" : backSubject,
                                                                                    @"courseid" : model.courseid
                                                                                    } animated:YES];

                 }
                
            }
        }];
    }];
    [right2Btn clipWithCornerRadius:kHeight(5.0) borderColor:HEXColor(@"#999999") borderWidth:kHeight(1.0)];
    [topView addSubview:right2Btn];
    [right2Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.right.equalTo(right1Btn.mas_left).offset(-kWidth(10.0));
        make.size.mas_equalTo(CGSizeMake(kWidth(70), kHeight(30)));
    }];
    
    self.right2Btn = right2Btn;
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
        NSString *couponid = self.viewModel.model.cashcouponid.length > 0 ? self.viewModel.model.cashcouponid : @"";
        [[HJPayTool shareInstance] payWithOrderId:orderId couponid:couponid];
    }
}

- (void)setModel:(HJMyOrderListModel *)model {
    _model = model;
    if(model.paystatus == 0) {
        //等待支付 去支付按钮
        self.right2Btn.hidden = YES;
        self.right1Btn.backgroundColor = HEXColor(@"#F12C2C");
        [self.right1Btn setTitle:@"去支付" forState:UIControlStateNormal];
        [self.right1Btn setTitleColor:white_color forState:UIControlStateNormal];
        [self.right1Btn clipWithCornerRadius:kHeight(5.0) borderColor:HEXColor(@"#F12C2C") borderWidth:kHeight(1.0)];
        
    } else if (model.paystatus == 1) {
        //购买成功 去评价 去学习
       
        BOOL isNotComment = NO;
        for (CourseResponsesModel *courseModel in _model.courseResponses) {
            if([courseModel.courseCommentStatus isEqualToString:@"n"]){
                isNotComment = YES;
                break;
            }
        }
        if(isNotComment) {
            //没有评价
             self.right2Btn.hidden = NO;
             self.right2Btn.backgroundColor = white_color;
             [self.right2Btn setTitle:@"去评价" forState:UIControlStateNormal];
             [self.right2Btn setTitleColor:HEXColor(@"#DD9C50") forState:UIControlStateNormal];
             [self.right2Btn clipWithCornerRadius:kHeight(5.0) borderColor:HEXColor(@"#DD9C50") borderWidth:kHeight(1.0)];
        } else {
            //已经评价
             self.right2Btn.hidden = YES;
        }
        
        self.right1Btn.backgroundColor = HEXColor(@"#22476B");
        [self.right1Btn setTitle:@"去学习" forState:UIControlStateNormal];
        [self.right1Btn setTitleColor:white_color forState:UIControlStateNormal];
        [self.right1Btn clipWithCornerRadius:kHeight(5.0) borderColor:HEXColor(@"#22476B") borderWidth:kHeight(1.0)];
        
    } else {
        //订单失效 删除订单
        self.right2Btn.hidden = YES;
        self.right1Btn.backgroundColor = white_color;
        [self.right1Btn setTitle:@"删除订单" forState:UIControlStateNormal];
        [self.right1Btn setTitleColor:HEXColor(@"#666666") forState:UIControlStateNormal];
        [self.right1Btn clipWithCornerRadius:kHeight(5.0) borderColor:HEXColor(@"#999999") borderWidth:kHeight(1.0)];
    }
}

- (void)setViewModel:(HJOrderDetailViewModel *)viewModel {
    _viewModel = viewModel;
}

- (RACSubject *)backSub {
    if (!_backSub) {
        _backSub = [[RACSubject alloc] init];
    }
    return _backSub;
}

@end
