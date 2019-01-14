//
//  HJSearchResultMoreTeacherViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/20.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSearchResultMoreTeacherViewController.h"
#import "HJSearchResultTeacherCell.h"
#import "HJSearchResultViewModel.h"
#import "HJSearchResultModel.h"
@interface HJSearchResultMoreTeacherViewController ()

@property (nonatomic,strong) HJSearchResultViewModel *viewModel;

@end

@implementation HJSearchResultMoreTeacherViewController

- (HJSearchResultViewModel *)viewModel {
    if(!_viewModel){
        _viewModel = [[HJSearchResultViewModel alloc] init];
    }
    return  _viewModel;
}

- (void)hj_setNavagation {
    self.title = @"老师";
}

- (void)hj_configSubViews{
    //    self.tableView.scrollEnabled = NO;
    self.numberOfSections = 1;
    
    self.sectionFooterHeight = 0.001f;
    
    [self.tableView registerClass:[HJSearchResultTeacherCell class] forCellReuseIdentifier:NSStringFromClass([HJSearchResultTeacherCell class])];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)hj_loadData {
    self.viewModel.searchParam = self.params[@"searchParam"];
    self.viewModel.tableView = self.tableView;
    self.tableView.mj_footer.hidden = YES;
    self.viewModel.page = 1;
    if(!self.viewModel.isFirstLoadTeacherListData) {
        [self.viewModel.loadingView startAnimating];
    }
    [self.viewModel getMoreTeacherWithSuccess:^(BOOL successFlag) {
        if(!self.viewModel.isFirstLoadTeacherListData) {
            [self.viewModel.loadingView stopLoadingView];
            self.viewModel.isFirstLoadTeacherListData = YES;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
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
            [self.viewModel getMoreTeacherWithSuccess:^(BOOL successFlag) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [self.tableView.mj_footer endRefreshing];
                });
            }];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.tableView reloadData];
        }
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  kHeight(101.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.teacherListArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HJSearchResultTeacherCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJSearchResultTeacherCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = clear_color;
    if (indexPath.row < self.viewModel.teacherListArray.count){
        TeacherResponses *model = self.viewModel.teacherListArray[indexPath.row];
        cell.model = model;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row < self.viewModel.teacherListArray.count ) {
        kRepeatClickTime(1.0);
        TeacherResponses *model = self.viewModel.teacherListArray[indexPath.row];
        [DCURLRouter pushURLString:@"route://teacherDetailVC" query:@{@"teacherId" : model.userid} animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}

#pragma mark 数据为空的占位视图
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"形状 1567"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"暂时没有老师";
    NSDictionary *attribute = @{NSFontAttributeName: MediumFont(font(15)), NSForegroundColorAttributeName: HEXColor(@"#999999")};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}


@end
