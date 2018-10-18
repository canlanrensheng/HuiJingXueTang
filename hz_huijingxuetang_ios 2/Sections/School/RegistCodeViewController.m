//
//  RegistCodeViewController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/1/30.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "RegistCodeViewController.h"

@interface RegistCodeViewController ()

@end

@implementation RegistCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = CWHITE;
    self.navigationItem.title =@"一秒注册";
    UIImageView *liveimgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kW, 208*SH)];
    liveimgview.image = [UIImage imageNamed:@"一秒注册_02"];
    [self.view addSubview:liveimgview];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, liveimgview.maxY, kW, 60*SH)];
    label.text = @"图文介绍";
    label.textAlignment = 1;
    [self.view addSubview:label];
    
    UIImageView *codeimgview = [[UIImageView alloc]initWithFrame:CGRectMake(50*SW, label.maxY, kW-100*SW, 300*SH)];
    codeimgview.image = [UIImage imageNamed:@"一秒注册_05"];
    [self.view addSubview:codeimgview];
    
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, codeimgview.maxY, kW, 60*SH)];
    label2.text = @"图片长按扫描注册";
    label2.textAlignment = 1;
    [self.view addSubview:label2];
    
}



@end
