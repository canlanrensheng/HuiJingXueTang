//
//  HJLimitTimeKillViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/2.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJLimitTimeKillViewController.h"
#import "HJLimitTimeKillCell.h"
#import "HJLimitKillMoreViewModel.h"
#import "HJHomeLimitKillModel.h"
@interface HJLimitTimeKillViewController ()

@property (nonatomic,strong) HJLimitKillMoreViewModel *viewModel;

@end

@implementation HJLimitTimeKillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (HJLimitKillMoreViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[HJLimitKillMoreViewModel alloc] init];
    }
    return _viewModel;
}

- (void)hj_configSubViews{
    self.title = @"限时特惠";
    [self.tableView registerClass:[HJLimitTimeKillCell class] forCellReuseIdentifier:NSStringFromClass([HJLimitTimeKillCell class])];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0 , 0, 0, 0));
    }];
}

- (void)hj_loadData {
    self.tableView.mj_footer.hidden = YES;
    self.viewModel.page = 1;
    self.viewModel.tableView = self.tableView;
    [self.viewModel getLimitKillMoreListDataSuccess:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)hj_refreshData {
    @weakify(self);
    self.tableView.mj_header = [MKRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.viewModel.tableView = self.tableView;
        self.tableView.mj_footer.hidden = YES;
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
            [self.viewModel getLimitKillMoreListDataSuccess:^{
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
    return  kHeight(111.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.limitKillMoreArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HJLimitTimeKillCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJLimitTimeKillCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = clear_color;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setViewModel:self.viewModel indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row < self.viewModel.limitKillMoreArray.count) {
        kRepeatClickTime(1.0);
        HJHomeLimitKillModel *model = self.viewModel.limitKillMoreArray[indexPath.row];
        [DCURLRouter pushURLString:@"route://classDetailVC" query:@{@"courseId" : model.courseid .length > 0 ? model.courseid : @""} animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"";
    if([UserInfoSingleObject shareInstance].networkStatus == NotReachable) {
        text = @"网络好像出了点问题";
    } else{
        text = @"暂无限时特惠";
    }
    
    NSDictionary *attribute = @{NSFontAttributeName: MediumFont(font(15)), NSForegroundColorAttributeName: HEXColor(@"#999999")};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if([UserInfoSingleObject shareInstance].networkStatus == NotReachable) {
        return [UIImage imageNamed:@"网络问题空白页"];
    } else {
        return [UIImage imageNamed:@"暂无数据空白页"];
    }
}


- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    if([UserInfoSingleObject shareInstance].networkStatus == NotReachable) {
        return  [UIImage imageNamed:@"点击刷新"];
    } else {
        return nil;
    }
}

#pragma mark - 空白数据集 按钮被点击时 触发该方法：
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    if([UserInfoSingleObject shareInstance].networkStatus == NotReachable) {
        [self hj_loadData];
    } else {
        
    }
}

@end
