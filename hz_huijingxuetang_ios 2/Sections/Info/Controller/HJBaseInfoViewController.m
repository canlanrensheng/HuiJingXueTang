//
//  HJBaseInfoViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/6.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJBaseInfoViewController.h"
#import "HJBaseInfoCell.h"
#import "HJBaseInfoHeaderView.h"
#import "HJInfoViewModel.h"
#import "HJInfoCheckPwdAlertView.h"
@interface HJBaseInfoViewController ()

@property (nonatomic,strong) HJBaseInfoHeaderView *headerView;
@property (nonatomic,strong) HJInfoViewModel *viewModel;

@end

@implementation HJBaseInfoViewController

- (HJInfoViewModel *)viewModel {
    if(!_viewModel){
        _viewModel = [[HJInfoViewModel alloc] init];
    }
    return  _viewModel;
}

- (void)hj_configSubViews{
    //    self.tableView.scrollEnabled = NO;
    self.numberOfSections = 1;
    
    self.sectionFooterHeight = 0.001f;
    
    self.headerView = [[HJBaseInfoHeaderView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, kHeight(220))];
    self.headerView.backgroundColor = Background_Color;
    self.tableView.tableHeaderView = self.headerView;
    
    [self.tableView registerClass:[HJBaseInfoCell class] forCellReuseIdentifier:NSStringFromClass([HJBaseInfoCell class])];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)setModel:(HJInfoItemModel *)model {
    _model = model;
    self.tableView.mj_footer.hidden = YES;
    self.viewModel.tableView = self.tableView;
    self.viewModel.page = 1;
    [self.viewModel getListWithModelid:model.itemId Success:^{
        self.headerView.model = self.viewModel.infoListArray.firstObject;
        [self.tableView reloadData];
    }];
}

- (void)hj_loadData {
   
}

- (void)hj_refreshData {
    @weakify(self);
    self.tableView.mj_header = [MKRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.viewModel.page = 1;
        [self.viewModel getListWithModelid:_model.itemId Success:^{
            self.headerView.model = self.viewModel.infoListArray.firstObject;
            [self.tableView reloadData];
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
        });
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.viewModel.page++;
        if(self.viewModel.currentpage < self.viewModel.totalpage){
            [self.viewModel getListWithModelid:_model.itemId Success:^{
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
    return  kHeight(91.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.infoListArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HJBaseInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJBaseInfoCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = HEXColor(@"#EAEAEA");
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setViewModel:self.viewModel indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HJInfoCheckPwdAlertView *alertView = [[HJInfoCheckPwdAlertView alloc] initWithBindBlock:^(BOOL success) {
        HJInfoListModel *model = self.viewModel.infoListArray[indexPath.row];
        if(model.itemId) {
            NSDictionary *para = @{@"infoId" : model.itemId
                                   };
            [DCURLRouter pushURLString:@"route://infoDetailVC" query:para animated:YES];
        }
    }];
    [alertView show];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}

#pragma mark 数据为空的占位视图
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return - kHeight(40);
}


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"学习小组空白页"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"暂无相关文章";
    NSDictionary *attribute = @{NSFontAttributeName: MediumFont(font(15)), NSForegroundColorAttributeName: HEXColor(@"#999999")};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

@end

