//
//  PayInfoViewController.m
//  HuiJingSchool
//
//  Created by 陈燕军 on 2018/6/1.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "PayInfoViewController.h"
#import "OrderViewCell.h"
@interface PayInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation PayInfoViewController
{
    NSDictionary *datadic;
    NSArray *dataarr;
    NSArray *valuearr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loaddata];
    self.view.backgroundColor = ALLViewBgColor;
    self.navigationItem.title = @"详情";
    // Do any additional setup after loading the view.
}

-(void)getmianview{
    
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    
    NSArray *arr = @[@"付款状态",@"订单号",@"下单时间",@"付款时间",@"支付方式"];
    for (int i = 0; i < 5; i++) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 40*SW*i, kW, 40*SW)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        
        UIView *ln = [[UIView alloc]initWithFrame:CGRectMake(0, 39.5*SW, kW, 0.5*SW)];
        ln.backgroundColor = LnColor;
        [view addSubview:ln];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15*SW, 0, 90*SW, 40*SW)];
        title.text = arr[i];
        title.font = FONT(15);
        [view addSubview:title];
        
        UILabel *value = [[UILabel alloc]initWithFrame:CGRectMake(kW- 300*SW, 0, 290*SW, 40*SW)];
        value.text = valuearr[i];
        value.font = FONT(15);
        value.textAlignment = 2;
        [view addSubview:value];
    }
    
    UIView *orderview = [[UIView alloc]initWithFrame:CGRectMake(0, 200*SW, kW, 90*SW)];
    orderview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:orderview];
    
    UIView *ln1 = [[UIView alloc]initWithFrame:CGRectMake(0, 89.5*SW, kW, 0.5*SW)];
    ln1.backgroundColor = LnColor;
    [orderview addSubview:ln1];
    
    UILabel *allname = [[UILabel alloc]initWithFrame:CGRectMake(15*SW, 0, 50*SW, 90*SW)];
    allname.text = @"总计";
    allname.font = FONT(15);
    [orderview addSubview:allname];
    
    NSArray *arr2 = @[@"原价",@"优惠券抵用",@"优惠价"];
    for (int i = 0; i < 3; i++) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(orderview.width - 180*SW, 7.5*SW+ 25*SW*i, 100*SW, 25*SW)];
        lab.text = arr2[i];
        lab.textAlignment = 2;
        lab.font = FONT(12);
        [orderview addSubview:lab];
    }
    
    
    UILabel *allpricelb = [[UILabel alloc]initWithFrame:CGRectMake(orderview.width - 80*SW, 7.5*SW, 70*SW, 25*SW)];
    allpricelb.text = [NSString stringWithFormat:@"%.2f",[[datadic objectForKey:@"money"]doubleValue]];
    allpricelb.textAlignment = 2;
    allpricelb.font = FONT(12);
    [orderview addSubview:allpricelb];
    
    UILabel *Discountcardlb = [[UILabel alloc]initWithFrame:CGRectMake(orderview.width - 80*SW, 7.5*SW+25*SW, 70*SW, 25*SW)];
    Discountcardlb.text = @"-￥0";
    Discountcardlb.textAlignment = 2;
    Discountcardlb.font = FONT(11);
    Discountcardlb.textColor = [UIColor redColor];
    [orderview addSubview:Discountcardlb];
    
    UILabel *Discountlb = [[UILabel alloc]initWithFrame:CGRectMake(orderview.width - 80*SW, 7.5*SW+25*SW*2, 70*SW, 25*SW)];
    Discountlb.text = [NSString stringWithFormat:@"%.2f",[[datadic objectForKey:@"money"]doubleValue] - 0];
    Discountlb.textAlignment = 2;
    Discountlb.font = FONT(12);
    [orderview addSubview:Discountlb];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, orderview.maxY, kW,kH - orderview.maxY -SafeAreaTopHeight-SafeAreaBottomHeight)];
    view1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view1];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15*SW, 0, 100*SW, 40*SW)];
    label.text = @"课程列表";
    label.font = FONT(15);
    [view1 addSubview:label];
    
    UIView *ln2 = [[UIView alloc]initWithFrame:CGRectMake(0, 39.5*SW, kW, 0.5*SW)];
    ln2.backgroundColor = LnColor;
    [view1 addSubview:ln2];
    
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 40*SW, kW,view1.height - 40*SW-40*SW)];
    tableview.delegate = self;
    tableview.dataSource = self;
    [view1 addSubview:tableview];
    
    UIButton *delbtn = [[UIButton alloc]initWithFrame:CGRectMake(kW - 100*SW, view1.height - 35*SW, 90*SW, 30*SW)];
    [delbtn setTitle:@"删除订单" forState:UIControlStateNormal];
    delbtn.layer.borderColor = [[UIColor redColor] CGColor];
    [delbtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    delbtn.layer.borderWidth = 1;
    delbtn.layer.cornerRadius = 15*SW;
    delbtn.layer.masksToBounds = YES;
    delbtn.titleLabel.font = FONT(15);
    [delbtn addTarget:self action:@selector(delAction) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:delbtn];
    
}

-(void)delAction{
    [YJAPPNetwork DeleteOrderWithAccesstoken:[APPUserDataIofo AccessToken] Id:_orderid success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            SVDismiss;
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"reloaddata" object:self];
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
        
    }];
}
-(void)loaddata{
    [YJAPPNetwork OrderInfoWithAccesstoken:[APPUserDataIofo AccessToken] Id:_orderid success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            SVDismiss;
            datadic = [responseObject objectForKey:@"data"];
            dataarr = [NSArray array];
            dataarr = [datadic objectForKey:@"courselist"];
            valuearr = [NSArray array];
            NSString *paystate;
            NSInteger state = [[datadic objectForKey:@"paystatus"]integerValue];
            if (state == 1) {
                paystate = @"已支付";
            }else if(state == 2){
                paystate = @"已取消";
            }else{
                paystate = @"已取消";
            }
            NSString *ordersn = [datadic objectForKey:@"orderno"];
            NSString *ordertime = [datadic objectForKey:@"createtime"];
            NSString *paytime = [datadic objectForKey:@"paytime"];
            
            NSString *paytype;
            NSInteger type = [[datadic objectForKey:@"paytype"]integerValue];
            if (type == 1) {
                paytype = @"支付宝";
            }else if(type == 2){
                paytype = @"微信";
            }else{
                paytype = @"银联";
            }
            
            valuearr = @[paystate,ordersn,ordertime,paytime,paytype];
            
            
            [self getmianview];
            
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataarr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"ordercell";
    OrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[OrderViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSDictionary *dic = dataarr [indexPath.row];
    NSURL *url = [NSURL URLWithString:[dic objectForKey:@"coursepic"]];
    [cell.imgview sd_setImageWithURL:url];
    
    cell.textview.text = [dic objectForKey:@"coursename"];
    cell.textview.userInteractionEnabled = NO;
    
    cell.pricelabel.text = [NSString stringWithFormat:@"￥%@",[dic objectForKey:@"coursemoney"]];
    cell.selectionStyle = 0;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90*SW;
}
@end
