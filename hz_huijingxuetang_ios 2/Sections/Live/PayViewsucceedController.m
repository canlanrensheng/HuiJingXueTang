//
//  PayViewsucceedController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/1/24.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "PayViewsucceedController.h"
#import "LivePageViewController.h"
@interface PayViewsucceedController ()

@end

@implementation PayViewsucceedController
{
    NSString *stuats;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"代金券";
    self.view.backgroundColor = ALLViewBgColor;
    
    
    
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(kW/2 -35*SW , 56*SW, 70*SW, 70*SW)];
    [self.view addSubview:imgview];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, imgview.maxY+35*SW, kW, 30)];
    label.textAlignment = 1;
    label.textColor = TextNoColor;
    [self.view addSubview:label];
    
    UIButton *btn5 = [[UIButton alloc]init];
    btn5.frame = CGRectMake( 40*SW, label.maxY+92.5*SW, kW-80*SW, 50*SW);
    btn5.backgroundColor = NavAndBtnColor;
    btn5.layer.cornerRadius = 5*SW;
    btn5.layer.masksToBounds = YES;
    [btn5 addTarget:self action:@selector(gobackaction:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([stuats isEqualToString:@"成功"]) {
        label.text = @"您的订单已支付失败";
        imgview.image = [UIImage imageNamed:@"未-1_03"];
        btn5.tag = 101+1;
        [btn5 setTitle:@"返回订单" forState:UIControlStateNormal];

    }else{
        label.text = @"您的订单已支付成功";
        imgview.image = [UIImage imageNamed:@"未标题-1_03"];
        btn5.tag = 101+2;

        [btn5 setTitle:@"返回首页" forState:UIControlStateNormal];

    }
    [self.view addSubview:btn5];
    // Do any additional setup after loading the view.
}



-(void)gobackaction:(UIButton *)sender{
    if (sender.tag - 101 ==1) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[LivePageViewController class]]) {
                LivePageViewController *home =(LivePageViewController *)controller;
                [self.navigationController popToViewController:home animated:YES];
            }
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }

}


@end
