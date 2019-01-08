//
//  HJTeacherMoreDetailViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/16.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJTeacherMoreDetailViewController.h"
#import "HJTeacherDetailModel.h"
#import "HJTeacherMoreDetailCell.h"
@interface HJTeacherMoreDetailViewController ()

@property (nonatomic,strong) HJTeacherDetailModel *model;

@end

@implementation HJTeacherMoreDetailViewController

- (void)hj_setNavagation {
    self.title = @"详情";
}

- (void)hj_configSubViews{
    //    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = white_color;
    self.numberOfSections = 1;
    
    self.sectionFooterHeight = 0.001f;
    
    [self.tableView registerClass:[HJTeacherMoreDetailCell class] forCellReuseIdentifier:NSStringFromClass([HJTeacherMoreDetailCell class])];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)hj_loadData {
    self.model = self.params[@"model"];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *introction = [NSString stringWithFormat:@"      %@",self.model.introduction];
    CGFloat height = [introction calculateSize:CGSizeMake(Screen_Width - kWidth(20), MAXFLOAT) font:MediumFont(font(13))].height;
    return  height + kHeight(150) + kHeight(20);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HJTeacherMoreDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJTeacherMoreDetailCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = HEXColor(@"#EAEAEA");
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}




@end
