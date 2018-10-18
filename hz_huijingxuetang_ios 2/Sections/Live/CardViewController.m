//
//  CardViewController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/1/24.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "CardViewController.h"
#import "CardTableViewCell.h"
@interface CardViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation CardViewController
{
    UITableView *tableview;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"代金券";
    self.view.backgroundColor = ALLViewBgColor;
    
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(kW/2 -80*SW , 50*SW, 160*SW, self.view.height/2)];
    imgview.image = [UIImage imageNamed:@"没有代金券_03"];
    [self.view addSubview:imgview];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, imgview.maxY+40*SW, kW, 30)];
    label.textAlignment = 1;
    label.text = @"很遗憾，您没有代金券了";
    label.textColor = TextColor;
    [self.view addSubview:label];
    
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(15*SW, 0, kW-30*SW, self.view.height-64)];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.hidden = NO;
    tableview.backgroundColor = ALLViewBgColor;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cardcell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([CardTableViewCell class]) owner:self options:nil]objectAtIndex:0];
    }

    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = ALLViewBgColor;

    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}
@end
