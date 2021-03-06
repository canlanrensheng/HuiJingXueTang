//
//  HJMyShareCommunityDetailViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/28.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJMyShareCommunityDetailViewController.h"
#import "HJMyShareCommunityDetailCell.h"
#import "HJMyShareCommunityDetailViewModel.h"
#import "HJBrokerageDetailFooterView.h"
@interface HJMyShareCommunityDetailViewController ()

@property (nonatomic,strong) HJMyShareCommunityDetailViewModel *viewModel;

@end

@implementation HJMyShareCommunityDetailViewController

- (HJMyShareCommunityDetailViewModel *)viewModel {
    if(!_viewModel){
        _viewModel = [[HJMyShareCommunityDetailViewModel alloc] init];
    }
    return _viewModel;
}

- (void)hj_setNavagation {
    //    self.title = @"11月份";
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

- (void)createHeaderView {
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = HEXColor(@"#F8FCFF");
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(kHeight(40));
    }];
    
    UILabel *courseNameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"课程名",MediumFont(font(13)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 1;
        [label sizeToFit];
    }];
    [topView addSubview:courseNameLabel];
    [courseNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(kWidth(10));
        make.centerY.equalTo(topView);
        make.width.mas_equalTo((Screen_Width - kWidth(20.0)) / 4);
    }];
    
    //单价
    UILabel *finishOrderLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"单价",MediumFont(font(13)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 1;
        [label sizeToFit];
    }];
    [topView addSubview:finishOrderLabel];
    [finishOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.width.mas_equalTo((Screen_Width - kWidth(20.0)) / 4);
        make.left.equalTo(courseNameLabel.mas_right);
    }];
    
    //时间
    UILabel *timeLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"时间",MediumFont(font(13)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 1;
        [label sizeToFit];
    }];
    [topView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.width.mas_equalTo((Screen_Width - kWidth(20.0)) / 4);
        make.left.equalTo(finishOrderLabel.mas_right);
    }];
    
    //手机号
    UILabel * brokerageLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"手机号",MediumFont(font(13)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentRight;
        label.numberOfLines = 1;
        [label sizeToFit];
    }];
    [topView addSubview:brokerageLabel];
    [brokerageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.right.equalTo(topView.mas_right).offset(-kWidth(10));
        make.left.equalTo(timeLabel.mas_right);
    }];
    
    
}

- (void)hj_configSubViews{
    [self createHeaderView];
    
    self.numberOfSections = 1;
    
    self.sectionFooterHeight = 0.001f;
    
    [self.tableView registerClass:[HJMyShareCommunityDetailCell class] forCellReuseIdentifier:NSStringFromClass([HJMyShareCommunityDetailCell class])];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kHeight(40), 0, 0, 0));
    }];
}

- (void)hj_loadData {
    //获取分享的推荐课程的列表
    NSDictionary *para = self.params;
    self.title = [para valueForKey:@"title"];
    self.viewModel.dataParam = para[@"dataParam"];
    self.viewModel.datadaterange = para[@"datadaterange"];
    self.viewModel.tableView = self.tableView;
    self.tableView.mj_footer.hidden = YES;
    self.viewModel.page = 1;
    [self.viewModel getCommunityDetailModelSuccess:^{
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
            [self.viewModel getCommunityDetailModelSuccess:^{
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
    return  kHeight(45.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.communityDetailDataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HJMyShareCommunityDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJMyShareCommunityDetailCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = HEXColor(@"#EAEAEA");
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row < self.viewModel.communityDetailDataArray.count) {
        [cell setViewModel:self.viewModel indexPath:indexPath];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    if (self.viewModel.brokerageDetailArray.count <= 0) {
//        return nil;
//    }
//    HJBrokerageDetailFooterView *footerView = [[HJBrokerageDetailFooterView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, kHeight(40.0))];
//    [footerView setViewModel:self.viewModel];
//    return footerView;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    if (self.viewModel.brokerageDetailArray.count <= 0) {
//        return 0.0001f;
//    }
//    return kHeight(40.0);
//}

#pragma mark 数据为空的占位视图
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"绝技诊股空白页"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"暂时没有社区详情哦";
    NSDictionary *attribute = @{NSFontAttributeName: MediumFont(font(15)), NSForegroundColorAttributeName: HEXColor(@"#999999")};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

@end


