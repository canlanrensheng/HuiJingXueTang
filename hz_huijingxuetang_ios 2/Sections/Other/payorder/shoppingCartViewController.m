//
//  shoppingCartViewController.m
//  HuiJingSchool
//
//  Created by 陈燕军 on 2018/5/28.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "shoppingCartViewController.h"
#import "OrderInfoViewController.h"
#import "ShopCartCell.h"
#import <MJRefresh.h>

@interface shoppingCartViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation shoppingCartViewController
{
    UITableView *tableview1;
    NSMutableArray *dataarr1;
    NSInteger page1;
    NSInteger totalpage1;
    NSMutableArray *selMuarr;
    UILabel *pricelb;
    BOOL isALLsel;
    UILabel *heji;
    UIButton *bottonbtn;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    selMuarr = [NSMutableArray array];
    [self loaddata1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ALLViewBgColor;
    [self getmainview];
    
    // Do any additional setup after loading the view.
}

-(void)loaddata1{
    page1 = 1;
    NSString *pagestr = [NSString stringWithFormat:@"%ld",page1];
    [YJAPPNetwork MyshoppingCartListWithAccesstoken:[APPUserDataIofo AccessToken] page:pagestr success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            self.navigationItem.title =[NSString stringWithFormat:@"购物车(%ld)",[[dic objectForKey:@"counts"]integerValue]];

            dataarr1 = [NSMutableArray array];
            dataarr1 = [dic objectForKey:@"cartlist"];
            totalpage1 = [[dic objectForKey:@"totalpage"] integerValue];
            if (totalpage1>1) {
                tableview1.mj_footer.hidden = NO;
            }
            [tableview1 reloadData];
            [tableview1.mj_header endRefreshing];
            [self getAllprice];
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

-(void)getAllprice{
    double allprice = 0;
    for (NSString *cid in selMuarr) {
        for (NSDictionary *dic in dataarr1) {
            NSString *Id = [dic objectForKey:@"courseid"];
            if ([Id isEqualToString:cid]) {
                NSString *amont = [dic objectForKey:@"coursemoney"];
                allprice = allprice + [amont doubleValue];
                
            }
        }
    }
    NSLog(@"%.2f",allprice);
    pricelb.text = [NSString stringWithFormat:@"￥%.2f",allprice];
    CGFloat w = [UILabel getWidthWithTitle:pricelb.text font:pricelb.font];
    pricelb.frame = CGRectMake(kW -100*SW - w - 10, 0, w, 50*SW);
    
    heji.frame = CGRectMake(pricelb.minX - 50*SW, 0, 50*SW, 50*SW);
    

    
}


-(void)loadMoredata1{
    
    if (totalpage1 == 0||page1 == totalpage1) {
        [tableview1.mj_footer setState:MJRefreshStateNoMoreData];
        return;
    }else{
        page1++;
    }
    NSString *pagestr = [NSString stringWithFormat:@"%ld",page1];
    [YJAPPNetwork MyshoppingCartListWithAccesstoken:[APPUserDataIofo AccessToken] page:pagestr success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            NSArray *arr = [dic objectForKey:@"cartlist"];
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

-(void)getmainview{
    tableview1 = [[UITableView alloc]init];
    tableview1.frame = CGRectMake(0, 0, kW, kH - SafeAreaTopHeight - SafeAreaBottomHeight-50*SW);
    tableview1.delegate = self;
    tableview1.dataSource = self;
    tableview1.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loaddata1)];
    [tableview1.mj_header beginRefreshing];
    tableview1.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoredata1)];
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectZero];
    tableview1.tableFooterView = footerView;
    [self.view addSubview:tableview1];
    
    UIView *bottonview = [[UIView alloc]initWithFrame:CGRectMake(0, tableview1.maxY, kW, 60*SW+SafeAreaBottomHeight)];
    [self.view addSubview:bottonview];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(kW - 100*SW, 0, 100*SW, 50*SW)];
    button.backgroundColor  = NavAndBtnColor;
    [button setTitle:@"立即购买" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    [bottonview addSubview:button];
    
    pricelb = [[UILabel alloc]init];
    pricelb.textColor = NavAndBtnColor;
    pricelb.font = FONT(15);
    pricelb.text = @"￥0.00";
    [bottonview addSubview:pricelb];
    
    bottonbtn = [[UIButton alloc]initWithFrame:CGRectMake(10*SW, 0, 50*SW, 50*SW)];
    [bottonbtn setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    [bottonbtn setImage:[UIImage imageNamed:@"check"] forState:UIControlStateSelected];
    [bottonbtn addTarget:self action:@selector(bottonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottonview addSubview:bottonbtn];
    
    UILabel *alllb = [[UILabel alloc]initWithFrame:CGRectMake(bottonbtn.maxX, 0, 50*SW, 50*SW)];
    alllb.font = FONT(15);
    alllb.text = @"全选";
    [bottonview addSubview:alllb];
    
    heji = [[UILabel alloc]init];
    heji.text = @"合计: ";
    heji.hidden = NO;
    heji.textAlignment = 2;
    heji.font = FONT(15);
    [bottonview addSubview:heji];

}

-(void)bottonAction:(UIButton *)sender{
    [selMuarr removeAllObjects];

    if (sender.selected == NO) {
        for (int i = 0; i<dataarr1.count; i ++) {
            NSDictionary *dic = dataarr1[i];
            [selMuarr addObject:[dic objectForKey:@"courseid"]];
        }
        sender.selected = YES;
        isALLsel = YES;
    }else{
        sender.selected = NO;
        isALLsel = NO;
    }
    [tableview1 reloadData];
    NSLog(@"%@",selMuarr);
    [self getAllprice];

}


-(void)payAction{
    if (!selMuarr.count) {
        return SVshowInfo(@"请选择要购买课程");
    }
    NSString *ids = [selMuarr componentsJoinedByString:@","];

    [YJAPPNetwork WillPayWithAccesstoken:[APPUserDataIofo AccessToken] cids:ids success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            SVDismiss;
            NSString *orderid = [responseObject objectForKey:@"data"];
            OrderInfoViewController *vc  = [[OrderInfoViewController alloc]init];
            vc.orderid = orderid;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
        
    }];
    
}

-(void)delAction:(UIButton *)sender{
    NSInteger index = sender.tag - 91235;
    NSDictionary *dic = dataarr1[index];
    [YJAPPNetwork DeleteCartWithAccesstoken:[APPUserDataIofo AccessToken] Id:[dic objectForKey:@"courseid"] success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            SVDismiss;
            [selMuarr removeAllObjects];
            bottonbtn.selected = NO;
            [self getAllprice];
            [self loaddata1];
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataarr1.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"shopcartcell";
    ShopCartCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ShopCartCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    NSDictionary *dic = dataarr1[indexPath.row];
    NSURL *url = [NSURL URLWithString:[dic objectForKey:@"coursepic"]];
    [cell.imgview sd_setImageWithURL:url];
    
    cell.textview.text = [dic objectForKey:@"coursename"];
    cell.pricelabel.text = [dic objectForKey:@"coursemoney"];
    if (isALLsel == YES) {
        cell.selbtn.selected = YES;
    }else{
        cell.selbtn.selected = NO;
    }
    cell.selbtn.userInteractionEnabled = NO;
    cell.delbtn.tag = 91235+indexPath.row;
    [cell.delbtn addTarget:self  action:@selector(delAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90*SW;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopCartCell * cell = (ShopCartCell *)[tableView cellForRowAtIndexPath:indexPath]; //即为要得到的cell
    NSDictionary *dic = dataarr1[indexPath.row];
    NSString *indexstrid = [dic objectForKey:@"courseid"];
    if (cell.selbtn.selected == NO) {
        cell.selbtn.selected = YES;
        [selMuarr addObject:indexstrid];
        [self getAllprice];
    }else{
        cell.selbtn.selected = NO;
        [selMuarr removeObject:indexstrid];
        [self getAllprice];
    }
    if (selMuarr.count == dataarr1.count) {
        bottonbtn.selected = YES;
    }else{
        bottonbtn.selected = NO;
    }
    NSLog(@"%@",selMuarr);


}
@end
