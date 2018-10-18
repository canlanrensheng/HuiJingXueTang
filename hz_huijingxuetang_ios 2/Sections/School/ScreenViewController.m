//
//  ScreenViewController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/2/8.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "ScreenViewController.h"

@interface ScreenViewController ()

@end

@implementation ScreenViewController
{
    NSMutableArray *btnarr1;
    NSMutableArray *btnarr2;
    NSMutableArray *btnarr3;
    NSArray *teacherArr;
    NSArray *typeArr;
    NSArray *priceArr;
    NSString *teacherid;
    NSString *typeid;
    NSString *priceid;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    btnarr1 = [NSMutableArray array];
    btnarr2 = [NSMutableArray array];
    btnarr3 = [NSMutableArray array];

    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(kW - 50*SW, 30, 20*SW, 20*SW)];
    [btn setImage:[UIImage imageNamed:@"43_"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    
    self.view.backgroundColor = ALLViewBgColor;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10*SW, 20, kW, 50*SW)];
    label.text = @"按名师";
    label.font = FONT(20);
    label.textColor = TextColor;
    [self.view addSubview:label];
    
    
    teacherArr = [NSArray array];
    teacherArr = [_datadic objectForKey:@"teacherlist"];
    NSInteger lie0 = teacherArr.count/3;

    for (int i  = 0; i < teacherArr.count ; i ++) {
        NSDictionary *dic = teacherArr[i];
        NSInteger lie = i/3;
        NSInteger row = i%3;
        UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(15*SW + (kW-30*SW)/3*row, label.maxY + 55*SW*lie, (kW-30*SW)/3, 55*SW)];
        [self.view addSubview:bgview];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10*SW, 7.5*SW, bgview.width-20*SW, 40*SW)];
        btn.layer.borderColor = [boderColor CGColor];
        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = 15*SW;
        btn.layer.masksToBounds = YES;
        btn.titleLabel.font = TextFont;

        [btn setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
        [btn setTitleColor:boderColor forState:UIControlStateNormal];
        [btn setTitleColor:NavAndBtnColor forState:UIControlStateSelected];
        btn.tag = 2739 + i;
        [btn addTarget:self action:@selector(btn1Action:) forControlEvents:UIControlEventTouchUpInside];
        if ([self.teacherid isEqualToString:[dic objectForKey:@"id"]]) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
        [btnarr1 addObject:btn];

        [bgview addSubview:btn];
        

    }

    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10*SW,label.maxY+55*SW*lie0, kW, 50*SW)];
    label1.text = @"按分类";
    label1.font = FONT(20);
    label1.textColor = TextColor;
    [self.view addSubview:label1];
    
    typeArr = [NSArray array];
    typeArr = [_datadic objectForKey:@"type"];
    NSInteger lie1 = typeArr.count/3;

    for (int i  = 0; i < typeArr.count ; i ++) {
        NSDictionary *dic = typeArr[i];
        NSInteger lie = i/3;
        NSInteger row = i%3;
        UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(15*SW + (kW-30*SW)/3*row, label1.maxY + 55*SW*lie, (kW-30*SW)/3, 55*SW)];
        [self.view addSubview:bgview];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10*SW, 7.5*SW, bgview.width-20*SW, 40*SW)];
        btn.layer.borderColor = [boderColor CGColor];
        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = 15*SW;
        btn.layer.masksToBounds = YES;
        btn.titleLabel.font = TextFont;

        [btn setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
        [btn setTitleColor:boderColor forState:UIControlStateNormal];
        [btn setTitleColor:NavAndBtnColor forState:UIControlStateSelected];
        btn.tag = 2740 + i;
        [btn addTarget:self action:@selector(btn2Action:) forControlEvents:UIControlEventTouchUpInside];
        if ([self.type isEqualToString:[dic objectForKey:@"id"]]) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
        [btnarr2 addObject:btn];
        [bgview addSubview:btn];
    }
    
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(10*SW,label1.maxY+55*SW*lie1, kW, 50*SW)];
    label2.text = @"按金额";
    label2.font = FONT(20);
    label2.textColor = TextColor;
    [self.view addSubview:label2];
    
    priceArr = [NSArray array];
    priceArr = [_datadic objectForKey:@"price"];

    for (int i  = 0; i < priceArr.count ; i ++) {
        NSDictionary *dic = priceArr[i];
        NSInteger lie = i/3;
        NSInteger row = i%3;
        UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(15*SW + (kW-30*SW)/3*row, label2.maxY + 55*SW*lie, (kW-30*SW)/3, 55*SW)];
        [self.view addSubview:bgview];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10*SW, 7.5*SW, bgview.width-20*SW, 40*SW)];
        btn.layer.borderColor = [boderColor CGColor];
        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = 15*SW;
        btn.layer.masksToBounds = YES;
        btn.titleLabel.font = TextFont;
        [btn setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
        [btn setTitleColor:boderColor forState:UIControlStateNormal];
        [btn setTitleColor:NavAndBtnColor forState:UIControlStateSelected];
        btn.tag = 2741 + i;
        [btn addTarget:self action:@selector(btn3Action:) forControlEvents:UIControlEventTouchUpInside];
        if ([self.price isEqualToString:[dic objectForKey:@"id"]]) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
        [btnarr3 addObject:btn];
        [bgview addSubview:btn];
    }
    
    UIButton *bottonbtn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.height-50*SW, kW/2, 50*SW)];
    [bottonbtn1 setTitleColor:NavAndBtnColor forState:UIControlStateNormal];
    [bottonbtn1 setTitle:@"重置" forState:UIControlStateNormal];
    [bottonbtn1 addTarget:self action:@selector(btn4Action) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:bottonbtn1];
    
    UIButton *bottonbtn2 = [[UIButton alloc]initWithFrame:CGRectMake(kW/2, self.view.height-50*SW, kW/2, 50*SW)];
    bottonbtn2.backgroundColor = NavAndBtnColor;
    [bottonbtn2 setTitleColor:CWHITE forState:UIControlStateNormal];
    [bottonbtn2 setTitle:@"确定" forState:UIControlStateNormal];
    [bottonbtn2 addTarget:self action:@selector(btn5Action) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:bottonbtn2];
    
    UIView *ln = [[UIView alloc]initWithFrame:CGRectMake(0, bottonbtn1.minY - 1, kW, 1)];
    ln.backgroundColor = LnColor;
    [self.view addSubview:ln];
    
    
}
-(void)btn1Action:(UIButton *)sender{
    NSInteger index = sender.tag -2739;
    teacherid = [teacherArr[index] objectForKey:@"id"];
    typeid = @"";
    priceid = @"";
    for (UIButton *btn in btnarr1) {
        if (btn.tag - 2739 == index) {
            btn.selected = YES;
            btn.backgroundColor = bgColor;
            btn.layer.borderColor = [NavAndBtnColor CGColor];
        }else{
            btn.selected = NO;
            btn.backgroundColor = [UIColor clearColor];
            btn.layer.borderColor = [boderColor CGColor];
        }
    }
    
    for (UIButton *btn in btnarr2) {
        btn.selected = NO;
        btn.backgroundColor = [UIColor clearColor];
        btn.layer.borderColor = [boderColor CGColor];
    }
    for (UIButton *btn in btnarr3) {
        btn.selected = NO;
        btn.backgroundColor = [UIColor clearColor];
        btn.layer.borderColor = [boderColor CGColor];
    }
}

-(void)btn2Action:(UIButton *)sender{
    NSInteger index = sender.tag -2740;
    teacherid = @"";
    typeid = [typeArr[index] objectForKey:@"id"];
    priceid = @"";
    for (UIButton *btn in btnarr2) {
        if (btn.tag - 2740 == index) {
            btn.selected = YES;
            btn.backgroundColor = bgColor;
            btn.layer.borderColor = [NavAndBtnColor CGColor];
        }else{
            btn.selected = NO;
            btn.backgroundColor = [UIColor clearColor];
            btn.layer.borderColor = [boderColor CGColor];
            
        }
        
    }
    for (UIButton *btn in btnarr1) {
        btn.selected = NO;
        btn.backgroundColor = [UIColor clearColor];
        btn.layer.borderColor = [boderColor CGColor];
    }
    for (UIButton *btn in btnarr3) {
        btn.selected = NO;
        btn.backgroundColor = [UIColor clearColor];
        btn.layer.borderColor = [boderColor CGColor];
    }
}

-(void)btn3Action:(UIButton *)sender{
    NSInteger index = sender.tag -2741;
    teacherid = @"";
    typeid = @"";
    priceid =[priceArr[index] objectForKey:@"id"];
    for (UIButton *btn in btnarr3) {
        if (btn.tag - 2741 == index) {
            btn.selected = YES;
            btn.backgroundColor = bgColor;
            btn.layer.borderColor = [NavAndBtnColor CGColor];
        }else{
            btn.selected = NO;
            btn.backgroundColor = [UIColor clearColor];
            btn.layer.borderColor = [boderColor CGColor];
            
        }
    }
    for (UIButton *btn in btnarr2) {
        btn.selected = NO;
        btn.backgroundColor = [UIColor clearColor];
        btn.layer.borderColor = [boderColor CGColor];
    }
    for (UIButton *btn in btnarr1) {
        btn.selected = NO;
        btn.backgroundColor = [UIColor clearColor];
        btn.layer.borderColor = [boderColor CGColor];
    }
}

-(void)btn4Action{
    teacherid = @"";
    typeid = @"";
    priceid = @"";
    for (UIButton *btn in btnarr1) {
        btn.selected = NO;
        btn.backgroundColor = [UIColor clearColor];
        btn.layer.borderColor = [boderColor CGColor];
    }
    for (UIButton *btn in btnarr2) {
        btn.selected = NO;
        btn.backgroundColor = [UIColor clearColor];
        btn.layer.borderColor = [boderColor CGColor];
    }
    for (UIButton *btn in btnarr3) {
        btn.selected = NO;
        btn.backgroundColor = [UIColor clearColor];
        btn.layer.borderColor = [boderColor CGColor];
    }
}
-(void)btn5Action{
    NSString *status;
    NSString *Id;
    if (teacherid.length) {
        status = @"teacher";
        Id = teacherid;
    }else if (typeid.length){
        status = @"type";
        Id = typeid;
    }else if(priceid.length){
        status = @"price";
        Id = priceid;
    }else{
        status = @"";
        Id = @"";
    }
    self.Block(status, Id);
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end
