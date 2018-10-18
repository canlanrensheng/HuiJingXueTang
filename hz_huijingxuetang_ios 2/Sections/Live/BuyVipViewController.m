//
//  BuyVipViewController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/1/23.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BuyVipViewController.h"
#import "PayViewController.h"
#import "CardViewController.h"
@interface BuyVipViewController ()

@end

@implementation BuyVipViewController
{
    UIImageView *img1;
    UIImageView *img2;
    UIImageView *img3;
    UIButton *btn1;
    UIButton *btn2;
    UIButton *btn3;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"确认订单";
    self.view.backgroundColor = ALLViewBgColor;
    [self getmainview];
    // Do any additional setup after loading the view.
}

-(void)getmainview{
    for (int i = 0; i < 3; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(52.5*SW+ (75+42.5)*SW*i, 300*SW, 75*SW, 75*SW)];
        [self.view addSubview:view];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 15*SW, view.width, 20*SW)];
        label.text = [NSString stringWithFormat:@"%d年",i+1];
        label.font = FONT(15);
        label.textAlignment = 1;
        [view addSubview:label];
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, view.height-35*SW, view.width, 20*SW)];
        label1.text = @"90000元";
        label1.font = FONT(14);
        label1.textAlignment = 1;
        label1.textColor = [UIColor redColor];
        [view addSubview:label1];
        
        if (i == 0) {
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
        }else{
            img3 = [[UIImageView alloc]initWithFrame:CGRectMake(view.width- 25*SW, view.height-25*SW, 20*SW, 20*SW)];
            img3.image  = [UIImage imageNamed:@"VIP购买计划_07"];
            img3.hidden = YES;
            [view addSubview:img3];
            
            btn3 = [[UIButton alloc]initWithFrame:view.bounds];
            btn3.layer.cornerRadius = 5;
            btn3.layer.masksToBounds = YES;
            btn3.layer.borderWidth = 1;
            btn3.layer.borderColor = [[UIColor grayColor]CGColor];
            [btn3 addTarget:self action:@selector(btn3:) forControlEvents:UIControlEventTouchUpInside];

            [view addSubview:btn3];
        }
        
        
    }
    UIView*cardview = [[UIButton alloc]initWithFrame:CGRectMake(15*SW, 386*SW, kW -30*SW, 40*SW)];
    cardview.layer.cornerRadius = 5;
    cardview.layer.masksToBounds = YES;
    cardview.layer.borderWidth = 1;
    cardview.layer.borderColor = [[UIColor grayColor]CGColor];
    
    [self.view addSubview:cardview];
    
    UILabel *clabel = [[UILabel alloc]initWithFrame:CGRectMake(10*SW, 0, 200, 40*SW)];
    clabel.text = @"代金券";
    [cardview addSubview:clabel];
    
    
    UIImageView *arrowimg = [[UIImageView alloc]initWithFrame:CGRectMake(cardview.width-41*SW, 10*SW, 10*SW, 20*SW)];
    arrowimg.image = [UIImage imageNamed:@"首页_34"];
    [cardview addSubview:arrowimg];
    
    UIButton *btn4 = [[UIButton alloc]initWithFrame:cardview.bounds];
    [btn4 addTarget:self action:@selector(btn4:) forControlEvents:UIControlEventTouchUpInside];
    [cardview addSubview:btn4];
    
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(kW - 230*SW, self.view.maxY - 200*SW-64, 200*SW, 30*SW)];
    label4.text = @"共优惠：900元";
    label4.textAlignment = 2;
    label4.font = FONT(14);
    [self.view addSubview:label4];
    
    UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(kW - 90*SW, label4.maxY+5*SW, 60*SW, 20*SW)];
    label5.text = @"90000元";
    label5.textColor = [UIColor redColor];
    label5.textAlignment = 2;
    label5.font = FONT(14);

    [self.view addSubview:label5];
    
    UILabel *label6 = [[UILabel alloc]initWithFrame:CGRectMake(kW - 90*SW-90*SW, label4.maxY+5*SW, 90*SW, 20*SW)];
    label6.font = FONT(14);
    label6.text = @"共需支付：";
    label6.textAlignment = 2;
    [self.view addSubview:label6];
    
    UIButton *btn5 = [[UIButton alloc]init];
    btn5.frame = CGRectMake( 20*SW, label6.maxY+39*SW, kW-40*SW, 50*SW);
    btn5.backgroundColor = NavAndBtnColor;
    btn5.layer.cornerRadius = 5*SW;
    btn5.layer.masksToBounds = YES;
    [btn5 addTarget:self action:@selector(botonaction) forControlEvents:UIControlEventTouchUpInside];
    [btn5 setTitle:@"提交" forState:UIControlStateNormal];
    [self.view addSubview:btn5];

    
    
    UILabel *label7 = [[UILabel alloc]initWithFrame:CGRectMake(0, btn5.maxY+10*SW,kW, 20*SW)];
    label7.text = @"请点击按钮表示您同意《慧鲸学堂服务协议》";
    label7.textAlignment = 1;
    label7.font = TextsmlFont;
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:@"请点击按钮表示您同意《慧鲸学堂服务协议》"];
    //获取要调整颜色的文字位置,调整颜色
    NSRange range1=[[hintString string]rangeOfString:@"请点击按钮表示您同意"];
    [hintString addAttribute:NSForegroundColorAttributeName value:TextNoColor range:range1];
    
    NSRange range2=[[hintString string]rangeOfString:@"《慧鲸学堂服务协议》"];
    [hintString addAttribute:NSForegroundColorAttributeName value:NavAndBtnColor range:range2];
    
    label7.attributedText=hintString;
    [self.view addSubview:label7];
    
    UIButton *agreebtn = [[UIButton alloc]initWithFrame:CGRectMake(42*SW, btn5.maxY, 40*SW, 40*SW)];
    [agreebtn addTarget:self action:@selector(agreebtnaction:) forControlEvents:UIControlEventTouchUpInside];
    
    [agreebtn setImage:[UIImage imageNamed:@"51_"] forState:UIControlStateNormal];
    [agreebtn setImage:[UIImage imageNamed:@"54_"] forState:UIControlStateSelected];
    [self.view addSubview:agreebtn];
}

-(void)btn1:(UIButton *)sender{
    btn1.selected = YES;
    btn1.layer.borderColor = [NavAndBtnColor CGColor];
    img1.hidden = NO;
    img2.hidden = YES;
    img3.hidden = YES;

    
    btn2.layer.borderColor = [[UIColor grayColor]CGColor];
    btn2.selected = NO;
    btn3.layer.borderColor = [[UIColor grayColor]CGColor];
    btn3.selected = NO;
}
-(void)btn2:(UIButton *)sender{
    btn2.selected = YES;
    btn2.layer.borderColor = [NavAndBtnColor CGColor];
    img1.hidden = YES;
    img2.hidden = NO;
    img3.hidden = YES;
    btn1.layer.borderColor = [[UIColor grayColor]CGColor];
    btn1.selected = NO;
    btn3.layer.borderColor = [[UIColor grayColor]CGColor];
    btn3.selected = NO;
}
-(void)btn3:(UIButton *)sender{
    btn3.selected = YES;
    btn3.layer.borderColor = [NavAndBtnColor CGColor];
    img1.hidden = YES;
    img2.hidden = YES;
    img3.hidden = NO;
    btn2.layer.borderColor = [[UIColor grayColor]CGColor];
    btn2.selected = NO;
    btn1.layer.borderColor = [[UIColor grayColor]CGColor];
    btn1.selected = NO;
}
- (IBAction)popview:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)btn4:(UIButton *)sender{
    CardViewController *cardvc = [[CardViewController alloc]init];
    [self.navigationController pushViewController:cardvc animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)botonaction{
    PayViewController *payvc = [[PayViewController alloc]init];
    [self.navigationController pushViewController:payvc animated:YES];
    [self.navigationController setNavigationBarHidden:NO];

}

-(void)agreebtnaction:(UIButton *)sender{
    sender.selected = !sender.selected;
}
@end
