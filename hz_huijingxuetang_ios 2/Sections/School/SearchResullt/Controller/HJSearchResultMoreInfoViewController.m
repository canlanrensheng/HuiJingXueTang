//
//  HJSearchResultMoreInfoViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/20.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSearchResultMoreInfoViewController.h"
#import "HJSearchResultInfomationCell.h"
#import "HJSearchResultViewModel.h"
#import "HJSearchResultModel.h"

@interface HJSearchResultMoreInfoViewController ()

@property (nonatomic,strong) HJSearchResultViewModel *viewModel;

@end

@implementation HJSearchResultMoreInfoViewController

- (HJSearchResultViewModel *)viewModel {
    if(!_viewModel){
        _viewModel = [[HJSearchResultViewModel alloc] init];
    }
    return  _viewModel;
}

- (void)hj_setNavagation {
    self.title = @"资讯";
}

- (void)hj_configSubViews{
    //    self.tableView.scrollEnabled = NO;
    self.numberOfSections = 1;
    
    self.sectionFooterHeight = 0.001f;
    
    [self.tableView registerClass:[HJSearchResultInfomationCell class] forCellReuseIdentifier:NSStringFromClass([HJSearchResultInfomationCell class])];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}


- (void)hj_loadData {
    self.viewModel.searchParam = self.params[@"searchParam"];
    self.viewModel.tableView = self.tableView;
    self.tableView.mj_footer.hidden = YES;
    self.viewModel.page = 1;
    [self.viewModel getMoreInfoWithSuccess:^{
        [self.tableView reloadData];
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
            [self.viewModel getMoreInfoWithSuccess:^{
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
    return  kHeight(125.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.infoListArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HJSearchResultInfomationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJSearchResultInfomationCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = HEXColor(@"#EAEAEA");
    if (indexPath.row < self.viewModel.infoListArray.count){
        InformationResponses *model = self.viewModel.infoListArray[indexPath.row];
        cell.model = model;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row < self.viewModel.infoListArray.count){
        kRepeatClickTime(1.0);
        InformationResponses *model = self.viewModel.infoListArray[indexPath.row];
        if(model.informationId) {
            NSDictionary *para = @{@"infoId" : model.informationId
                                   };
            [DCURLRouter pushURLString:@"route://infoDetailVC" query:para animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}

#pragma mark 数据为空的占位视图

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"学习小组空白页"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"暂无相关文章";
    NSDictionary *attribute = @{NSFontAttributeName: MediumFont(font(15)), NSForegroundColorAttributeName: HEXColor(@"#999999")};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

@end


