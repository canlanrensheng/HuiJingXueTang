//
//  HJStuntJudgeWaitReplyViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/27.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJStuntJudgeWaitReplyViewController.h"
#import "HJStuntJudgeWaitReplyCell.h"
#import "HJStuntJudgeViewModel.h"
#import "HJStuntJudgeListModel.h"
@interface HJStuntJudgeWaitReplyViewController ()

@property (nonatomic,strong) HJStuntJudgeViewModel *viewModel;

@end

@implementation HJStuntJudgeWaitReplyViewController


- (instancetype)initWithViewModel:(BaseViewModel *)viewModel {
    if(self = [super initWithViewModel:viewModel]) {
        self.viewModel = (HJStuntJudgeViewModel *)viewModel;
    }
    return self;
}

- (void)hj_configSubViews{
    //    self.tableView.scrollEnabled = NO;
    self.numberOfSections = 1;
    
    self.sectionFooterHeight = 0.001f;
    
    [self.tableView registerClass:[HJStuntJudgeWaitReplyCell class] forCellReuseIdentifier:NSStringFromClass([HJStuntJudgeWaitReplyCell class])];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"RefreshWaitReplyListData" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self hj_loadData];
    }];
}

- (void)hj_loadData {
    self.tableView.mj_footer.hidden = YES;
    self.viewModel.tableView = self.tableView;
    self.viewModel.stuntJuageType = StuntJuageTypeWaitReply;
    self.viewModel.page = 1;

    [self.viewModel stuntJuageWaitReplyWithSuccess:^{
        dispatch_async(dispatch_get_main_queue(), ^{
             [self.tableView reloadData];
        });
    }];

}

- (void)hj_bindViewModel {
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"RefreshStuntJudgeData" object:nil] subscribeNext:^(NSNotification *noty) {
        @strongify(self);
        NSDictionary *para = noty.userInfo;
        if([[para objectForKey:@"index"] integerValue] == 2) {
            self.viewModel.stuntJuageType = StuntJuageTypeWaitReply;
            self.viewModel.page = 1;
            [self.viewModel stuntJuageWaitReplyWithSuccess:^{
                [self.tableView reloadData];
            }];
        }
    }];
}

- (void)hj_refreshData {
    @weakify(self);
    self.tableView.mj_header = [MKRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self hj_loadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
        });
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.viewModel.page++;
        if(self.viewModel.currentpage < self.viewModel.totalpage){
            [self.viewModel stuntJuageWaitReplyWithSuccess:^{
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            }];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.tableView reloadData];
        }
    }];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row < self.viewModel.stuntJuageWaitReplyArray.count) {
        HJStuntJudgeListModel *model = self.viewModel.stuntJuageWaitReplyArray[indexPath.row];
        return model.cellHeight;
    }
    return  kHeight(140.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.stuntJuageWaitReplyArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HJStuntJudgeWaitReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJStuntJudgeWaitReplyCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.row < self.viewModel.stuntJuageWaitReplyArray.count) {
        [cell setViewModel:self.viewModel indexPath:indexPath];
        @weakify(self);
        [cell.backSubject subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self.tableView reloadData];
        }];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return - kHeight(40);
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"绝技诊股空白页"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"暂时还没有问题哦";
    NSDictionary *attribute = @{NSFontAttributeName: MediumFont(font(15)), NSForegroundColorAttributeName: HEXColor(@"#999999")};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}


@end
