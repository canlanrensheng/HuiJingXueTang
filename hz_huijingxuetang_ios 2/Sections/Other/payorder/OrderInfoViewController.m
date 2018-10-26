
//
//  OrderInfoViewController.m
//  HuiJingSchool
//
//  Created by 陈燕军 on 2018/5/24.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "OrderInfoViewController.h"
#import "OrderViewCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import "YJAlertview.h"
#import "AllOrderListViewController.h"
@interface OrderInfoViewController ()<UITableViewDelegate,UITableViewDataSource,YJAlertviewDelegate>

@end

@implementation OrderInfoViewController
{
    NSDictionary *datadic;
    UIScrollView *scrollview;
    
    UILabel *allpricelb;
    UILabel *Discountcardlb;
    UILabel *Discountlb;
    
    NSArray *dataarr;
    NSString *couponid;
    NSString *paytype;
    
    UIImageView *userimg1;
    UIImageView *userimg2;
    
    UILabel *usercard;
    NSArray *cardArr;
    NSMutableArray *cardtaskarr;
    UIImageView *wximg;
    UIImageView *aliimg;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    self.view.backgroundColor = ALLViewBgColor;
    [self loaddata];
    couponid = @"";
    paytype = @"alipay";


    // Do any additional setup after loading the view.
}

-(void)loaddata{
    [YJAPPNetwork OrderInfoWithAccesstoken:[APPUserDataIofo AccessToken] Id:_orderid success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            SVDismiss;
            datadic = [responseObject objectForKey:@"data"];
            dataarr = [NSArray array];
            dataarr = [datadic objectForKey:@"courselist"];
            [self getmainview];
            
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
    }];
}

-(void)getmainview{
    [self getTopview];
    [self getTowview];
    [self getorderview];
}

-(void)getTopview{
    scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kW, kH - SafeAreaTopHeight - SafeAreaBottomHeight - 60*SW)];
    [self.view addSubview:scrollview];
    
    UIView *topview = [[UIView alloc]initWithFrame:CGRectMake(10*SW, 10*SW, kW - 20*SW, 120*SW)];
    topview.backgroundColor = [UIColor whiteColor];
    [scrollview addSubview:topview];
    
    UILabel *cardname = [[UILabel alloc]initWithFrame:CGRectMake(15*SW, 0, kW, 40*SW)];
    cardname.text = @"使用代金券";
    cardname.font = FONT(15);
    [topview addSubview:cardname];
    
    UIView *ln = [[UIView alloc]initWithFrame:CGRectMake(15*SW, 39.5*SW, kW-35*SW, 0.5)];
    ln.backgroundColor = LnColor;
    [topview addSubview:ln];
    
    UIButton *nouse = [[UIButton alloc]initWithFrame:CGRectMake(0, cardname.maxY, topview.width, 40*SW)];
    [nouse addTarget:self action:@selector(nouseAction) forControlEvents:UIControlEventTouchUpInside];
    [topview addSubview:nouse];
    
    userimg1 = [[UIImageView alloc]initWithFrame:CGRectMake(20*SW, 10*SW, 20*SW, 20*SW)];
    userimg1.image = [UIImage imageNamed:@"uncheck"];
    userimg1.highlightedImage = [UIImage imageNamed:@"check"];
    userimg1.highlighted = YES;
    [nouse addSubview:userimg1];
    
    UILabel *nousercard = [[UILabel alloc]initWithFrame:CGRectMake(userimg1.maxX+10*SW, 0, topview.width - 50*SW, 40*SW)];
    nousercard.text = @"不使用代金券";
    nousercard.font = FONT(15);
    [nouse addSubview:nousercard];
    
    UIView *ln1 = [[UIView alloc]initWithFrame:CGRectMake(30*SW, 79.5*SW, kW-50*SW, 0.5)];
    ln1.backgroundColor = LnColor;
    [topview addSubview:ln1];
    
    UIButton *use = [[UIButton alloc]initWithFrame:CGRectMake(0, nouse.maxY, topview.width, 40*SW)];
    [use addTarget:self action:@selector(userAction) forControlEvents:UIControlEventTouchUpInside];
    [topview addSubview:use];
    
    userimg2 = [[UIImageView alloc]initWithFrame:CGRectMake(20*SW, 10*SW, 20*SW, 20*SW)];
    userimg2.image = [UIImage imageNamed:@"uncheck"];
    userimg2.highlightedImage = [UIImage imageNamed:@"check"];
    [use addSubview:userimg2];
    
    usercard = [[UILabel alloc]initWithFrame:CGRectMake(userimg2.maxX+10*SW, 0, topview.width - 50*SW, 40*SW)];
    usercard.text = @"选择代金券";
    usercard.font = FONT(15);
    [use addSubview:usercard];
}

-(void)nouseAction{
    userimg1.highlighted = YES;
    userimg2.highlighted = NO;
    couponid = @"";
    usercard.text = @"选择代金券";
}

-(void)userAction{
    [YJAPPNetwork MycardWithAccessToken:[APPUserDataIofo AccessToken] type:@"2" success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            SVDismiss;
            cardArr = [NSArray array];
            cardArr = [responseObject objectForKey:@"data"];
            cardtaskarr = [NSMutableArray array];
            for (NSDictionary *dic in cardArr) {
                NSString *str = [dic objectForKey:@"cpname"];
                [cardtaskarr addObject:str];
            }
            if (cardtaskarr.count) {
                YJAlertview *alertview = [[YJAlertview alloc]initWithFrame:[UIScreen mainScreen].bounds];
                alertview.delegate = self;
                alertview.type = @"1";
                alertview.typeName = @"选择代金券";
                alertview.count =cardtaskarr.count;
                alertview.dataarr = cardtaskarr;
                [self.navigationController.view addSubview:alertview];
            }else{
                SVshowInfo(@"没有可使用的代金券");
            }

        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
    }];
    

}


-(void)getTowview{
    UIView *twoview = [[UIView alloc]initWithFrame:CGRectMake(10*SW, 140*SW, kW - 20*SW, 120*SW)];
    twoview.backgroundColor = [UIColor whiteColor];
    [scrollview addSubview:twoview];
    
    UILabel *cardname = [[UILabel alloc]initWithFrame:CGRectMake(15*SW, 0, kW, 40*SW)];
    cardname.text = @"选择支付方式";
    cardname.font = FONT(15);
    [twoview addSubview:cardname];
    
    UIView *ln = [[UIView alloc]initWithFrame:CGRectMake(15*SW, 39.5*SW, kW-35*SW, 0.5)];
    ln.backgroundColor = LnColor;
    [twoview addSubview:ln];
    
    UIButton *nouse = [[UIButton alloc]initWithFrame:CGRectMake(0, cardname.maxY, twoview.width, 40*SW)];
    [nouse addTarget:self action:@selector(alibtn) forControlEvents:UIControlEventTouchUpInside];
    [twoview addSubview:nouse];
    
    aliimg = [[UIImageView alloc]initWithFrame:CGRectMake(20*SW, 10*SW, 20*SW, 20*SW)];
    aliimg.image = [UIImage imageNamed:@"uncheck"];
    aliimg.highlightedImage = [UIImage imageNamed:@"check"];
    aliimg.highlighted = YES;
    [nouse addSubview:aliimg];
    
    UIImageView *weixinimg = [[UIImageView alloc]initWithFrame:CGRectMake(aliimg.maxX+10*SW, 10*SW, 20*SW, 20*SW)];
    weixinimg.image = [UIImage imageNamed:@"alipay"];
    [nouse addSubview:weixinimg];
    
    UILabel *nousercard = [[UILabel alloc]initWithFrame:CGRectMake(weixinimg.maxX+10*SW, 0, twoview.width - weixinimg.maxX, 40*SW)];
    nousercard.text = @"支付宝";
    nousercard.font = FONT(15);
    [nouse addSubview:nousercard];
    
    UIView *ln1 = [[UIView alloc]initWithFrame:CGRectMake(30*SW, 79.5*SW, kW-50*SW, 0.5)];
    ln1.backgroundColor = LnColor;
    [twoview addSubview:ln1];
    
    UIButton *use = [[UIButton alloc]initWithFrame:CGRectMake(0, nouse.maxY, twoview.width, 40*SW)];
    [use addTarget:self action:@selector(wxbtn) forControlEvents:UIControlEventTouchUpInside];
    use.hidden = YES;
    [twoview addSubview:use];
    
    wximg = [[UIImageView alloc]initWithFrame:CGRectMake(20*SW, 10*SW, 20*SW, 20*SW)];
    wximg.image = [UIImage imageNamed:@"uncheck"];
    wximg.highlightedImage = [UIImage imageNamed:@"check"];
    [use addSubview:wximg];
    
    UIImageView *aliiconimg = [[UIImageView alloc]initWithFrame:CGRectMake(wximg.maxX+10*SW, 10*SW, 20*SW, 20*SW)];
    aliiconimg.image = [UIImage imageNamed:@"wechatpay"];
    [use addSubview:aliiconimg];
    
    UILabel *usercard1 = [[UILabel alloc]initWithFrame:CGRectMake(aliiconimg.maxX+10*SW, 0, twoview.width - aliiconimg.maxX, 40*SW)];
    usercard1.text = @"微信";
    usercard1.font = FONT(15);
    [use addSubview:usercard1];
}
-(void)wxbtn{
    wximg.highlighted = YES;
    aliimg.highlighted = NO;
    paytype = @"wxpay";
}
-(void)alibtn{
    wximg.highlighted = NO;
    aliimg.highlighted = YES;
    paytype = @"alipay";

}

-(void)getorderview{
    UIView *orderview = [[UIView alloc]initWithFrame:CGRectMake(10*SW, 270*SW, kW - 20*SW, 170*SW)];
    orderview.backgroundColor = [UIColor whiteColor];
    [scrollview addSubview:orderview];
    
    UILabel *Ordername = [[UILabel alloc]initWithFrame:CGRectMake(15*SW, 0, 100*SW, 40*SW)];
    Ordername.text = @"订单号";
    Ordername.font = FONT(15);
    [orderview addSubview:Ordername];
    
    UILabel *sn = [[UILabel alloc]initWithFrame:CGRectMake(orderview.width - 250*SW, 0, 240*SW, 40*SW)];
    sn.text = [datadic objectForKey:@"orderno"];
    sn.font = FONT(15);
    sn.textAlignment = 2;
    [orderview addSubview:sn];
    
    UIView *ln = [[UIView alloc]initWithFrame:CGRectMake(15*SW, 39.5*SW, kW-35*SW, 0.5)];
    ln.backgroundColor = LnColor;
    [orderview addSubview:ln];
    
    UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(15*SW, Ordername.maxY, 100*SW, 40*SW)];
    time.text = @"下单时间";
    time.font = FONT(15);
    [orderview addSubview:time];
    
    UILabel *timeV = [[UILabel alloc]initWithFrame:CGRectMake(orderview.width - 200*SW,Ordername.maxY, 190*SW, 40*SW)];
    timeV.text = [datadic objectForKey:@"createtime"];
    timeV.font = FONT(15);
    timeV.textAlignment = 2;
    [orderview addSubview:timeV];
    
    UIView *ln1 = [[UIView alloc]initWithFrame:CGRectMake(15*SW, 79.5*SW, kW-35*SW, 0.5)];
    ln1.backgroundColor = LnColor;
    [orderview addSubview:ln1];
    
    UILabel *allname = [[UILabel alloc]initWithFrame:CGRectMake(15*SW, 80*SW, 50*SW, 90*SW)];
    allname.text = @"总计";
    allname.font = FONT(15);
    [orderview addSubview:allname];
    
    NSArray *arr = @[@"原价",@"优惠券抵用",@"优惠价"];
    for (int i = 0; i < 3; i++) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(orderview.width - 180*SW, 80*SW+7.5*SW+ 25*SW*i, 100*SW, 25*SW)];
        lab.text = arr[i];
        lab.textAlignment = 2;
        lab.font = FONT(12);
        [orderview addSubview:lab];
    }
    
    allpricelb = [[UILabel alloc]initWithFrame:CGRectMake(orderview.width - 80*SW, 87.5*SW, 70*SW, 25*SW)];
    allpricelb.text = [NSString stringWithFormat:@"%.2f",[[datadic objectForKey:@"money"]doubleValue]];
    allpricelb.textAlignment = 2;
    allpricelb.font = FONT(12);
    [orderview addSubview:allpricelb];
    
    Discountcardlb = [[UILabel alloc]initWithFrame:CGRectMake(orderview.width - 80*SW, 87.5*SW+25*SW, 70*SW, 25*SW)];
    Discountcardlb.text = @"-￥0";
    Discountcardlb.textAlignment = 2;
    Discountcardlb.font = FONT(11);
    Discountcardlb.textColor = [UIColor redColor];
    [orderview addSubview:Discountcardlb];
    
    Discountlb = [[UILabel alloc]initWithFrame:CGRectMake(orderview.width - 80*SW, 87.5*SW+25*SW*2, 70*SW, 25*SW)];
    Discountlb.text = [NSString stringWithFormat:@"%.2f",[[datadic objectForKey:@"money"]doubleValue] - 0];
    Discountlb.textAlignment = 2;
    Discountlb.font = FONT(12);
    [orderview addSubview:Discountlb];
    
    [self getClassListView];
}

-(void)getClassListView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 455*SW, kW, 40*SW +90*SW * dataarr.count)];
    view.backgroundColor = [UIColor whiteColor];
    [scrollview addSubview:view];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15*SW, 0, 100*SW, 40*SW)];
    label.text = @"课程列表";
    label.font = FONT(15);
    [view addSubview:label];
    
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 40*SW, kW, 90*SW *dataarr.count)];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.scrollEnabled = NO;
    [view addSubview:tableview];
    
    scrollview.contentSize = CGSizeMake(0, view.maxY);
    
    UIButton *paybtn = [[UIButton alloc]initWithFrame:CGRectMake(0, kH - SafeAreaTopHeight - SafeAreaBottomHeight - 60*SW, kW, 60*SW)];
    paybtn.backgroundColor = NavAndBtnColor;
    [paybtn setTitle:@"立即付款" forState:UIControlStateNormal];
    [paybtn addTarget:self action:@selector(paybtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:paybtn];
}

-(void)paybtnAction{
    [YJAPPNetwork OrderPayAccesstoken:[APPUserDataIofo AccessToken] orderid:self.orderid couponid:couponid paytype:paytype mch:@"app" success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            if ([paytype isEqualToString:@"alipay"]) {
                //支付宝支付
                NSString *orderdata = [responseObject objectForKey:@"data"];
                [self alipay:orderdata];
            }else{
                //微信支付
                NSDictionary *dic = [responseObject objectForKey:@"data"];
            }
            SVDismiss;
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
    }];
}

-(void)alipay:(NSString *)orderstr{
    //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
    NSString *appScheme = @"alipay9815485a129";
    NSString * orderString = orderstr;
    // NOTE: 调用支付结果开始支付
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
        NSString * memo = resultDic[@"memo"];
        NSLog(@"===memo:%@", memo);
        if ([resultDic[@"ResultStatus"] isEqualToString:@"9000"]) {
            //支付成功回调
            
            [SVProgressHUD showSuccessWithStatus:@"支付成功"];
            if ([_type isEqualToString:@"1"]) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"loaddata" object:self];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"reloaddata" object:self];
                [self.navigationController popViewControllerAnimated:YES];

            }
        }else{
            [SVProgressHUD showErrorWithStatus:memo];
        }
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataarr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"ordercell";
    OrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[OrderViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSDictionary *dic = dataarr [indexPath.row];
    NSURL *url = [NSURL URLWithString:[dic objectForKey:@"coursepic"]];
    [cell.imgview sd_setImageWithURL:url];
    
    cell.textview.text = [dic objectForKey:@"coursename"];
    cell.textview.userInteractionEnabled = NO;
    cell.pricelabel.text = [NSString stringWithFormat:@"￥%@",[dic objectForKey:@"coursemoney"]];
    cell.selectionStyle = 0;

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90*SW;
}


-(void)changevalue:(NSString *)value type:(NSString *)type seltype:(NSInteger)sel{
    NSLog(@"type%@,value%@,sel%ld",type,value,sel);
    userimg1.highlighted = NO;
    userimg2.highlighted = YES;
    usercard.text = value;
    NSDictionary *dic = cardArr[sel];
    couponid = [dic objectForKey:@"id"];
    Discountcardlb.text = [NSString stringWithFormat:@"-￥%.2f",[[dic objectForKey:@"price"]doubleValue]];

    Discountlb.text = [NSString stringWithFormat:@"%.2f",[[datadic objectForKey:@"money"]doubleValue] -[[dic objectForKey:@"price"]doubleValue]];

}

@end
