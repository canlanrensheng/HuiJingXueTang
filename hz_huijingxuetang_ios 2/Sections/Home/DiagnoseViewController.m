//
//  DiagnoseViewController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/1/30.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "DiagnoseViewController.h"
#import "HACursor.h"
#import "DiagnoseTableViewCell.h"
#import "DiaInfoViewController.h"
#import <MJRefresh/MJRefresh.h>
@interface DiagnoseViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *titleArray;

@end

@implementation DiagnoseViewController
{
    HACursor*cursor;
    UITableView *tableview1;
    UITableView *tableview2;
    UITableView *tableview3;
    NSInteger totalpage1;
    NSInteger totalpage2;
    NSInteger totalpage3;

    NSInteger page1;
    NSInteger page2;
    NSInteger page3;

    NSMutableArray *dataarr1;
    NSMutableArray *dataarr2;
    NSMutableArray *dataarr3;
    UITextField*textfield2;
    UITextField*textfield1;


}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ALLViewBgColor;
    self.navigationItem.title = @"专家诊股";
    
    [self getmainview];
    [self pageview];
    // Do any additional setup after loading the view.
}
-(void)pageview{
    
    _titleArray=[[NSMutableArray alloc]init];
    [_titleArray addObject:@"全部"];
    [_titleArray addObject:@"已回复"];
    [_titleArray addObject:@"待回复"];
    
    cursor = [[HACursor alloc]init];
    cursor.itemTitleBtnWidth=kW/3;
    cursor.frame = CGRectMake(0, 120*SW, kW, 45);
    cursor.scrollNavBar.linecoler = NavAndBtnColor;
    cursor.titles =_titleArray;
    cursor.pageViews = [self createPageViews];
    cursor.backgroundColor= CWHITE;
    //设置根滚动视图的高度
    cursor.rootScrollViewHeight =self.view.frame.size.height-cursor.maxY-64;
    //    cursor.rootScrollView.backgroundColor=Background_Color;
    //默认值是白色
    cursor.titleNormalColor = TextNoColor;
    //默认值是白色
    cursor.titleSelectedColor = NavAndBtnColor;
    //        cursor.titleSelectedColor = WYColorMain;
    //是否显示排序按钮
    cursor.showSortbutton = NO;
    //    cursor.rootScrollView.rootScrollViewDateSource = self;
    //默认的最小值是5，小于默认值的话按默认值设置
    cursor.minFontSize = 14;
    //默认的最大值是25，小于默认值的话按默认值设置，大于默认值按设置的值处理
    cursor.maxFontSize = 17;
    //cursor.isGraduallyChangFont = NO;
    //在isGraduallyChangFont为NO的时候，isGraduallyChangColor不会有效果
    //cursor.isGraduallyChangColor = NO;
    [self.view addSubview:cursor];
    
}



-(void)getmainview{
    UIView *topview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kW, 110*SW)];
    topview.backgroundColor = CWHITE;
    [self.view addSubview:topview];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(kW-105*SW, 15*SW, 90*SW, 90*SW)];
    [btn setBackgroundImage:[UIImage imageNamed:@"专家诊股_03"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(updataqustion) forControlEvents:UIControlEventTouchUpInside];
    [topview addSubview:btn];
    
    textfield1 = [[UITextField alloc]initWithFrame:CGRectMake(15*SW, 10*SW, 265*SW, 50)];
    textfield1.placeholder = @"输入股票代码、名称";
    [topview addSubview:textfield1];
    
    textfield2 = [[UITextField alloc]initWithFrame:CGRectMake(15*SW, 60*SW, 265*SW, 50)];
    textfield2.placeholder = @"请输入要咨询的问题";
    [topview addSubview:textfield2];
    
    UIView *ln = [[UIView alloc]initWithFrame:CGRectMake(0, 60*SW, textfield2.maxX, 0.5)];
    ln.backgroundColor = LnColor;
    [topview addSubview:ln];
}

-(void)updataqustion{
    if ([[APPUserDataIofo AccessToken]isEqualToString:@""]) {
        return SVshowInfo(@"请登录");
    }
    if (!textfield1.text.length) {
        return SVshowInfo(@"请输入标题");
    }
    if (!textfield2.text.length) {
        return SVshowInfo(@"请输入内容");
    }
    [YJAPPNetwork SpeciaQuestionwithaccesstoken:[APPUserDataIofo AccessToken] title:textfield1.text des:textfield2.text success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            textfield1.text = nil;
            textfield2.text = nil;
            [textfield1 resignFirstResponder];
            [textfield2 resignFirstResponder];
            [self loaddata1];
            [self loaddata2];
            [self loaddata3];
            SVDismiss;
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
        
    }];
}


- (NSMutableArray *)createPageViews{
    
    NSMutableArray *pageViews = [NSMutableArray array];
    for (NSInteger i = 0; i <_titleArray.count; i++)
    {
        if (i==0) {
            tableview1 = [[UITableView alloc]init];
            tableview1.delegate = self;
            tableview1.dataSource = self;
            tableview1.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableview1.backgroundColor = ALLViewBgColor;
            tableview1.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loaddata1)];
            [tableview1.mj_header beginRefreshing];
            // 底部刷新控件
            tableview1.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoredata1)];
            tableview1.mj_footer.hidden = YES;
            [pageViews addObject:tableview1];
            
            
        }else if(i==1){
            tableview2 = [[UITableView alloc]init];
            tableview2.delegate = self;
            tableview2.dataSource = self;
            tableview2.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableview2.backgroundColor = ALLViewBgColor;
            tableview2.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loaddata2)];
            [tableview2.mj_header beginRefreshing];
            // 底部刷新控件
            tableview2.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoredata2)];
            tableview2.mj_footer.hidden = YES;
            [pageViews addObject:tableview2];
            
        }else{
            tableview3 = [[UITableView alloc]init];
            tableview3.delegate = self;
            tableview3.dataSource = self;
            tableview3.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableview3.backgroundColor = ALLViewBgColor;
            tableview3.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loaddata3)];
            [tableview3.mj_header beginRefreshing];
            // 底部刷新控件
            tableview3.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoredata3)];
            tableview3.mj_footer.hidden = YES;
            [pageViews addObject:tableview3];
            
        }
    }
    return pageViews;
}


-(void)loaddata1{
    page1 = 1;
    NSString *pagestr = [NSString stringWithFormat:@"%ld",page1];
    [YJAPPNetwork SpecialistwithType:@"-1" page:pagestr success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            dataarr1 = [NSMutableArray array];
            dataarr1 = [dic objectForKey:@"stocklist"];
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
            NSArray *arr = [dic objectForKey:@"stocklist"];
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

-(void)loaddata2{
    page2 = 1;
    NSString *pagestr = [NSString stringWithFormat:@"%ld",page2];
    [YJAPPNetwork SpecialistwithType:@"0" page:pagestr success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            dataarr2 = [NSMutableArray array];
            dataarr2 = [dic objectForKey:@"stocklist"];
            totalpage2 = [[dic objectForKey:@"totalpage"] integerValue];
            if (totalpage2>1) {
                tableview2.mj_footer.hidden = NO;
            }
            [tableview2 reloadData];
            [tableview2.mj_header endRefreshing];
            SVDismiss;
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
            [tableview2.mj_header endRefreshing];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
        [tableview2.mj_header endRefreshing];
    }];
}

-(void)loadMoredata2{
    
    if (totalpage2 == 0||page2 == totalpage2) {
        [tableview2.mj_footer setState:MJRefreshStateNoMoreData];
        return;
    }else{
        page2++;
    }
    NSString *pagestr = [NSString stringWithFormat:@"%ld",page2];
    [YJAPPNetwork SpecialistwithType:@"0" page:pagestr success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            NSArray *arr = [dic objectForKey:@"stocklist"];
            [dataarr2 addObjectsFromArray:arr];
            [tableview2 reloadData];
            SVDismiss;
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
        [tableview2.mj_footer endRefreshing];
        
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
        [tableview2.mj_footer endRefreshing];
    }];
}

-(void)loaddata3{
    page3 = 1;
    NSString *pagestr = [NSString stringWithFormat:@"%ld",page3];
    [YJAPPNetwork SpecialistwithType:@"1" page:pagestr success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            dataarr3 = [NSMutableArray array];
            dataarr3 = [dic objectForKey:@"stocklist"];
            totalpage3 = [[dic objectForKey:@"totalpage"] integerValue];
            if (totalpage3>1) {
                tableview3.mj_footer.hidden = NO;
            }
            [tableview3 reloadData];
            [tableview3.mj_header endRefreshing];
            SVDismiss;
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
            [tableview3.mj_header endRefreshing];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
        [tableview3.mj_header endRefreshing];
    }];
}

-(void)loadMoredata3{
    
    if (totalpage3 == 0||page3 == totalpage3) {
        [tableview3.mj_footer setState:MJRefreshStateNoMoreData];
        return;
    }else{
        page3++;
    }
    NSString *pagestr = [NSString stringWithFormat:@"%ld",page3];
    [YJAPPNetwork SpecialistwithType:@"1" page:pagestr success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            NSArray *arr = [dic objectForKey:@"stocklist"];
            [dataarr3 addObjectsFromArray:arr];
            [tableview3 reloadData];
            SVDismiss;
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
        [tableview3.mj_footer endRefreshing];
        
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
        [tableview3.mj_footer endRefreshing];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableview1 == tableView) {
        return  dataarr1.count;
    }else if (tableview2 == tableView){
        return  dataarr2.count;
    }else{
        return  dataarr3.count;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DiagnoseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"diacell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([DiagnoseTableViewCell class]) owner:self options:nil]objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic;
    if (tableView == tableview1) {
        dic = dataarr1[indexPath.section];
    }else if (tableView == tableview2){
        dic = dataarr2[indexPath.section];
    }else{
        dic = dataarr3[indexPath.section];
    }
    cell.qlabel.text = [dic objectForKey:@"questiontitle"];
    cell.qlabel.font = FONT(14);
    cell.alabel.text = [dic objectForKey:@"questiondes"];
    cell.alabel.font = FONT(14);
    cell.timelabel.textColor = TextColor;
    cell.timelabel.text = [dic objectForKey:@"createtime"];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 129;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10*SW;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    return  view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DiaInfoViewController*vc = [[DiaInfoViewController alloc]init];
    if (tableView == tableview1) {
        vc.dataDic = dataarr1[indexPath.section];
    }else if(tableView == tableview2){
        vc.dataDic = dataarr2[indexPath.section];
    }else{
        vc.dataDic = dataarr3[indexPath.section];
    }
    [self.navigationController pushViewController:vc animated:YES];

}
@end
