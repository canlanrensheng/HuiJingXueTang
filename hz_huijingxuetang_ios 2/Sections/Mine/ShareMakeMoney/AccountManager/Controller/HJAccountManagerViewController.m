//
//  HJAccountManagerViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/23.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJAccountManagerViewController.h"
#import "HJAccountManagerCell.h"
#import "HJAccountManagerViewModel.h"
#import "HJAccountManagerModel.h"
@interface HJAccountManagerViewController ()

@property (nonatomic,strong) HJAccountManagerViewModel *viewModel;

@end

@implementation HJAccountManagerViewController

- (HJAccountManagerViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[HJAccountManagerViewModel alloc] init];
    }
    return _viewModel;
}

- (void)hj_setNavagation {
    self.title = @"账户管理";
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 26, 40);
    [backButton setImage:[UIImage imageNamed:@"导航返回按钮"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backSelf) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarItem1 = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(32, 0, 26, 40);
    [closeButton setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeSelf) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarItem2 = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    self.navigationItem.leftBarButtonItems = @[leftBarItem1,leftBarItem2];
}

- (void)backSelf {
    [DCURLRouter popViewControllerAnimated:YES];
}

- (void)closeSelf {
    [DCURLRouter popToRootViewControllerAnimated:YES];
}

- (void)hj_configSubViews{
    //    self.tableView.scrollEnabled = NO;
    self.numberOfSections = 1;
    
    self.sectionFooterHeight = 0.001f;
    
    [self.tableView registerClass:[HJAccountManagerCell class] forCellReuseIdentifier:NSStringFromClass([HJAccountManagerCell class])];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)hj_loadData {
    [self.viewModel getAccountManagerListSuccess:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  kHeight(45.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.accountManagerArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HJAccountManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJAccountManagerCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = HEXColor(@"#EAEAEA");
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row < self.viewModel.accountManagerArray.count) {
        [cell setViewModel:self.viewModel indexPath:indexPath];
        @weakify(self);
        [cell.backSub subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self hj_loadData];
        }];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.viewModel.accountManagerArray.count) {
        kRepeatClickTime(1.0);
        HJAccountManagerModel *model = self.viewModel.accountManagerArray[indexPath.row];
        if (model.bingdingstatus == 0) {
            //添加账户
            RACSubject *backSub = [[RACSubject alloc] init];
            @weakify(self);
            [backSub subscribeNext:^(id  _Nullable x) {
                @strongify(self);
                [self hj_loadData];
            }];
            NSDictionary *para = @{@"type" : @(model.type),@"subject" : backSub};
            [DCURLRouter pushURLString:@"route://addAccountVC" query:para animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}

#pragma mark 数据为空的占位视图
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return - kHeight(40);
}


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"绝技诊股空白页"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"暂时还没有账户信息哦";
    NSDictionary *attribute = @{NSFontAttributeName: MediumFont(font(15)), NSForegroundColorAttributeName: HEXColor(@"#999999")};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

@end
