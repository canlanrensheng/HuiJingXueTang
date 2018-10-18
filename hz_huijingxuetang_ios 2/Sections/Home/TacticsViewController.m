//
//  TacticsViewController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/2/5.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "TacticsViewController.h"
#import "InfoMationTableViewCell.h"
#import "VipTacticsInfoViewController.h"
@interface TacticsViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation TacticsViewController

{
    UITableView *tableview1;
    NSArray *dataarr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"VIP策略";
    self.view.backgroundColor = ALLViewBgColor;
    
    tableview1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kW, self.view.height - 64)];
    tableview1.dataSource = self;
    tableview1.delegate = self;
    tableview1.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview1.backgroundColor = ALLViewBgColor;
    [self.view addSubview:tableview1];
    
    [self loaddata];
    
}

-(void)loaddata{
    NSString *accesstoken = [APPUserDataIofo AccessToken];
    if ([accesstoken isEqualToString:@""]) {
        return SVshowInfo(@"请前往登录");
    }
    [YJAPPNetwork VIPtacticswithaccesstoken:accesstoken page:@"" success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            dataarr = [NSArray array];
            dataarr = [dic objectForKey:@"vipnews"];
            [tableview1 reloadData];
            SVDismiss;
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
    }];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataarr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InfoMationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infocell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([InfoMationTableViewCell class]) owner:self options:nil]objectAtIndex:0];
    }
    NSDictionary *dic = dataarr[indexPath.section];
    NSURL *imgurl = [dic objectForKey:@"picurl"];
    [cell.imgview sd_setImageWithURL:imgurl];
    
    cell.title.text = [dic objectForKey:@"articaltitle"];
    cell.timelable.text = [NSString stringWithFormat:@"%@ %ld评论",[dic objectForKey:@"createtime"],[[dic objectForKey:@"readcounts"]integerValue]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = dataarr[indexPath.section];
    VipTacticsInfoViewController *vc = [[VipTacticsInfoViewController alloc]init];
    vc.Id = [dic objectForKey:@"articalid"];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
