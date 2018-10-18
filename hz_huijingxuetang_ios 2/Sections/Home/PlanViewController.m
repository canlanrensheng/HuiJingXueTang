//
//  PlanViewController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/2/5.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "PlanViewController.h"
#import "PlanTableViewCell.h"
#import "FreeLiveViewController.h"
#import <MJRefresh.h>
#import "ClassInfoViewController.h"
@interface PlanViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation PlanViewController
{
    UITableView *tableview1;
    NSInteger page1;
    NSInteger totalpage1;
    NSMutableArray  *dataarr1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loaddata1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"学习进度";
    self.view.backgroundColor = ALLViewBgColor;
    
    tableview1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kW, self.view.height - 64)];
    tableview1.dataSource = self;
    tableview1.delegate = self;
    tableview1.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview1.backgroundColor = ALLViewBgColor;
    tableview1.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loaddata1)];
    tableview1.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoredata1)];
    tableview1.mj_footer.hidden = YES;
    [self.view addSubview:tableview1];
    
}
-(void)goonAction:(UIButton *)sender{
    NSInteger index = sender.tag - 1863;
    NSDictionary *dic = dataarr1[index];

    ClassInfoViewController* civc = [[ClassInfoViewController alloc]init];
    civc.courseId = [dic objectForKey:@"courseid"];
    [self.navigationController pushViewController:civc animated:YES];
}


-(void)loaddata1{
    page1 = 1;
    NSString *pagestr = [NSString stringWithFormat:@"%ld",page1];
    [YJAPPNetwork MycoursestudyWithaccesstoken:[APPUserDataIofo AccessToken] page:pagestr success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            dataarr1 = [NSMutableArray array];
            dataarr1 = [dic objectForKey:@"courselist"];
            totalpage1 = [[dic objectForKey:@"totalpage"] integerValue];
            if (totalpage1>1) {
                tableview1.mj_footer.hidden = NO;
            }
            [tableview1 reloadData];
            [tableview1.mj_header endRefreshing];
            SVDismiss;
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
            [tableview1.mj_header endRefreshing];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
        [tableview1.mj_header endRefreshing];
    }];
}




-(void)loadMoredata1{
    
    if (totalpage1 == 0||page1 == totalpage1) {
        [tableview1.mj_footer setState:MJRefreshStateNoMoreData];
        return;
    }else{
        page1++;
    }
    NSString *pagestr = [NSString stringWithFormat:@"%ld",page1];
    [YJAPPNetwork SpecialistwithType:@"-1" page:pagestr success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            NSArray *arr = [dic objectForKey:@"courselist"];
            [dataarr1 addObjectsFromArray:arr];
            [tableview1 reloadData];
            SVDismiss;
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
        [tableview1.mj_footer endRefreshing];
        
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
        [tableview1.mj_footer endRefreshing];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataarr1.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PlanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"plancell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([PlanTableViewCell class]) owner:self options:nil]objectAtIndex:0];
    }
    cell.goonbtn.layer.cornerRadius = 3;
    cell.goonbtn.layer.masksToBounds = YES;
    cell.goonbtn.backgroundColor = NavAndBtnColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dic = dataarr1[indexPath.section];
    NSURL *url = [NSURL URLWithString:[dic objectForKey:@"coursepic"]];
    [cell.img sd_setImageWithURL:url];
    cell.titlelb.text = [dic objectForKey:@"coursename"];
    cell.titlelb.lineBreakMode = NSLineBreakByWordWrapping;
    cell.titlelb.numberOfLines = 5;
    [cell.titlelb sizeToFit];
    cell.timelb.text = [dic objectForKey:@"studytime"];


    cell.goonbtn.tag = 1863+indexPath.section;
    [cell.goonbtn addTarget:self action:@selector(goonAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 145;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    return view;
}
@end
