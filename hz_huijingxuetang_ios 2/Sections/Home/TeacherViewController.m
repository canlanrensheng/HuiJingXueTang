//
//  TeacherViewController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/1/31.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "TeacherViewController.h"
#import "TeacherTableViewCell.h"
#import "TeacherInfoViewController.h"
@interface TeacherViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation TeacherViewController
{
    UITableView *tableview;
    NSArray *dataarr;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"名师";
    self.view.backgroundColor = ALLViewBgColor;
    
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kW, self.view.height-64)];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.backgroundColor = ALLViewBgColor;
    [self.view addSubview:tableview];
    
    [self loaddata];
}
-(void)loaddata{
    [YJAPPNetwork TeachTasksuccess:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            dataarr = [NSArray array];
            dataarr = [responseObject objectForKey:@"data"];
            [tableview reloadData];
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
    TeacherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"teachercell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([TeacherTableViewCell class]) owner:self options:nil]objectAtIndex:0];
    }
    if (dataarr.count) {
        NSDictionary *dic = dataarr[indexPath.section];
        NSURL *url = [NSURL URLWithString:[dic objectForKey:@"teacherurl"]];
        [cell.img sd_setImageWithURL:url];
        cell.classlb.text = [NSString stringWithFormat:@"课程： %ld",[[dic objectForKey:@"course_count"]integerValue]];
        cell.openclass.text = [NSString stringWithFormat:@"公开课： %ld",[[dic objectForKey:@"video_count"]integerValue]];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = dataarr[indexPath.section];
    TeacherInfoViewController *vc = [[TeacherInfoViewController alloc]init];
    vc.Id = [dic objectForKey:@"userid"];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
