//
//  DiaInfoViewController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/1/30.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "DiaInfoViewController.h"

@interface DiaInfoViewController ()

@end

@implementation DiaInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title =@"诊股详情";
    self.view.backgroundColor = ALLViewBgColor;
    [self getmainview];
    NSLog(@"%@",_dataDic);
    // Do any additional setup after loading the view.
}

-(void)getmainview{
    UIView *topview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kW, 100*SW)];
    topview.backgroundColor = CWHITE;
    [self.view addSubview:topview];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(15*SW, 15*SW, 80*SW, 20)];
    label1.textColor = TextNoColor;
    label1.text = @"股票信息:";
    label1.font = TextFont;
    [topview addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(15*SW, 50*SW, 80*SW, 20)];
    label2.textColor = TextNoColor;
    label2.text = @"问题描述:";
    label2.font = TextFont;
    [topview addSubview:label2];
    
    UILabel *titlabel = [[UILabel alloc]initWithFrame:CGRectMake(label1.maxX + 15*SW, 15*SW, topview.width - label1.maxX-25*SW, 20*SW)];
    titlabel.textColor = NavAndBtnColor;
    titlabel.text = _dataDic[@"questiontitle"];
    titlabel.font = FONT(17);
    [topview addSubview:titlabel];
    
    UILabel *Qlabel = [[UILabel alloc]initWithFrame:CGRectMake(label1.maxX + 15*SW, 50*SW, topview.width - label1.maxX-25*SW, 20*SW)];
    Qlabel.textColor = NavAndBtnColor;
    Qlabel.text = _dataDic[@"questiondes"];
    Qlabel.font = FONT(17);

    //自动折行设置
    Qlabel.lineBreakMode = NSLineBreakByWordWrapping;
    Qlabel.numberOfLines = 0;
    //根据内容大小，动态设置UILabel的高度
    CGRect rects1 = [Qlabel.text boundingRectWithSize:CGSizeMake(topview.width - label1.maxX-25*SW, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT(17)} context:nil];
    //            CGSize size1 = [conlb1.text sizeWithFont:conlb1.font constrainedToSize:conlb1.bounds.size lineBreakMode:conlb1.lineBreakMode];
    CGRect rect1 = Qlabel.frame;
    rect1.size = rects1.size;
    Qlabel.frame = rect1;
    [topview addSubview:Qlabel];
    
    CGRect rect3 = topview.frame;
    NSInteger maxcH = Qlabel.maxY+15*SW;
    rect3.size.height = maxcH;
    topview.frame = rect3;
    
    UIView *ln = [[UIView alloc]initWithFrame:CGRectMake(0, topview.maxY-1, kW, 1)];
    ln.backgroundColor = LnColor;
    [topview addSubview:ln];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, topview.maxY, kW, self.view.height)];
    view1.backgroundColor = CWHITE;
    [self.view addSubview:view1];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(15*SW, 15*SW, 150*SW, 20)];
    label3.textColor = TextNoColor;
    label3.font = TextsmlFont;
    label3.text = _dataDic[@"answertime"];
    [view1 addSubview:label3];

    
    UILabel *Alabel = [[UILabel alloc]initWithFrame:CGRectMake( 15*SW, 50*SW, view1.width - 25*SW, 20*SW)];
    Alabel.textColor = TextNoColor;
    Alabel.text = _dataDic[@"answer"];
    Alabel.font = FONT(17);
    
    //自动折行设置
    Alabel.lineBreakMode = NSLineBreakByWordWrapping;
    Alabel.numberOfLines = 0;
    //根据内容大小，动态设置UILabel的高度
    CGRect rects2 = [Alabel.text boundingRectWithSize:CGSizeMake( view1.width - 25*SW, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT(17)} context:nil];
    //            CGSize size1 = [conlb1.text sizeWithFont:conlb1.font constrainedToSize:conlb1.bounds.size lineBreakMode:conlb1.lineBreakMode];
    CGRect rect2 = Alabel.frame;
    rect2.size = rects2.size;
    Alabel.frame = rect2;
    [view1 addSubview:Alabel];
    


    
}

@end
