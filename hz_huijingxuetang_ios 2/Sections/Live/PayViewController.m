//
//  PayViewController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/1/23.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "PayViewController.h"
#import "PayViewsucceedController.h"
@interface PayViewController ()

@end

@implementation PayViewController
{
    UIButton *btn1;
    UIButton *btn2;

    UIImageView *img1;
    UIImageView *img2;
    
    UILabel *paylabel1;
    UILabel *paylabel2;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"支付订单";
    self.view.backgroundColor = ALLViewBgColor;
    [self getmainview];
    
    // Do any additional setup after loading the view.
}

-(void)getmainview{
    UIView *topview = [[UIView alloc]initWithFrame:CGRectMake(0, 10*SW, kW, 60*SW)];
    topview.backgroundColor = WColor;
    [self.view addSubview:topview];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15*SW, 10*SW, kW, 20*SW)];
    label.text = @"23213992138874";
    label.font = TextFont;
    [topview addSubview:label];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(15*SW, 30*SW, kW, 20*SW)];
    label1.text = @"已提交，请务必在24小时内完成支付，否则订单将自动取消";
    label1.font = TextsmlFont;
    label1.textColor = TextColor;
    [topview addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(15*SW, topview.maxY, kW, 40*SW)];
    label2.text = @"订单详情";
    label2.font = TextFont;
    label2.textColor = TextColor;
    [self.view addSubview:label2];
    
    UIView *ifview = [[UIView alloc]initWithFrame:CGRectMake(0, label2.maxY, kW, 150*SW)];
    ifview.backgroundColor = WColor;
    [self.view addSubview:ifview];
    
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(15*SW, 15*SW, 220*SW, 120*SW)];
    imgview.image = [UIImage imageNamed:@"支付订单_06"];
    [ifview addSubview:imgview];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(imgview.maxX+14*SW, ifview.height/2-50*SW, kW, 50*SW)];
    label3.text = @"VIP服务（时间）";
    label3.font = TextFont;
    label3.textColor = TextNoColor;
    [ifview addSubview:label3];
    
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(imgview.maxX+14*SW, ifview.height/2+10*SW, kW, 50*SW)];
    label4.text = @"￥90000.0";
    label4.font = TextFont;
    label4.textColor = [UIColor redColor];
    [ifview addSubview:label4];
    
    UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(15*SW, ifview.maxY, kW, 40*SW)];
    label5.text = @"购买方式";
    label5.font = TextFont;
    label5.textColor = TextColor;
    [self.view addSubview:label5];
    
    UIView *buttonview = [[UIView alloc]initWithFrame:CGRectMake(0, label5.maxY, kW, self.view.height-label5.maxY)];
    buttonview.backgroundColor = WColor;
    [self.view addSubview:buttonview];
    
    NSArray *imgarr = @[@"支付订单_03",@"支付订单_05"];
    NSArray *titarr = @[@"微信支付",@"支付宝支付"];
    for (int i = 0; i < 2; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15*SW+ (kW/2 - 27.5*SW + 25*SW)*i, 15*SW, kW/2 - 27.5*SW, 120*SW)];
        [buttonview addSubview:view];
        
        UIImageView *payimg = [[UIImageView alloc]initWithFrame:CGRectMake(27.5*SW, view.height/2-15*SW, 30*SW, 30*SW)];
        payimg.image = [UIImage imageNamed:imgarr[i]];
        [view addSubview:payimg];
        

        
        if (i == 0) {
            
            paylabel1 = [[UILabel alloc]initWithFrame:CGRectMake(15*SW, view.height/2-15*SW, view.width-15*SW, 30*SW)];
            paylabel1.text = titarr[i];
            paylabel1.textAlignment = 1;
            paylabel1.font = FONT(17);
            paylabel1.textColor = NavAndBtnColor;
            [view addSubview:paylabel1];
            
            img1 = [[UIImageView alloc]initWithFrame:CGRectMake(view.width- 25*SW, view.height-25*SW, 20*SW, 20*SW)];
            img1.image  = [UIImage imageNamed:@"VIP购买计划_07"];
            img1.hidden = NO;
            [view addSubview:img1];
            
            btn1 = [[UIButton alloc]initWithFrame:view.bounds];
            btn1.layer.cornerRadius = 5;
            btn1.layer.masksToBounds = YES;
            btn1.layer.borderWidth = 1;
            btn1.layer.borderColor = [NavAndBtnColor CGColor];
            btn1.selected = YES;
            [btn1 addTarget:self action:@selector(btn1:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn1];
            
        }else if(i == 1){
            
            paylabel2 = [[UILabel alloc]initWithFrame:CGRectMake(30*SW, view.height/2-15*SW, view.width-30*SW, 30*SW)];
            paylabel2.text = titarr[i];
            paylabel2.font = FONT(17);
            paylabel2.textAlignment = 1;

            paylabel2.textColor =TextNoColor;
            [view addSubview:paylabel2];
            
            img2 = [[UIImageView alloc]initWithFrame:CGRectMake(view.width- 25*SW, view.height-25*SW, 20*SW, 20*SW)];
            img2.image  = [UIImage imageNamed:@"VIP购买计划_07"];
            img2.hidden = YES;
            [view addSubview:img2];
            
            btn2 = [[UIButton alloc]initWithFrame:view.bounds];
            btn2.layer.cornerRadius = 5;
            btn2.layer.masksToBounds = YES;
            btn2.layer.borderWidth = 1;
            btn2.layer.borderColor = [[UIColor grayColor]CGColor];
            [btn2 addTarget:self action:@selector(btn2:) forControlEvents:UIControlEventTouchUpInside];
            
            [view addSubview:btn2];
        }
        
        
    }

    
    UILabel *label6 = [[UILabel alloc]initWithFrame:CGRectMake(kW - 230*SW, self.view.maxY - 200*SW-64, 200*SW, 30*SW)];
    label6.text = @"共优惠：900元";
    label6.font = FONT(14);

    label6.textAlignment = 2;
    [self.view addSubview:label6];
    
    UILabel *label7 = [[UILabel alloc]initWithFrame:CGRectMake(kW - 90*SW, label6.maxY+5*SW, 60*SW, 20*SW)];
    label7.text = @"90000元";
    label7.textColor = [UIColor redColor];
    label7.textAlignment = 2;
    label7.font = FONT(14);
    [self.view addSubview:label7];
    
    UILabel *label8 = [[UILabel alloc]initWithFrame:CGRectMake(kW - 90*SW-90*SW, label6.maxY+5*SW, 90*SW, 20*SW)];
    label8.text = @"共需支付：";
    label8.textAlignment = 2;
    label8.font = FONT(14);
    [self.view addSubview:label8];
    
    UIButton *btn5 = [[UIButton alloc]init];
    btn5.frame = CGRectMake( 20*SW, label8.maxY+39*SW, kW-40*SW, 50*SW);
    btn5.backgroundColor = NavAndBtnColor;
    btn5.layer.cornerRadius = 5*SW;
    btn5.layer.masksToBounds = YES;
    [btn5 addTarget:self action:@selector(botonaction) forControlEvents:UIControlEventTouchUpInside];
    [btn5 setTitle:@"确认支付" forState:UIControlStateNormal];
    [self.view addSubview:btn5];
    
}

-(void)botonaction{
    PayViewsucceedController*paysvc = [[PayViewsucceedController alloc]init];
    [self.navigationController pushViewController:paysvc animated:YES];
}
-(void)btn1:(UIButton *)sender{
    btn1.selected = YES;
    btn1.layer.borderColor = [NavAndBtnColor CGColor];
    paylabel1.textColor =NavAndBtnColor;

    img1.hidden = NO;
    img2.hidden = YES;
    paylabel2.textColor =TextNoColor;

    
    btn2.layer.borderColor = [[UIColor grayColor]CGColor];
    btn2.selected = NO;
}
-(void)btn2:(UIButton *)sender{
    btn2.selected = YES;
    btn2.layer.borderColor = [NavAndBtnColor CGColor];
    paylabel2.textColor =NavAndBtnColor;

    img1.hidden = YES;
    img2.hidden = NO;
    btn1.layer.borderColor = [[UIColor grayColor]CGColor];
    btn1.selected = NO;
    paylabel1.textColor =TextNoColor;

}
@end
