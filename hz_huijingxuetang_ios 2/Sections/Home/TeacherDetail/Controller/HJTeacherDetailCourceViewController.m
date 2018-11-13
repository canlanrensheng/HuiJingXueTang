//
//  HJTeacherDetailCourceViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/5.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJTeacherDetailCourceViewController.h"
#import "HJLimitTimeKillCell.h"


@interface HJTeacherDetailCourceViewController ()

@end

@implementation HJTeacherDetailCourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)hj_configSubViews{
    [self.tableView registerClass:[HJLimitTimeKillCell class] forCellReuseIdentifier:NSStringFromClass([HJLimitTimeKillCell class])];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0 , 0, 0, 0));
    }];
}

- (void)hj_loadData {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  kHeight(111.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HJLimitTimeKillCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJLimitTimeKillCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = clear_color;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [DCURLRouter pushURLString:@"route://classDetailVC" animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}


@end

