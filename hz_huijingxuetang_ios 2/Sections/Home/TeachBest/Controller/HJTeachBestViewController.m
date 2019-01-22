//
//  HJTeachBestViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/2.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJTeachBestViewController.h"
#import "HJBaseTeachBestListCell.h"
#import "HJTeachBestListModel.h"
#import "HJTeachBestViewModel.h"
#import "HJInfoCheckPwdAlertView.h"
@interface HJTeachBestViewController ()

@property (nonatomic,strong) HJTeachBestViewModel *viewModel;
@property (nonatomic,assign) BOOL isVip;

@end

@implementation HJTeachBestViewController

- (HJTeachBestViewModel *)viewModel {
    if(!_viewModel){
        _viewModel = [[HJTeachBestViewModel alloc] init];
    }
    return  _viewModel;
}

- (void)hj_setNavagation {
    self.title = @"教参精华";
}

- (void)hj_configSubViews {
    self.numberOfSections = 1;
    
    self.sectionFooterHeight = 0.001f;
    
    [self.tableView registerClass:[HJBaseTeachBestListCell class] forCellReuseIdentifier:NSStringFromClass([HJBaseTeachBestListCell class])];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}


- (void)hj_loadData {
    self.tableView.mj_footer.hidden = YES;
    self.viewModel.tableView = self.tableView;
    self.viewModel.page = 1;
    [self.viewModel.loadingView startAnimating];
    [self.viewModel getListWithSuccess:^(BOOL successFlag) {
        [self.viewModel.loadingView stopLoadingView];
        if(self.viewModel.page == 1 && self.viewModel.infoListArray.count <= 0) {
            [[HJCheckUserVipTool shareInstance] checkUserVipWithSuccess:^(int vipNum) {
                if(vipNum == 0) {
                    self.isVip = NO;
                }else {
                    self.isVip = YES;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
}

- (void)hj_refreshData {
    @weakify(self);
    self.tableView.mj_header = [MKRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.viewModel.page = 1;
        [self.viewModel getListWithSuccess:^(BOOL successFlag) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
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
            [self.viewModel getListWithSuccess:^(BOOL successFlag) {
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
    return  kHeight(91.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.infoListArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HJBaseTeachBestListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJBaseTeachBestListCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = HEXColor(@"#EAEAEA");
    [cell setViewModel:self.viewModel indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    kRepeatClickTime(1.0);
    if(MaJia) {
        HJTeachBestListModel *model = self.viewModel.infoListArray[indexPath.row];
        if(model.articalid) {
            NSDictionary *para = @{@"infoId" : model.articalid
                                   };
            [DCURLRouter pushURLString:@"route://teachBestDetailVC" query:para animated:YES];
        }
        return;
    }
    
    HJTeachBestListModel *model = self.viewModel.infoListArray[indexPath.row];
    if(model.articalid) {
        NSDictionary *para = @{@"infoId" : model.articalid
                               };
        [DCURLRouter pushURLString:@"route://teachBestDetailVC" query:para animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}

#pragma mark 数据为空的占位视图
//- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
//    return - kHeight(40);
//}


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if([UserInfoSingleObject shareInstance].networkStatus == NotReachable) {
        return [UIImage imageNamed:@"网络问题空白页"];
    } else {
        if (self.isVip) {
            return [UIImage imageNamed:@"学习小组空白页"];
        } else{
            return [UIImage imageNamed:@"我的额课程空白页"];
        }
    }
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"";
    if([UserInfoSingleObject shareInstance].networkStatus == NotReachable) {
        text = @"网络好像出了点问题";
    } else{
        if(self.isVip) {
            text = @"暂无相关文章";
        } else {
            text = @"您没有购买课程，暂无相关文章可查看";
        }
    }
    
    NSDictionary *attribute = @{NSFontAttributeName: MediumFont(font(15)), NSForegroundColorAttributeName: HEXColor(@"#999999")};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    if([UserInfoSingleObject shareInstance].networkStatus == NotReachable) {
        return  [UIImage imageNamed:@"点击刷新"];
    } else {
        if(self.isVip) {
            return nil;
        } else {
            return  [UIImage imageNamed:@"添加课程按钮"];
        }
    }
}

#pragma mark - 空白数据集 按钮被点击时 触发该方法：
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    if([UserInfoSingleObject shareInstance].networkStatus == NotReachable) {
        [self hj_loadData];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"JumpToSchoolVCourse" object:nil userInfo:nil];
        self.tabBarController.selectedIndex = 1;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end


