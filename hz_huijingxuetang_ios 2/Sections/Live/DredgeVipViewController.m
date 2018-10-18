//
//  DredgeVipViewController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/1/24.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "DredgeVipViewController.h"

@interface DredgeVipViewController ()

@end

@implementation DredgeVipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"慧鲸学堂";
    self.view.backgroundColor = ALLViewBgColor;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(30*SW, 25*SW, kW-60*SW, 250*SW)];
    view.backgroundColor = CWHITE;
    [self.view addSubview:view];
    
    UIImageView *imgview= [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, view.width, 125*SW)];
    imgview.image = [UIImage imageNamed:@"VIP服务_03"];
    [view addSubview:imgview];
    
    UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(0,imgview.maxY + 8*SW, view.width, 30)];
    lable1.textAlignment = 1;
    lable1.text = @"VIP服务";
    lable1.font = FONT(18);
    [view addSubview:lable1];
    
    UILabel *lable2 = [[UILabel alloc]initWithFrame:CGRectMake(0,lable1.maxY + 10*SW, view.width, 30)];
    lable2.textAlignment = 1;
    lable2.text = @"优惠活动简写";
    lable2.font = FONT(15);
    [view addSubview:lable2];
    
    UIButton *vipbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    vipbtn.frame = CGRectMake(view.width/2-50*SW, lable2.maxY + 7*SW,100*SW, 30*SW);
    vipbtn.backgroundColor = NavAndBtnColor;
    vipbtn.layer.cornerRadius = 3;
    vipbtn.layer.masksToBounds = YES;
    vipbtn.titleLabel.font = FONT(15);
    [vipbtn addTarget:self action:@selector(buyvip) forControlEvents:UIControlEventTouchUpInside];
    [vipbtn setTitle:@"开通VIP服务" forState:UIControlStateNormal];
    [vipbtn setTitleColor:WColor forState:UIControlStateNormal];
    [view addSubview:vipbtn];
    
    UITextView *textview = [[UITextView alloc]initWithFrame:CGRectMake(0, view.maxY + 30 , kW, 200*SW)];
    textview.backgroundColor = [UIColor clearColor];
    textview.textColor = TextColor;
    textview.textAlignment = 1;
    textview.font = TextFont;
    textview.text = @"如果你无法表达你的想\n法，那只说明你还不够了解他\n--阿尔伯特.爱因斯坦";
    [self.view addSubview:textview];
}


-(void)buyvip
{
    UIStoryboard*storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    // 2.通过标识符找到对应的页面
    UIViewController*vc=[storyBoard instantiateViewControllerWithIdentifier:@"BuyVipViewController"];
    // 3.这里以push的方式加载控制器
    [self.navigationController pushViewController:vc animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
}
@end
