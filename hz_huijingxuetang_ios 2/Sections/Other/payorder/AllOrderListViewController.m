//
//  AllOrderListViewController.m
//  HuiJingSchool
//
//  Created by 陈燕军 on 2018/6/1.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "AllOrderListViewController.h"
#import "OrderListCell.h"
#import <MJRefresh/MJRefresh.h>
#import "orderModel.h"
#import "OrderInfoViewController.h"
#import "PayInfoViewController.h"
@interface AllOrderListViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation AllOrderListViewController
{
    UIView *bottonln;
    NSMutableArray *dataarr1;
    UITableView *tableview;
    NSInteger page1;
    NSInteger totalpage1;
    NSString *type;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloaddata) name:@"reloaddata" object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"reloaddata" object:nil];
}
-(void)reloaddata{
    [self loaddata1type:type];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ALLViewBgColor;
    type = @"-1";
    [self setNav];
    
    // Do any additional setup after loading the view.
}

-(void)setNav{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kW, SafeAreaTopHeight)];
    view.backgroundColor = NavAndBtnColor;
    [self.view addSubview:view];
    NSInteger btny = 25.5+SafeAreaTopHeight - 64;

    UIButton *popbtn = [[UIButton alloc]initWithFrame:CGRectMake(10*SW, btny, 25, 25)];
    [popbtn setImage:[UIImage imageNamed:@"back_n"] forState:UIControlStateNormal];
    [popbtn setImage:[UIImage imageNamed:@"back_p"] forState:UIControlStateHighlighted];
    [popbtn addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:popbtn];
    
    UIButton *btn1 = [[UIButton alloc]init];
    [btn1 setTitle:@"全部订单" forState:UIControlStateNormal];
    btn1.titleLabel.font = FONT(15);
    [btn1 setTitleColor:WColor forState:UIControlStateNormal];
    btn1.tag = 400;
    [btn1 addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc]init];
    [btn2 setTitle:@"待付款" forState:UIControlStateNormal];
    btn2.titleLabel.font = FONT(15);
    [btn2 setTitleColor:WColor forState:UIControlStateNormal];
    btn2.tag = 400+1;
    [btn2 addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn2];
    
    UIButton *btn3 = [[UIButton alloc]init];
    [btn3 setTitle:@"已付款" forState:UIControlStateNormal];
    btn3.titleLabel.font = FONT(15);
    [btn3 setTitleColor:WColor forState:UIControlStateNormal];
    btn3.tag = 400+2;
    [btn3 addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn3];
    

    btn2.frame = CGRectMake(kW/2 - 45*SW, btny, 90*SW, 25);
    btn1.frame = CGRectMake(btn2.minX - 100*SW, btny, 90*SW, 25);
    btn3.frame = CGRectMake(btn2.maxX + 10*SW, btny, 90*SW, 25);
    
    bottonln = [[UIView alloc]initWithFrame:CGRectMake(btn1.maxX - btn1.width/2 - 75/2, btn1.maxY+6.5, 75, 2.5)];
    bottonln.backgroundColor = WColor;
    [view addSubview:bottonln];
    
    [self getmianview];
}


-(void)pageAction:(UIButton *)btn{
    if (btn.tag - 400 == 1) {
        [UIView animateWithDuration:0.5 animations:^{
            bottonln.transform = CGAffineTransformMakeTranslation(100*SW, 0);
        }];
        type = @"0";
        [tableview.mj_header beginRefreshing];

    }else if (btn.tag - 400 == 2){
        [UIView animateWithDuration:0.5 animations:^{
            bottonln.transform = CGAffineTransformMakeTranslation(100*SW*2, 0);
        }];
        type = @"1";
        [tableview.mj_header beginRefreshing];

    }else{
        [UIView animateWithDuration:0.5 animations:^{
            bottonln.transform = CGAffineTransformIdentity;
        }];
        type = @"-1";
        [tableview.mj_header beginRefreshing];

    }
}

-(void)getmianview{

        tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, kW,kH - SafeAreaTopHeight)];
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.backgroundColor = ALLViewBgColor;
        __weak typeof(self) weakself = self;
        tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loaddata1type:type];
        }];
        [tableview.mj_header beginRefreshing];
        tableview.mj_footer =[MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [weakself loadMoredata1:type];
        }];
        tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableview];
}

-(void)loaddata1type:(NSString *)type{
    page1 = 1;
    NSString *pagestr = [NSString stringWithFormat:@"%ld",page1];
    [YJAPPNetwork getOrderListWithAccesstoken:[APPUserDataIofo AccessToken] type:type page:pagestr success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            dataarr1 = [NSMutableArray array];
            NSArray *arr = [dic objectForKey:@"orderlist"];
            totalpage1 = [[dic objectForKey:@"totalpage"] integerValue];
            if (totalpage1>1) {
                tableview.mj_footer.hidden = NO;
            }
            for (NSDictionary *dic in arr) {
                orderModel *model = [[orderModel alloc]initWithModelDictionary:dic];
                [dataarr1 addObject:model];
            }
            [tableview reloadData];
            [tableview.mj_header endRefreshing];
            SVDismiss;
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
            [tableview.mj_header endRefreshing];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
        [tableview.mj_header endRefreshing];
    }];
}




-(void)loadMoredata1:(NSString *)type{
    
    if (totalpage1 == 0||page1 == totalpage1) {
        [tableview.mj_footer setState:MJRefreshStateNoMoreData];
        return;
    }else{
        page1++;
    }
    NSString *pagestr = [NSString stringWithFormat:@"%ld",page1];
    [YJAPPNetwork getOrderListWithAccesstoken:[APPUserDataIofo AccessToken] type:type page:pagestr success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            NSArray *arr = [dic objectForKey:@"orderlist"];
            NSMutableArray *arr1 = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                orderModel *model = [[orderModel alloc]initWithModelDictionary:dic];
                [arr1 addObject:model];
            }
            [dataarr1 addObjectsFromArray:arr1];
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

-(void)payAction:(UIButton *)sender{
    NSInteger index = sender.tag - 81252;
    orderModel *model = dataarr1[index];
    OrderInfoViewController *vc  = [[OrderInfoViewController alloc]init];
    vc.orderid = model.orderno;
    vc.type = @"2";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)infoAction:(UIButton *)sender{
    NSInteger index = sender.tag - 81253;
    orderModel *model = dataarr1[index];
    NSInteger state = [model.paystatus integerValue];
    if(state == 0){
        OrderInfoViewController *vc  = [[OrderInfoViewController alloc]init];
        vc.orderid = model.orderno;
        vc.type = @"2";
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        PayInfoViewController *vc  = [[PayInfoViewController alloc]init];
        vc.orderid = model.orderno;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)delAction:(UIButton *)sender{
    NSInteger index = sender.tag - 81254;
    orderModel *model = dataarr1[index];
    [YJAPPNetwork DeleteOrderWithAccesstoken:[APPUserDataIofo AccessToken] Id:model.orderno success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            [self loaddata1type:type];
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
        
    }];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataarr1.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"OrderListcell";
    OrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if ( cell == nil) {
        cell = [[OrderListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = 0;
    
    if (dataarr1.count) {
        orderModel *model = dataarr1[indexPath.section];
        cell.model = model;
        cell.paybtn.tag = 81252+indexPath.section;
        [cell.paybtn addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.infobtn.tag = 81253+indexPath.section;
        [cell.infobtn addTarget:self action:@selector(infoAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.delbtn.tag = 81254+indexPath.section;
        [cell.delbtn addTarget:self action:@selector(delAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return  cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140*SW;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10*SW;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50*SW;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    orderModel *model = dataarr1[section];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kW, 50*SW)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15*SW, 0, 90*SW, 50*SW)];
    title.text = @"付款状态";
    title.font = BOLDFONT(15);
    [view addSubview:title];
    
    UILabel *state = [[UILabel alloc]initWithFrame:CGRectMake(kW - 90*SW, 0, 80*SW, 50*SW)];
    state.textAlignment = 2;
    state.font = FONT(15);
    NSInteger orderstate = [model.paystatus integerValue];
    if (orderstate == 0) {
        state.textColor = [UIColor redColor];
        state.text = @"待付款";
    }else if (orderstate == 1){
        state.textColor = NavAndBtnColor;
        state.text = @"已付款";
    }else{
        state.textColor = TextColor;
        state.text = @"已关闭";
    }
    [view addSubview:state];
        
    UIView *ln = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5*SW, kW, 0.5*SW)];
    ln.backgroundColor = LnColor;
    [view addSubview:ln];
    return view;
}
@end
