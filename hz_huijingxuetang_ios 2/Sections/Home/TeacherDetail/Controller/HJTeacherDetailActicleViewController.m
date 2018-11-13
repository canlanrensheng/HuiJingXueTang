//
//  HJTeacherDetailActicleViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/5.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJTeacherDetailActicleViewController.h"
#import "HJBaseTeachBestListCell.h"
@interface HJTeacherDetailActicleViewController ()

@end

@implementation HJTeacherDetailActicleViewController

- (void)hj_configSubViews{
    //    self.tableView.scrollEnabled = NO;
    self.numberOfSections = 1;
    
    self.sectionFooterHeight = 0.001f;
    
    [self.tableView registerClass:[HJBaseTeachBestListCell class] forCellReuseIdentifier:NSStringFromClass([HJBaseTeachBestListCell class])];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)hj_loadData {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  kHeight(126.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HJBaseTeachBestListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJBaseTeachBestListCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = HEXColor(@"#EAEAEA");
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [DCURLRouter pushURLString:@"route://teachBestDetailVC" animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}

@end
