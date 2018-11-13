//
//  GiftView.m
//  HuiJingSchool
//
//  Created by 陈燕军 on 2018/5/21.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "GiftView.h"
//#import "FSTextView.h"

@interface GiftView ()<UITextFieldDelegate>

@end

@implementation GiftView
{
    UIButton *menbanview;
    UIView *giftview;
    NSMutableArray *btnarr;
    NSInteger selindex;
    UILabel *label4;
    NSInteger paytype;
    NSMutableArray *imgarr;
    UIView *cardview;
    UITextField *remaktext1;
    NSString *remark;
    NSDictionary *dic;
    NSInteger count;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    menbanview = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kW,self.height)];
    menbanview.backgroundColor = RGBA(0, 0, 0, 0.5);
    [menbanview addTarget:self action:@selector(menbanHide) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:menbanview];
    
    giftview = [[UIView alloc]initWithFrame:CGRectMake(15*SW, self.height/2 - 155*SW-32, kW-30*SW, 310*SW)];
    giftview.backgroundColor = CWHITE;
    giftview.layer.cornerRadius = 10*SW;
    giftview.layer.masksToBounds = YES;
    [menbanview addSubview:giftview];
    
    UIImageView *liwuview = [[UIImageView alloc]initWithFrame:CGRectMake(80*SW, 17.5*SW, 50*SW, 60*SW)];
    liwuview.image = [UIImage imageNamed:@"礼物-1_03"];
    [giftview addSubview:liwuview];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(liwuview.maxX +20*SW, liwuview.minY, giftview.width - liwuview.maxX, 30*SW)];
    label.font = FONT(24);
    label.text = @"您的支持将鼓";
    label.textColor = [UIColor orangeColor];
    [giftview addSubview:label];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(liwuview.maxX +20*SW, liwuview.minY+30*SW, giftview.width - liwuview.maxX, 30*SW)];
    label1.font = FONT(24);
    label1.text = @"励我继续创新";
    label1.textColor = [UIColor orangeColor];
    [giftview addSubview:label1];
    
    btnarr = [NSMutableArray array];
    
    UIScrollView *scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, label1.maxY+18*SW , kW, 125*SW)];
    scrollview.showsVerticalScrollIndicator = FALSE;
    scrollview.showsHorizontalScrollIndicator = FALSE;
    [giftview addSubview:scrollview];
    scrollview.contentSize = CGSizeMake((kW-20*SW)/3*_GiftArr.count, 0);
    
    for (int i = 0 ; i<_GiftArr.count; i++) {
        NSDictionary *dic = _GiftArr[i];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(13*SW+((giftview.width-46*SW)/3+10)*i,0 , (giftview.width-46*SW)/3, 125*SW)];
        btn.layer.cornerRadius = 5*SW;
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 1;
        btn.tag = 1723+i;
        [btn addTarget:self action:@selector(btnSEL:) forControlEvents:UIControlEventTouchUpInside];
        [scrollview addSubview:btn];
        
        UIImageView *liwuimg = [[UIImageView alloc]initWithFrame:CGRectMake(5*SW, 5*SW, btn.width-10*SW, 90*SW)];
        NSURL *url = [NSURL URLWithString:[dic objectForKey:@"icon"]];
        [liwuimg sd_setImageWithURL:url];
        [btn addSubview:liwuimg];
        
        UILabel *price = [[UILabel alloc]initWithFrame:CGRectMake(0, liwuimg.maxY+5*SW, btn.width, 20)];
        price.text = [NSString stringWithFormat:@"￥%ld",[[dic objectForKey:@"price"]integerValue]];
        price.textColor = Orbtncolor;
        price.textAlignment = 1;
        [btn addSubview:price];
        
        if (i == 0) {
            selindex = 0;
            btn.selected = YES;
            btn.layer.borderColor = [[UIColor blueColor]CGColor];
        }else{
            btn.layer.borderColor = [TextColor CGColor];
        }
        [btnarr addObject:btn];
    }
    
    for (int k = 0; k<_GiftArr.count/3; k++) {
        UIImageView *pointview1 = [[UIImageView alloc]initWithFrame:CGRectMake(giftview.width/2-15*SW/2-10*SW*(_GiftArr.count/3-1),  231.5*SW, 15*SW, 15*SW)];
        pointview1.image = [UIImage imageNamed:@"礼物3_11"];
        pointview1.highlightedImage = [UIImage imageNamed:@"礼物-1_17"];
        pointview1.highlighted = YES;
        [giftview addSubview:pointview1];
    }
    
    
    UIButton *affrimbtn = [[UIButton alloc]initWithFrame:CGRectMake(giftview.width/2-125*SW, 231.5*SW+15*SW+8*SW, 250*SW, 40*SW)];
    affrimbtn.backgroundColor = Orbtncolor;
    affrimbtn.layer.cornerRadius = 5*SW;
    affrimbtn.layer.masksToBounds = YES;
    [affrimbtn setTitle:@"犒劳一下" forState:UIControlStateNormal];
    [affrimbtn addTarget:self action:@selector(affrimAction) forControlEvents:UIControlEventTouchUpInside];
    [giftview addSubview:affrimbtn];

}


-(void)btnSEL:(UIButton *)sender{
    selindex = sender.tag - 1723;
    for (UIButton *btn in btnarr) {
        if (btn == sender) {
            btn.selected = YES;
            btn.layer.borderColor = [[UIColor blueColor]CGColor];
        }else{
            btn.selected = NO;
            btn.layer.borderColor = [TextColor CGColor];
        }
    }
}
-(void)affrimAction{
    [giftview removeFromSuperview];
    
    NSDictionary *dic = _GiftArr [selindex];
    
    giftview = [[UIView alloc]initWithFrame:CGRectMake(15*SW, self.height/2 - 155*SW-32, kW-30*SW, 310*SW)];
    giftview.backgroundColor = CWHITE;
    giftview.layer.cornerRadius = 10*SW;
    giftview.layer.masksToBounds = YES;
    [menbanview addSubview:giftview];
    
    UIImageView *liwuview = [[UIImageView alloc]initWithFrame:CGRectMake(80*SW, 17.5*SW, 50*SW, 60*SW)];
    liwuview.image = [UIImage imageNamed:@"礼物-1_03"];
    [giftview addSubview:liwuview];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(liwuview.maxX +20*SW, liwuview.minY, giftview.width - liwuview.maxX, 30*SW)];
    label.font = FONT(24);
    label.text = @"您的支持将鼓";
    label.textColor = [UIColor orangeColor];
    [giftview addSubview:label];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(liwuview.maxX +20*SW, liwuview.minY+30*SW, giftview.width - liwuview.maxX, 30*SW)];
    label1.font = FONT(24);
    label1.text = @"励我继续创新";
    label1.textColor = [UIColor orangeColor];
    [giftview addSubview:label1];
    
    UIView *textview = [[UIView alloc]initWithFrame:CGRectMake(15*SW, liwuview.maxY +25*SW, giftview.width - 30*SW, 95*SW)];
    textview.layer.borderColor = [LnColor CGColor];
    textview.layer.borderWidth = 1;
    textview.layer.cornerRadius = 5;
    textview.layer.masksToBounds = YES;
    [giftview addSubview:textview];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70*SW, 47.5*SW)];
    label2.text = @"金额：";
    label2.textAlignment = 2;
    [textview addSubview:label2];
    
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(0, label2.maxY, 70*SW, 47.5*SW)];
    label3.text = @"留言：";
    label3.textAlignment = 2;
    [textview addSubview:label3];
    
    UIView *ln = [[UIView alloc]initWithFrame:CGRectMake(0, label2.maxY, textview.width, 0.5)];
    ln.backgroundColor = LnColor;
    [textview addSubview:ln];
    
    UITextField *text = [[UITextField alloc]initWithFrame:CGRectMake(label2.maxX, 0, textview.width - label2.maxX, 47.5*SW)];
    text.text = [NSString stringWithFormat:@"￥%ld",[[dic objectForKey:@"price"]integerValue]];
    text.userInteractionEnabled = NO;
    text.textColor = [UIColor orangeColor];
    [textview addSubview:text];
    
    
    remark = @"";

    remaktext1 = [[UITextField alloc]initWithFrame:CGRectMake(label2.maxX, ln.maxY, textview.width - label2.maxX, 47.5*SW)];
    remaktext1.backgroundColor= [UIColor whiteColor];
    remaktext1.placeholder = @"请留言";
    remaktext1.returnKeyType = UIReturnKeyDone;
    remaktext1.delegate = self;
    [textview addSubview:remaktext1];
    
    label4 = [[UILabel alloc]initWithFrame:CGRectMake(giftview.width/2 - 90*SW, textview.maxY + 25, 120*SW, 20*SW)];
    label4.text = @"使用支付宝付款";
    paytype = 2;
    label4.textColor = TextColor;
    label4.font = TextFont;
    label4.textAlignment = 2;
    [giftview addSubview:label4];
    
    UIButton *changbtn = [[UIButton alloc]initWithFrame:CGRectMake(label4.maxX, label4.minY, 35*SW, 20)];
    [changbtn setTitle:@"更换" forState:UIControlStateNormal];
    [changbtn setTitleColor:NavAndBtnColor forState:UIControlStateNormal];
    changbtn.titleLabel.font = TextFont;
    [changbtn addTarget:self action:@selector(changeAction) forControlEvents:UIControlEventTouchUpInside];
    [giftview addSubview:changbtn];
    
    UIView *ln1 = [[UIView alloc]initWithFrame:CGRectMake(0, giftview.height-45*SW, giftview.width, 0.5)];
    ln1.backgroundColor = LnColor;
    [giftview addSubview:ln1];
    
    UIView *ln2 = [[UIView alloc]initWithFrame:CGRectMake(giftview.width/2, ln1.maxY, 0.5, 45*SW)];
    ln2.backgroundColor = LnColor;
    [giftview addSubview:ln2];
    
    UIButton *canbtn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, ln1.minY, giftview.width/2, 45*SW)];
    [canbtn1 setTitle:@"取消" forState:UIControlStateNormal];
    [canbtn1 setTitleColor:TextColor forState:UIControlStateNormal];
    [canbtn1 addTarget:self action:@selector(menbanHide) forControlEvents:UIControlEventTouchUpInside];
    [giftview addSubview:canbtn1];
    
    UIButton *paybtn1 = [[UIButton alloc]initWithFrame:CGRectMake(giftview.width/2, ln1.minY, giftview.width/2, 45*SW)];
    [paybtn1 setTitle:@"确认支付" forState:UIControlStateNormal];
    [paybtn1 addTarget:self action:@selector(AffrimPayAction) forControlEvents:UIControlEventTouchUpInside];
    
    [paybtn1 setTitleColor:NavAndBtnColor forState:UIControlStateNormal];
    [giftview addSubview:paybtn1];
    
}

-(void)AffrimPayAction{
    NSDictionary *dic = self.GiftArr[selindex];
    count = 1;
    NSString *countstr = [NSString stringWithFormat:@"%ld",count];
    NSString *paytypestr;
    if (paytype == 1) {
        paytypestr = @"wxpay";
    }else{
        paytypestr = @"alipay";
    }
    [YJAPPNetwork GifePayAccesstoken:[APPUserDataIofo AccessToken] Id:[dic objectForKey:@"goodsid"] count:countstr remark:remaktext1.text paytype:paytypestr success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            if (paytype == 2) {
                //支付宝支付
                NSString *orderdata = [responseObject objectForKey:@"data"];
                [self alipay:orderdata];
            }else{
                //微信支付
                NSDictionary *dic = [responseObject objectForKey:@"data"];
//                //调起微信支付
//                //需要创建这个支付对象
//                PayReq *req   = [[PayReq alloc] init];
////                //由用户微信号和AppID组成的唯一标识，用于校验微信用户
//                req.openID =  [dic objectForKey:@"appid"];
////                // 商家id，在注册的时候给的
//                req.partnerId = [dic objectForKey:@"partnerid"];
////                // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
//                req.prepayId  = [dic objectForKey:@"prepayid"];
////                // 根据财付通文档填写的数据和签名
//                req.package  = [dic objectForKey:@"package"];
////                // 随机编码，为了防止重复的，在后台生成
//                req.nonceStr  = [dic objectForKey:@"noncestr"];
////                // 这个是时间戳，也是在后台生成的，为了验证支付的
//                NSString * stamp = [dic objectForKey:@"timestamp"];
//                req.timeStamp = stamp.intValue;
////                // 这个签名也是后台做的
//                req.sign = [dic objectForKey:@"sign"];
//                //发送请求到微信，等待微信返回onResp
//                [WXApi sendReq:req];

            }
            SVDismiss;
        }else{
            UIViewController *vc = [self getCurrentViewController];
            [ConventionJudge NetCode:code vc:vc type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
        
    }];
    
//    [giftview removeFromSuperview];
//    UIView *affrimview = [[UIView alloc]initWithFrame:CGRectMake(15*SW, self.height/2 - 92.5*SW-32, kW-30*SW, 185*SW)];
//    affrimview.layer.cornerRadius = 10*SW;
//    affrimview.layer.masksToBounds = YES;
//    affrimview.backgroundColor = [UIColor whiteColor];
//    [menbanview addSubview:affrimview];
//
//
//    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0*SW, 50*SW, 50*SW)];
//    [button setImage:[UIImage imageNamed:@"43_"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(menbanHide) forControlEvents:UIControlEventTouchUpInside];
//    [affrimview addSubview:button];
//
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 85*SW, affrimview.width/2, 30*SW)];
//    label.font = FONT(17);
//    label.textColor = TextNoColor;
//    label.textAlignment = 2;
//    label.text = @"赞赏：";
//    [affrimview addSubview:label];
//
//    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 45*SW, affrimview.width, 30*SW)];
//    label1.font = FONT(17);
//    label1.textColor = TextColor;
//    label1.textAlignment = 1;
//    label1.text = @"请输入支付密码";
//    [affrimview addSubview:label1];
//
//    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(affrimview.width/2, 85*SW, affrimview.width/2, 30*SW)];
//    label2.font = FONT(17);
//    label2.textColor = TextOrColor;
//    label2.textAlignment = 0;
//    label2.text = @"2.00";
//    [affrimview addSubview:label2];
//
//    UIImageView *keyimg = [[UIImageView alloc]initWithFrame:CGRectMake(70*SW, 45*SW, 30*SW, 30*SW)];
//    keyimg.image = [UIImage imageNamed:@"42_"];
//    [affrimview addSubview:keyimg];
//    imgarr = [NSMutableArray array];
//    for (int i = 0; i < 6; i ++) {
//        UIButton *pwdview  = [[UIButton alloc]initWithFrame:CGRectMake(15*SW+(affrimview.width-30*SW)/6*i,affrimview.height - 52.5*SW, (affrimview.width-30*SW)/6, 27.5*SW)];
//        [pwdview setImage:[UIImage imageNamed:@"41_"] forState:UIControlStateHighlighted];
//        pwdview.layer.borderColor = [TextColor CGColor];
//        pwdview.layer.borderWidth = 0.5;
//        [affrimview addSubview:pwdview];
//        pwdview.tag = 902+i;
//        [imgarr addObject:pwdview];
//
//    }
//
//
//    UITextField *textf = [[UITextField alloc]initWithFrame:CGRectMake(15*SW, affrimview.minY+20, 100, 20)];
//    textf.delegate = self;
//
//    [textf addTarget:self action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
//    textf.keyboardType = UIKeyboardTypeNumberPad;
//    //    [menbanview addSubview:textf];
//    [menbanview insertSubview:textf atIndex:0];
//
//    [textf becomeFirstResponder];
    
}
-(void)menbanHide{
    [self removeFromSuperview];
}

-(void)changeAction{

    
    giftview.hidden = YES;
    cardview = [[UIView alloc]initWithFrame:CGRectMake(15*SW, self.height/2 - 70*SW-32, kW-30*SW, 140*SW)];
    cardview.layer.cornerRadius = 10*SW;
    cardview.layer.masksToBounds = YES;
    cardview.backgroundColor = [UIColor whiteColor];
    [menbanview addSubview:cardview];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cardview.width, 50*SW)];
    label.font = BOLDFONT(17);
    label.textColor = [UIColor colorWithHexString:@"#f4630b"];
    label.textAlignment = 1;
    label.text = @"选择支付方式";
    [cardview addSubview:label];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(5, 0, 50, 50*SW)];
    [button setImage:[UIImage imageNamed:@"40_"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    [cardview addSubview:button];
    
    UIButton *weixinpaybtn = [[UIButton alloc]initWithFrame:CGRectMake(0, label.maxY, cardview.width, 45*SW)];
    [weixinpaybtn addTarget:self action:@selector(weixinAction) forControlEvents:UIControlEventTouchUpInside];
    [cardview addSubview:weixinpaybtn];
    
    UIButton *lalipaybtn = [[UIButton alloc]initWithFrame:CGRectMake(0, weixinpaybtn.maxY, cardview.width, 45*SW)];
    [lalipaybtn addTarget:self action:@selector(alipayAction) forControlEvents:UIControlEventTouchUpInside];
    [cardview addSubview:lalipaybtn];
    
    UIImageView *weixinimg = [[UIImageView alloc]initWithFrame:CGRectMake(15*SW, 10*SW, 25*SW, 25*SW)];
    weixinimg.image = [UIImage imageNamed:@"礼物支付_06"];
    [weixinpaybtn addSubview:weixinimg];
    
    UILabel *weixlb  = [[UILabel alloc]initWithFrame:CGRectMake(weixinimg.maxX +50*SW, 0,100*SW, 45*SW)];
    weixlb.text = @"微信支付";
    [weixinpaybtn addSubview:weixlb];
    
    UIImageView *aliimg = [[UIImageView alloc]initWithFrame:CGRectMake(15*SW, 10*SW, 25*SW, 25*SW)];
    aliimg.image = [UIImage imageNamed:@"礼物支付_09"];
    [lalipaybtn addSubview:aliimg];
    
    UILabel *alilb  = [[UILabel alloc]initWithFrame:CGRectMake(aliimg.maxX +50*SW, 0,100*SW, 45*SW)];
    alilb.text = @"支付宝支付";
    [lalipaybtn addSubview:alilb];
    
    UIView *ln = [[UIView alloc]initWithFrame:CGRectMake(0, 50*SW, cardview.width, 1)];
    ln.backgroundColor = LnColor;
    [cardview addSubview:ln];
    
    
    UIView *ln1 = [[UIView alloc]initWithFrame:CGRectMake(0, 95*SW, cardview.width, 0.5)];
    ln1.backgroundColor = LnColor;
    [cardview addSubview:ln1];
}
-(void)backAction{
    [cardview removeFromSuperview];
    giftview.hidden = NO;
}
-(void)weixinAction{
    [cardview removeFromSuperview];
    giftview.hidden = NO;
    paytype = 1;
    label4.text = @"使用微信付款";
}

-(void)alipayAction{
    [cardview removeFromSuperview];
    giftview.hidden = NO;
    paytype = 2;
    label4.text = @"使用支付宝付款";
}



-(void)valueChanged:(UITextField *)textfield{
    NSLog(@"%ld",textfield.text.length);
    NSInteger num = textfield.text.length;
    
    for (UIButton *imgv in imgarr) {
        if ( imgv.tag - 902 < num&&num != 0) {
            UIButton *btn = imgv;
            btn.highlighted = YES;
        }else{
            UIButton *btn = imgv;
            btn.highlighted = NO;
        }
    }
    if (num == 6) {
        [textfield resignFirstResponder];
    }
}

/** 获取当前View的控制器对象 */
-(UIViewController *)getCurrentViewController{
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}


-(void)alipay:(NSString *)orderstr{
    //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
//    NSString *appScheme = @"alipay9815485a129";
//    NSString * orderString = orderstr;
//    // NOTE: 调用支付结果开始支付
//    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//        NSLog(@"reslut = %@",resultDic);
//        NSString * memo = resultDic[@"memo"];
//        NSLog(@"===memo:%@", memo);
//        if ([resultDic[@"ResultStatus"] isEqualToString:@"9000"]) {
//            //支付成功回调
//            [SVProgressHUD showSuccessWithStatus:@"支付成功"];
//            UIViewController *vc = [self getCurrentViewController];
//            [vc.navigationController popViewControllerAnimated:YES];
//        }else{
//            [SVProgressHUD showErrorWithStatus:memo];
//        }
//        
//    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
