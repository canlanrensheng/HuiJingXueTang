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

#import "HJStuntJudgeDetailViewModel.h"
@interface HJStuntJudgeDetailViewController ()


@property (nonatomic,strong) HJStuntJudgeDetailViewModel *viewModel;

@end

@implementation HJStuntJudgeDetailViewController

- (HJStuntJudgeDetailViewModel *)viewModel {
    if(!_viewModel) {
        _viewModel = [[HJStuntJudgeDetailViewModel alloc] init];
    }
    return _viewModel;
}

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
    
    
//    __weak typeof(self)weakSelf = self;
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:nil image:V_IMAGE(@"分享-1") action:^(id sender) {
//        NSString *shareUrl = [NSString stringWithFormat:@"%@#/share",API_SHAREURL];
//        if([APPUserDataIofo UserID].length > 0) {
//            shareUrl = [NSString stringWithFormat:@"%@?userid=%@",shareUrl,[APPUserDataIofo UserID]];
//        }
//          [HJShareTool shareWithTitle:weakSelf.viewModel.model.questiontitle
//                              content:@"点击查看专家解答。想要和专家一对一提问，下载慧鲸APP，专家互动解答你的所有疑惑！" images:@[V_IMAGE(@"shareImg")]
//                                  url:shareUrl];
//    }];
}

- (void)hj_loadData {
    NSDictionary *para = self.params;
    NSString *stuntId = para[@"stuntId"];
    [self.viewModel stockAnsrReadsSettedWithId:stuntId Success:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"StuntJudgeMessageRead" object:nil userInfo:nil];
    }];

    [self.viewModel.loadingView startAnimating];
    [self.viewModel getStuntJudgeDetailWithId:stuntId Success:^(BOOL successFlag) {
        [self.viewModel.loadingView stopLoadingView];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return  self.viewModel.model.cellHeight > 0 ? self.viewModel.model.cellHeight : kHeight(88.0);
    }
    return  self.viewModel.model.answerCellHeight > 0 ? self.viewModel.model.answerCellHeight : kHeight(88.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        HJStuntJudgeDetailQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJStuntJudgeDetailQuestionCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
        if (self.viewModel.model) {
           cell.model = self.viewModel.model;
        }
        return cell;
    }
    HJStuntJudgeDetailAnserCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJStuntJudgeDetailAnserCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
    if (self.viewModel.model) {
        cell.model = self.viewModel.model;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0) {
        return 0.0001f;
    }
    return 10.0;
}


@end
