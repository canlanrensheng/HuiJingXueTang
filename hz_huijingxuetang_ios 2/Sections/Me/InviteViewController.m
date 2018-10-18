//
//  InviteViewController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/2/6.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "InviteViewController.h"
#import "YJShareTool.h"
@interface InviteViewController ()

@end

@implementation InviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"邀请好友";
    self.view.backgroundColor = ALLViewBgColor;
    
    UIImageView *topimg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kW, (322.5+44+30)*SW)];
    topimg.image = [UIImage imageNamed:@"邀请好友_02"];
    [self.view addSubview:topimg];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(kW/2 - 175/2*SW, 322.5*SW, 175*SW, 44*SW)];
    button.backgroundColor = NavAndBtnColor;
    [button setTitle:@"立即分享" forState:UIControlStateNormal];
    [button setTitleColor:CWHITE forState:UIControlStateNormal];
    button.titleLabel.font = FONT(17);
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)share{
    [YJShareTool ToolShareUrlWithUrl:@"http://mp.huijingschool.com/#/share" title:@"慧鲸学堂" content:@"邀请好友" andViewC:self];
}

@end
