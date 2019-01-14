//
//  HJKillPriceViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/21.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJKillPriceViewController.h"
#import "HJKillPriceOrderListCell.h"
#import "HJCommonOrderListCell.h"
#import "HJMyOrderViewModel.h"
#import "HJMyOrderListModel.h"
@interface HJKillPriceViewController ()

@property (nonatomic,strong) HJMyOrderViewModel *viewModel;

@end

@implementation HJKillPriceViewController

- (HJMyOrderViewModel *)viewModel {
    if (!_viewModel){
        _viewModel = [[HJMyOrderViewModel alloc] init];
    }
    return _viewModel;
}

- (void)hj_configSubViews{
    
    self.sectionFooterHeight = 0.001f;
    
    [self.tableView registerClassCell:[HJCommonOrderListCell class]];
    [self.tableView registerClassCell:[HJKillPriceOrderListCell class]];

    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)hj_bindViewModel {
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"OrderPaySuccessNoty" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self hj_loadData];
    }];
}

- (void)hj_loadData {
    self.tableView.mj_footer.hidden = YES;
    self.viewModel.page = 1;
    self.viewModel.tableView = self.tableView;
    self.tableView.mj_footer.hidden = YES;
    [self.viewModel getOrderListWithType:MyOrderTypeKillPriceing success:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)hj_refreshData {
    @weakify(self);
    self.tableView.mj_header = [MKRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.viewModel.page = 1;
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
            [self.viewModel getOrderListWithType:MyOrderTypeKillPriceing success:^{
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
    HJMyOrderListModel *model = self.viewModel.orderListArray[indexPath.row];
    return model.cellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.orderListArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.viewModel.orderListArray.count) {
        HJMyOrderListModel *model = self.viewModel.orderListArray[indexPath.row];
        if(model.cellType == PayCellTypeCommon) {
            HJCommonOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJCommonOrderListCell class]) forIndexPath:indexPath];
            self.tableView.separatorColor = HEXColor(@"#EAEAEA");
            cell.hidden = NO;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setViewModel:self.viewModel indexPath:indexPath];
            @weakify(self);
            [cell.backSub subscribeNext:^(id  _Nullable x) {
                @strongify(self);
                //删除进行的操作
                if(indexPath.row < self.viewModel.orderListArray.count) {
                    DLog(@"砍价订单点击删除进行的操作");
//                    NSMutableArray *marr = [NSMutableArray arrayWithArray:self.viewModel.orderListArray];
//                    [marr removeObjectAtIndex:indexPath.row];
//                    self.viewModel.orderListArray = marr;
//                    [self.tableView reloadData];
                    [self hj_loadData];
                }
            }];
            return cell;
        }
        HJKillPriceOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJKillPriceOrderListCell class]) forIndexPath:indexPath];
        self.tableView.separatorColor = HEXColor(@"#EAEAEA");
        cell.hidden = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setViewModel:self.viewModel indexPath:indexPath];
        @weakify(self);
        [cell.backSub subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            //删除进行的操作
            if(indexPath.row < self.viewModel.orderListArray.count) {
                DLog(@"砍价订单点击删除进行的操作");
//                NSMutableArray *marr = [NSMutableArray arrayWithArray:self.viewModel.orderListArray];
//                [marr removeObjectAtIndex:indexPath.row];
//                self.viewModel.orderListArray = marr;
//                [self.tableView reloadData];
                [self hj_loadData];
            }
        }];
        return cell;
    }
    HJCommonOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJCommonOrderListCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = HEXColor(@"#EAEAEA");
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.hidden = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kHeight(0.0001);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}

#pragma mark 数据为空的占位视图
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return - kHeight(40);
}


- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"";
    if([UserInfoSingleObject shareInstance].networkStatus == NotReachable) {
        text = @"网络好像出了点问题";
    } else{
        text = @"暂时还没有订单哦";
    }
    
    NSDictionary *attribute = @{NSFontAttributeName: MediumFont(font(15)), NSForegroundColorAttributeName: HEXColor(@"#999999")};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if([UserInfoSingleObject shareInstance].networkStatus == NotReachable) {
        return [UIImage imageNamed:@"网络问题空白页"];
    } else {
        return [UIImage imageNamed:@"订单空白页"];
    }
}


- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    if([UserInfoSingleObject shareInstance].networkStatus == NotReachable) {
        return  [UIImage imageNamed:@"点击刷新"];
    } else {
        return nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[HJPayTool shareInstance].payAlertView dismiss];
}

@end
