//
//  MyClassViewController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/2/6.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "MyClassViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "LoginViewController.h"
#import "SchoolTableViewCell.h"
@interface MyClassViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MyClassViewController
{
    UITableView *tableview1;
    NSInteger page1;
    NSMutableArray *dataarr1;
    NSInteger totalpage1;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([_type integerValue] == 3) {
        self.navigationItem.title = @"我的精品课";
    }else{
        self.navigationItem.title = @"我的私教课";
    }
    // Do any additional setup after loading the view.
    tableview1 = [[UITableView alloc]initWithFrame:CGRectMake(0,0, kW, self.view.height-SafeAreaTopHeight)];
    tableview1.dataSource = self;
    tableview1.delegate = self;
    tableview1.backgroundColor = ALLViewBgColor;
    tableview1.separatorStyle = 0;
    tableview1.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loaddata1)];
    [tableview1.mj_header beginRefreshing];
    // 底部刷新控件
    tableview1.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoredata1)];
    tableview1.mj_footer.hidden = YES;
    [self.view addSubview:tableview1];
}

-(void)loaddata1{
    if ([[APPUserDataIofo AccessToken]isEqualToString:@""]) {
        LoginViewController *vc = [[LoginViewController alloc]init];
        vc.type = @"1";
        [self.navigationController pushViewController:vc animated:YES];
    }
    page1 = 1;
    NSString *pagestr = [NSString stringWithFormat:@"%ld",page1];
    [YJAPPNetwork MyClssWithAccesstoken:[APPUserDataIofo AccessToken] type:_type page:pagestr success:^(NSDictionary *responseObject) {
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
    [YJAPPNetwork MyClssWithAccesstoken:[APPUserDataIofo AccessToken] type:_type page:pagestr success:^(NSDictionary *responseObject) {
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

-(void)btnAction:(UIButton *)sender{
   
}

-(void)selAction:(UIButton *)sender{
    NSDictionary *dic = dataarr1[sender.tag - 1237];
    NSString *accesstoken = [APPUserDataIofo AccessToken];
    NSString *ID = [dic objectForKey:@"courseid"];
    if ([accesstoken isEqualToString:@""]) {
        SVshowInfo(@"请前往登录");
    }
    [YJAPPNetwork zanwithAccesstoken:accesstoken Id:ID success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            [self loaddata1];
        }else{
            [ConventionJudge NetCode:code vc:self type:@"3"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
    }];
    
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataarr1.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SchoolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"schoolcell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([SchoolTableViewCell class]) owner:self options:nil]objectAtIndex:0];
    }
    cell.free.hidden = YES;
    cell.btn.hidden = NO;
    cell.goonbtn.hidden = NO;
    [cell.btn setTitle:@"课程评价" forState:UIControlStateNormal];
    cell.btn.layer.borderColor = [NavAndBtnColor CGColor];
    cell.btn.layer.borderWidth = 1;
    cell.btn.layer.cornerRadius = 5;
    cell.btn.layer.masksToBounds = YES;
    cell.btn.tag = 91235+ indexPath.section;
    [cell.btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnwidth.constant = 75*SW;
    cell.btn.titleLabel.font = TextFont;
    [cell.btn setTitleColor:NavAndBtnColor forState:UIControlStateNormal];
    
    [cell.goonbtn setTitle:@"继续学习" forState:UIControlStateNormal];
    cell.goonbtn.layer.borderColor = [NavAndBtnColor CGColor];
    cell.goonbtn.layer.borderWidth = 1;
    cell.goonbtn.layer.cornerRadius = 5;
    cell.goonbtn.layer.masksToBounds = YES;
    cell.goonbtn.titleLabel.font = TextFont;
    cell.goonbtn.userInteractionEnabled = NO;

    cell.goonbtnwidth.constant = 75*SW;

    [cell.goonbtn setTitleColor:NavAndBtnColor forState:UIControlStateNormal];
    
    NSDictionary *dic = dataarr1[indexPath.section];
    cell.namelabel1.text = [dic objectForKey:@"coursename"];
    cell.namelabel1.hidden =  NO;
    NSURL *url = [NSURL URLWithString:[dic objectForKey:@"coursepic"]];
    [cell.imgview sd_setImageWithURL:url];
    
    cell.num.text = [NSString stringWithFormat:@"%ld",[[dic objectForKey:@"browsingcount"]integerValue]];
    [cell.zanbtn setTitle:[NSString stringWithFormat:@"  %ld",[[dic objectForKey:@"thumbsupcount"]integerValue]] forState:UIControlStateNormal];
    [cell.zanbtn setTitle:[NSString stringWithFormat:@"  %ld",[[dic objectForKey:@"thumbsupcount"]integerValue]] forState:UIControlStateSelected];
    [cell.zanbtn setTitleColor:TextNoColor forState:UIControlStateNormal];
    [cell.zanbtn setTitleColor:TextNoColor forState:UIControlStateSelected];
    cell.zanbtn.titleLabel.font = FONT(13);
    if ([[dic objectForKey:@"praise"] isEqualToString:@"n"]) {
        cell.zanbtn.selected = NO;
        cell.zanbtn.userInteractionEnabled = YES;
    }else{
        cell.zanbtn.selected = YES;
        cell.zanbtn.userInteractionEnabled = NO;
    }
    cell.zanbtn.tag = 1237+indexPath.section;
    [cell.zanbtn addTarget:self action:@selector(selAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 250;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

   
}
@end
