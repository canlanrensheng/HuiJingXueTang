//
//  FollowViewController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/1/31.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "FollowViewController.h"
#import "FollowTableViewCell.h"
#import "ViewPointViewController.h"
#import <MJRefresh/MJRefresh.h>
@interface FollowViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation FollowViewController
{
    UITableView *tableview;
    NSInteger page;
    NSInteger totilpage;
    NSMutableArray *dataarr;
}

-(void)laoddata{
    page = 1;
    NSString *pagestr = [NSString stringWithFormat:@"%ld",page];
    [YJAPPNetwork Geniusviewlistwithpage:pagestr success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            totilpage = [[dic objectForKey:@"totalpage"]integerValue];
            if (totilpage>1) {
                tableview.mj_footer.hidden = NO;
            }
            dataarr = [NSMutableArray array];
            dataarr = [dic objectForKey:@"gvlist"];
            [tableview reloadData];
            
            SVDismiss;
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
        [tableview.mj_header endRefreshing];

    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
        [tableview.mj_header endRefreshing];

    }];
}


-(void)loadMoredata{
    if (totilpage == 0||page == totilpage) {
        [tableview.mj_footer setState:MJRefreshStateNoMoreData];
        return;
    }else{
        page++;
    }
    NSString *pagestr = [NSString stringWithFormat:@"%ld",page];
    [YJAPPNetwork Geniusviewlistwithpage:pagestr success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            NSArray *arr = [dic objectForKey:@"gvlist"];
            [dataarr addObjectsFromArray:arr];
            [tableview reloadData];
            SVDismiss;
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
        [tableview.mj_footer endRefreshing];
        
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
        [tableview.mj_footer endRefreshing];
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"跟牛人";
    self.view.backgroundColor = ALLViewBgColor;
    
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kW, self.view.height-64)];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.backgroundColor = ALLViewBgColor;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(laoddata)];
    [tableview.mj_header beginRefreshing];
    tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoredata)];
    tableview.mj_footer.hidden = YES;
   
    [self.view addSubview:tableview];
    // Do any additional setup after loading the view.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return dataarr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FollowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"followcell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([FollowTableViewCell class]) owner:self options:nil]objectAtIndex:0];
    }
    cell.contentView.backgroundColor = ALLViewBgColor;
    cell.ln.backgroundColor = LnColor;
    NSDictionary *dic = dataarr[indexPath.section];
    cell.title.text = [dic objectForKey:@"infomationtitle"];
    cell.conter.text = [dic objectForKey:@"descrption"];
    cell.name.text = [dic objectForKey:@"realname"];
    cell.time.text = [dic objectForKey:@"createtime"];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 185;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = dataarr[indexPath.section];

    ViewPointViewController *vc = [[ViewPointViewController alloc]init];
    vc.Id = [dic objectForKey:@"id"];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
