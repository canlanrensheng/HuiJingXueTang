//
//  HJConfirmOrderViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/24.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJConfirmOrderViewController.h"
#import "HJConfirmOrderViewModel.h"
#import "HJConfirmOrderListCell.h"
#import "HJConfirmOrderTotalMoneyCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import "HJPayTypeAlert.h"
#import <WXApi.h>
#import "HJConfirmOrderModel.h"
@interface HJConfirmOrderViewController ()

@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) HJConfirmOrderViewModel *viewModel;

@property (nonatomic,strong) UILabel *totalMonneyLabel;

//支付类型
@property (nonatomic,copy) NSString *payType;

@property (nonatomic,strong) HJPayTypeAlert *payTypeAlert;

@end

@implementation HJConfirmOrderViewController

- (HJConfirmOrderViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[HJConfirmOrderViewModel alloc] init];
    }
    return  _viewModel;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
    self.fd_interactivePopDisabled = YES;
}

- (void)viewDidLoad {
    self.tableViewStyle = UITableViewStyleGrouped;
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    self.fd_interactivePopDisabled = NO;
    [[HJPayTool shareInstance].payAlertView dismiss];
}

- (void)hj_setNavagation {
    self.title = @"确认订单";
}

- (void)hj_configSubViews{
    [self createTopView];
    //创建底部试图
    [self createBottomView];
    
    self.sectionFooterHeight = 0.001f;
    
    [self.tableView registerClass:[HJConfirmOrderListCell class] forCellReuseIdentifier:NSStringFromClass([HJConfirmOrderListCell class])];
    [self.tableView registerClass:[HJConfirmOrderTotalMoneyCell class] forCellReuseIdentifier:NSStringFromClass([HJConfirmOrderTotalMoneyCell class])];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kHeight(45.0), 0, kHeight(49.0) + KHomeIndicatorHeight, 0));
    }];
}

- (void)createTopView {
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = white_color;
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(kHeight(45.0));
    }];
    
    
    UILabel *countLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor([NSString stringWithFormat:@"购买账户：%@",[APPUserDataIofo nikename].length > 0 ? [APPUserDataIofo nikename] : @"未知"],MediumFont(font(13)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 1.0;
        [label sizeToFit];
    }];
    
    NSString *buyAccountString = [NSString stringWithFormat:@"购买账户：%@",[APPUserDataIofo nikename].length > 0 ? [APPUserDataIofo nikename] : @"未知"];
    countLabel.attributedText = [buyAccountString attributeWithStr:@"购买账户：" color:HEXColor(@"#999999") font:MediumFont(font(13))];
    [self.topView addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView);
        make.left.equalTo(self.topView).offset(kWidth(10.0));
        make.height.mas_equalTo(kHeight(13.0));
    }];
}

- (void)createBottomView {
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = white_color;
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-KHomeIndicatorHeight);
        make.height.mas_equalTo(kHeight(49.0));
    }];
    
    
    UILabel *countLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"实付金额：￥0",MediumFont(font(15)),HEXColor(@"#666666"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 1.0;
        [label sizeToFit];
    }];
    self.totalMonneyLabel = countLabel;
    [self.bottomView addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView);
        make.left.equalTo(self.bottomView).offset(kWidth(10.0));
        make.height.mas_equalTo(kHeight(14.0));
    }];
    
    UIButton *buyButton = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"确认订单",MediumFont(font(15)),white_color,0);
        button.backgroundColor = HEXColor(@"#FF4400");
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self sureOrderOperation];
        }];
    }];
    [self.bottomView addSubview:buyButton];
    [buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.top.equalTo(self.bottomView);
        make.width.mas_equalTo(kWidth(119));
    }];
}

//确认订单的操作
- (void)sureOrderOperation {
    BOOL isLargeMoney = false;
    for(CourselistModel *model in self.viewModel.model.courselist) {
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
    NSString *orderId = self.params[@"orderId"];
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
        NSString *orderId = self.params[@"orderId"];
        NSString *couponid = self.viewModel.model.cashcouponid.length > 0 ? self.viewModel.model.cashcouponid : @"";
        [[HJPayTool shareInstance] payWithOrderId:orderId couponid:couponid];
    }
}

- (void)hj_loadData {
    NSString *orderId = self.params[@"orderId"];
    [self.viewModel getConfirmOrderListDataWithOrderId:orderId Success:^{
        NSString *price = [NSString stringWithFormat:@"实付金额：￥%.2f",self.viewModel.model.money - self.viewModel.model.price.floatValue];
        self.totalMonneyLabel.attributedText = [price attributeWithStr:[NSString stringWithFormat:@"￥%.2f",self.viewModel.model.money - self.viewModel.model.price.floatValue] color:HEXColor(@"#FF4400") font:MediumFont(font(15))];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0) {
        return  kHeight(120.0);
    }
    return  kHeight(40.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return self.viewModel.model.courselist.count;
    }
    return 2;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0) {
        HJConfirmOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJConfirmOrderListCell class]) forIndexPath:indexPath];
        self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
        [cell setViewModel:self.viewModel indexPath:indexPath];
        return cell;
    }
    HJConfirmOrderTotalMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJConfirmOrderTotalMoneyCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = clear_color;
    [cell setViewModel:self.viewModel indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kHeight(10.0);
}


//- (void)paybtnAction {
//    NSString *orderId = self.params[@"orderId"];
//    NSString *couponid = self.viewModel.model.cashcouponid.length > 0 ? self.viewModel.model.cashcouponid : @"";
//    [YJAPPNetwork OrderPayAccesstoken:[APPUserDataIofo AccessToken] orderid:orderId couponid:couponid paytype:self.payType mch:@"app" success:^(NSDictionary *responseObject) {
//        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
//        if (code == 200) {
//            if ([self.payType isEqualToString:@"alipay"]) {
//                //支付宝支付
//                [UserInfoSingleObject shareInstance].payType = WxOrAlipayTypeBuy;
//                NSString *orderdata = [responseObject objectForKey:@"data"];
//                [self alipay:orderdata];
//            }else{
//                //微信支付
//                [UserInfoSingleObject shareInstance].payType = WxOrAlipayTypeBuy;
//                NSDictionary *dic = [responseObject objectForKey:@"data"];
//                //                //调起微信支付
//                //                //需要创建这个支付对象
//                PayReq *req   = [[PayReq alloc] init];
//                //                //由用户微信号和AppID组成的唯一标识，用于校验微信用户
//                req.openID =  [dic objectForKey:@"appid"];
//                //                // 商家id，在注册的时候给的
//                req.partnerId = [dic objectForKey:@"partnerid"];
//                //                // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
//                req.prepayId  = [dic objectForKey:@"prepayid"];
//                //                // 根据财付通文档填写的数据和签名
//                req.package  = [dic objectForKey:@"package"];
//                //                // 随机编码，为了防止重复的，在后台生成
//                req.nonceStr  = [dic objectForKey:@"noncestr"];
//                //                // 这个是时间戳，也是在后台生成的，为了验证支付的
//                NSString * stamp = [dic objectForKey:@"timestamp"];
//                req.timeStamp = stamp.intValue;
//                //                // 这个签名也是后台做的
//                req.sign = [dic objectForKey:@"sign"];
//                //发送请求到微信，等待微信返回onResp
//                [WXApi sendReq:req];
//            }
//        }else{
//            [ConventionJudge NetCode:code vc:self type:@"1"];
//        }
//    } failure:^(NSString *error) {
//        ShowMessage(netError);
//    }];
//}
//
//- (void)alipay:(NSString *)orderstr{
//    //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
//    NSString *appScheme = @"alipay9815485a129";
//    NSString * orderString = orderstr;
//    // NOTE: 调用支付结果开始支付
//    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//        DLog(@"获取到的支付的结果是：reslut = %@",resultDic);
//        NSString * memo = resultDic[@"memo"];
//        NSLog(@"===memo:%@", memo);
//        if ([resultDic[@"ResultStatus"] isEqualToString:@"9000"]) {
//            ShowMessage(@"支付成功");
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [DCURLRouter pushURLString:@"route://myCourceVC" animated:YES];
//            });
//        }else{
//            ShowMessage(memo);
//        }
//    }];
//
//}


@end
