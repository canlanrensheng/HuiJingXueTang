//
//  HJStuntJudgeDetailViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/29.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJStuntJudgeDetailViewController.h"

#import "HJStuntJudgeDetailQuestionCell.h"
#import "HJStuntJudgeDetailAnserCell.h"
#import "HJStuntJudgeListModel.h"
#import "HJStuntJudgeViewModel.h"
@interface HJStuntJudgeDetailViewController ()

@property (nonatomic,strong) HJStuntJudgeListModel *model;
@property (nonatomic,strong) HJStuntJudgeViewModel *viewModel;

@end

@implementation HJStuntJudgeDetailViewController

- (void)hj_configSubViews{
    //    self.tableView.scrollEnabled = NO;
    self.navigationItem.title = @"问题详情";
    self.numberOfSections = 1;
    
    self.sectionFooterHeight = 0.001f;
    
    [self.tableView registerClass:[HJStuntJudgeDetailQuestionCell class] forCellReuseIdentifier:NSStringFromClass([HJStuntJudgeDetailQuestionCell class])];
    [self.tableView registerClass:[HJStuntJudgeDetailAnserCell class] forCellReuseIdentifier:NSStringFromClass([HJStuntJudgeDetailAnserCell class])];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:nil image:V_IMAGE(@"分享-1") action:^(id sender) {
          [HJShareTool shareWithTitle:@"慧鲸学堂" content:@"邀请好友" images:nil url:@"http://mp.huijingschool.com/#/share"];
    }];
    NSDictionary *para = self.params;
    HJStuntJudgeListModel *model = para[@"model"];
    self.model = model;
}

- (void)hj_loadData {
    NSDictionary *para = self.params;
    HJStuntJudgeListModel *model = para[@"model"];
    self.viewModel = [[HJStuntJudgeViewModel alloc] init];
    [self.viewModel stockAnsrReadsSettedWithId:model.stuntId Success:^{
        [MBProgressHUD showMessage:@"消息已读" view:self.view];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"StuntJudgeMessageRead" object:nil userInfo:nil];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return  self.model.cellHeight;
    }
    return  self.model.answerCellHeight;;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        HJStuntJudgeDetailQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJStuntJudgeDetailQuestionCell class]) forIndexPath:indexPath];
        self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.model;
        return cell;
    }
    HJStuntJudgeDetailAnserCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJStuntJudgeDetailAnserCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}


@end
