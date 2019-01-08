//
//  HJOrderDetailViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/8.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJOrderDetailViewController.h"

#import "HJOrderDetailCourseMessageCell.h"
#import "HJOrderDetailPayMessageCell.h"
#import "HJOrderDetailOperationCell.h"

#import "HJOrderDetailViewModel.h"
#import "HJMyOrderListModel.h"

@interface HJOrderDetailViewController ()

@property (nonatomic,strong) HJOrderDetailViewModel *viewModel;

@end

@implementation HJOrderDetailViewController

- (HJOrderDetailViewModel *)viewModel {
    if(!_viewModel) {
        _viewModel = [[HJOrderDetailViewModel alloc] init];
    }
    return _viewModel;
}


- (void)hj_setNavagation {
    self.title = @"订单详情";
}

- (void)hj_configSubViews{
    
    self.sectionFooterHeight = 0.001f;
    
    [self.tableView registerClassCell:[HJOrderDetailCourseMessageCell class]];
    [self.tableView registerClassCell:[HJOrderDetailPayMessageCell class]];
    [self.tableView registerClassCell:[HJOrderDetailOperationCell class]];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)hj_loadData {
    [self.viewModel.loadingView startAnimating];
    [self.viewModel getOrderDetailWithOrderId:self.params[@"orderId"] success:^(BOOL successFlag) {
        [self.viewModel.loadingView stopLoadingView];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)hj_bindViewModel {
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"OrderPaySuccessNoty" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self hj_loadData];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0) {
        if(self.viewModel.model) {
            return kHeight(45.0 + 10.0) + kHeight(125.0) * self.viewModel.model.courseResponses.count;
        }
        return kHeight(45.0 + 10.0) + kHeight(125.0) * 1;
    }
    if(indexPath.row == 1) {
        return kHeight(117);
    }
    return kHeight(45.0 + 10.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0) {
        HJOrderDetailCourseMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJOrderDetailCourseMessageCell class]) forIndexPath:indexPath];
        self.tableView.separatorColor = HEXColor(@"#EAEAEA");
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(self.viewModel.model) {
            cell.model = self.viewModel.model;
        }
        return cell;
    }
    if(indexPath.row == 1) {
        HJOrderDetailPayMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJOrderDetailPayMessageCell class]) forIndexPath:indexPath];
        self.tableView.separatorColor = HEXColor(@"#EAEAEA");
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(self.viewModel.model){
            cell.model = self.viewModel.model;
        }
        return cell;
    }
    HJOrderDetailOperationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJOrderDetailOperationCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = HEXColor(@"#EAEAEA");
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(self.viewModel.model){
        cell.model = self.viewModel.model;
        cell.viewModel = self.viewModel;
        [cell.backSub subscribeNext:^(id  _Nullable x) {
            [self hj_loadData];
        }];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}

#pragma mark 数据为空的占位视图
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return - kHeight(40);
}


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"订单空白页"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"暂时还没有订单哦";
    NSDictionary *attribute = @{NSFontAttributeName: MediumFont(font(15)), NSForegroundColorAttributeName: HEXColor(@"#999999")};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

@end

