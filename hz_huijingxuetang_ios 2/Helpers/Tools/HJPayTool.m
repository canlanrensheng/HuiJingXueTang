//
//  HJPayTool.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/10.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJPayTool.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>
#import <ShareSDK/ShareSDK.h>

@implementation HJPayTool

+ (instancetype)shareInstance {
    static HJPayTool *object = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object = [[HJPayTool alloc]init];
    });
    return object;
}

//去支付的操作
- (void)payWithOrderId:(NSString *)orderId couponid:(NSString *)couponid   {
    HJPayTypeAlert *alert = [[HJPayTypeAlert alloc] initWithBlock:^(PayType payType) {
        NSString * payTypeString = nil;
        if(payType == PayTypeAliPay) {
            payTypeString = @"alipay";
        } else if(payType == PayTypeWX){
            payTypeString = @"wxpay";
        }
        [YJAPPNetwork OrderPayAccesstoken:[APPUserDataIofo AccessToken] orderid:orderId couponid:couponid paytype:payTypeString mch:@"app" success:^(NSDictionary *responseObject) {
            NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
            if (code == 200) {
                if ([payTypeString isEqualToString:@"alipay"]) {
                    //支付宝支付
                    [UserInfoSingleObject shareInstance].payType = WxOrAlipayTypeBuy;
                    NSString *orderdata = [responseObject objectForKey:@"data"];
                    [self alipay:orderdata];
                }else{
                    //微信支付
                    [UserInfoSingleObject shareInstance].payType = WxOrAlipayTypeBuy;
                    NSDictionary *dic = [responseObject objectForKey:@"data"];
                    //                //调起微信支付
                    //                //需要创建这个支付对象
                    PayReq *req   = [[PayReq alloc] init];
                    //                //由用户微信号和AppID组成的唯一标识，用于校验微信用户
                    req.openID =  [dic objectForKey:@"appid"];
                    //                // 商家id，在注册的时候给的
                    req.partnerId = [dic objectForKey:@"partnerid"];
                    //                // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
                    req.prepayId  = [dic objectForKey:@"prepayid"];
                    //                // 根据财付通文档填写的数据和签名
                    req.package  = [dic objectForKey:@"package"];
                    //                // 随机编码，为了防止重复的，在后台生成
                    req.nonceStr  = [dic objectForKey:@"noncestr"];
                    //                // 这个是时间戳，也是在后台生成的，为了验证支付的
                    NSString * stamp = [dic objectForKey:@"timestamp"];
                    req.timeStamp = stamp.intValue;
                    //                // 这个签名也是后台做的
                    req.sign = [dic objectForKey:@"sign"];
                    //发送请求到微信，等待微信返回onResp
                    [WXApi sendReq:req];
                }
            }else{
                [ConventionJudge NetCode:code vc:VisibleViewController() type:@"1"];
            }
        } failure:^(NSString *error) {
            ShowMessage(netError);
        }];
    }];
    [alert show];
    
    self.payAlertView = alert;
    
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"OrderPaySuccessNoty" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [alert dismiss];
    }];
}

//支付宝支付
- (void)alipay:(NSString *)orderstr{
    //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
    NSString *appScheme = @"alipay9815485a129";
    NSString * orderString = orderstr;
    // NOTE: 调用支付结果开始支付
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        DLog(@"获取到的支付的结果是：reslut = %@",resultDic);
        NSString * memo = resultDic[@"memo"];
        NSLog(@"===memo:%@", memo);
        if ([resultDic[@"ResultStatus"] isEqualToString:@"9000"]) {
            ShowMessage(@"支付成功");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [DCURLRouter pushURLString:@"route://myCourceVC" animated:YES];
            });
        }else{
            ShowMessage(memo);
        }
    }];
    
}

@end
