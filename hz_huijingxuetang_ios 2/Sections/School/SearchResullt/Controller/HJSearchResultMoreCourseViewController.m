//
//  HJSearchResultMoreCourseViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/20.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSearchResultMoreCourseViewController.h"
#import "HJSearchResultCourceCell.h"
#import "HJSearchResultModel.h"
#import "HJSearchResultViewModel.h"

@interface HJSearchResultMoreCourseViewController ()

@property (nonatomic,strong) HJSearchResultViewModel *viewModel;

@end

@implementation HJSearchResultMoreCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (HJSearchResultViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[HJSearchResultViewModel alloc] init];
    }
    return  _viewModel;
}

- (void)hj_setNavagation {
    self.title = @"课程";
}

- (void)hj_configSubViews{
    [self.tableView registerClass:[HJSearchResultCourceCell class] forCellReuseIdentifier:NSStringFromClass([HJSearchResultCourceCell class])];
    
//    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0 , 0, 0, 0));
    }];
}

- (void)hj_loadData {
    self.viewModel.searchParam = self.params[@"searchParam"];
    self.viewModel.tableView = self.tableView;
    self.tableView.mj_footer.hidden = YES;
    self.viewModel.page = 1;
    if(!self.viewModel.isFirstLoadCourseListData) {
        [self.viewModel.loadingView startAnimating];
    }
    [self.viewModel getMoreCourseWithSuccess:^(BOOL successFlag) {
        if(!self.viewModel.isFirstLoadCourseListData) {
            [self.viewModel.loadingView stopLoadingView];
            self.viewModel.isFirstLoadCourseListData = YES;
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
            [self.viewModel getMoreCourseWithSuccess:^(BOOL successFlag) {
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
    return  kHeight(111.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.courseListArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HJSearchResultCourceCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJSearchResultCourceCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = clear_color;
    if (indexPath.row < self.viewModel.courseListArray.count){
        CourseResponses *model = self.viewModel.courseListArray[indexPath.row];
        cell.model = model;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.viewModel.courseListArray.count){
        kRepeatClickTime(1.0);
        CourseResponses *model = self.viewModel.courseListArray[indexPath.row];
        [DCURLRouter pushURLString:@"route://classDetailVC" query:@{@"courseId" : model.courseid} animated:YES];
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
        text = @"暂无相关课程";
    }
    
    NSDictionary *attribute = @{NSFontAttributeName: MediumFont(font(15)), NSForegroundColorAttributeName: HEXColor(@"#999999")};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if([UserInfoSingleObject shareInstance].networkStatus == NotReachable) {
        return [UIImage imageNamed:@"网络问题空白页"];
    } else {
        return [UIImage imageNamed:@"我的额课程空白页-1"];
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


