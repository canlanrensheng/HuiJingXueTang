//
//  PayBottonView.m
//  HuiJingSchool
//
//  Created by 陈燕军 on 2018/5/21.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "PayBottonView.h"
#import "OrderInfoViewController.h"
@implementation PayBottonView

-(void)layoutSubviews{
    [super layoutSubviews];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kW, 40*SW)];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    
    UIButton *baybutton = [[UIButton alloc]initWithFrame:CGRectMake(kW - 90*SW, 0, 90*SW, 40*SW)];
    baybutton.backgroundColor = RGB(250, 57, 53);
    [baybutton setTitle:@"立即购买" forState:UIControlStateNormal];
    baybutton.titleLabel.font = FONT(15);
    [baybutton addTarget:self action:@selector(bayAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:baybutton];
    
    UIButton *addbtn = [[UIButton alloc]initWithFrame:CGRectMake(baybutton.minX - 90*SW, 0, 90*SW, 40*SW)];
    addbtn.backgroundColor = RGB(238, 147, 46);
    [addbtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    addbtn.titleLabel.font = FONT(15);
    [addbtn addTarget:self action:@selector(addbtnAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:addbtn];

    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(15*SW, 0, 60*SW, 40*SW)];
    lb.text = @"需支付:";
    lb.font = FONT(15);
    lb.textAlignment = 2;
    [view addSubview:lb];
    
    UILabel *pricelb = [[UILabel alloc]initWithFrame:CGRectMake(lb.maxX + 5*SW, 0, 200*SW, 40*SW)];
    pricelb.font = FONT(15);
    pricelb.textColor = RGB(250, 57, 53);
    pricelb.text = _amont;
    [view addSubview:pricelb];
    
}
-(void)addbtnAction{
    [YJAPPNetwork shoppingCartWithAccesstoken:[APPUserDataIofo AccessToken] courseid:self.Id success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            [SVProgressHUD showSuccessWithStatus:@"已加入购物车"];
        }else{
            UIViewController *vc = [self getCurrentViewController];
            [ConventionJudge NetCode:code vc:vc type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
    }];
}

-(void)bayAction{
    
    [YJAPPNetwork WillPayWithAccesstoken:[APPUserDataIofo AccessToken] cids:self.Id success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            SVDismiss;
            NSString *orderid = [responseObject objectForKey:@"data"];
            OrderInfoViewController *vc  = [[OrderInfoViewController alloc]init];
            vc.orderid = orderid;
            vc.type = @"1";
            UIViewController *vc1 = [self getCurrentViewController];
            [vc1.navigationController pushViewController:vc animated:YES];

        }else{
            UIViewController *vc = [self getCurrentViewController];
            [ConventionJudge NetCode:code vc:vc type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
        
    }];
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
@end
