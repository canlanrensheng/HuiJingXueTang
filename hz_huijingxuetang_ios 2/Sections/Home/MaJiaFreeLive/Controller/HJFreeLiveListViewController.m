//
//  HJFreeLiveListViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/13.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJFreeLiveListViewController.h"
#import "HJSchoolLiveToolView.h"
#import "HJSchoolLiveCell.h"
#import "HJSchoolLiveListViewModel.h"
#import "HJTeacherLiveModel.h"
@interface HJFreeLiveListViewController ()

@property (nonatomic,strong) HJSchoolLiveListViewModel *viewModel;

@end

@implementation HJFreeLiveListViewController

- (HJSchoolLiveListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[HJSchoolLiveListViewModel alloc] init];
    }
    return _viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)hj_configSubViews{
    self.title = @"直播教学";
    
    [self.tableView registerClass:[HJSchoolLiveCell class] forCellReuseIdentifier:NSStringFromClass([HJSchoolLiveCell class])];
    
    HJSchoolLiveToolView *toolView = [[HJSchoolLiveToolView alloc] init];
    [self.view addSubview:toolView];
    [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(kHeight(40.0));
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kHeight(40.0) , 0, 0, 0));
    }];
}

- (void)hj_loadData {
    self.viewModel.tableView = self.tableView;
    self.tableView.mj_footer.hidden = YES;
    self.viewModel.page = 1;
    [self.viewModel getSchoolLiveListDataWithSuccess:^{
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
            [self.viewModel getSchoolLiveListDataWithSuccess:^{
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
    return self.viewModel.liveListArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HJSchoolLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJSchoolLiveCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = clear_color;
    if (indexPath.row < self.viewModel.liveListArray.count) {
        [cell setViewModel:self.viewModel indexPath:indexPath];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.viewModel.liveListArray.count) {
        kRepeatClickTime(1.0);
        HJTeacherLiveModel *model = self.viewModel.liveListArray[indexPath.row];
        NSString *liveId = @"";
        if (model.l_courseid.length > 0) {
            //正在直播
            liveId = model.l_courseid;
        } else if (model.a_courseid.length > 0) {
            //直播预告
            liveId = model.a_courseid;
        } else if (model.p_courseid.length > 0) {
            //往期回顾
            liveId = model.p_courseid;
        } else {
            //暂无直播
            ShowMessage(@"暂无直播");
            return;
        }
        BOOL isFree = NO;
        if(model.courseid.integerValue == -1) {
            isFree = YES;
        } else {
            //未登陆先登陆
            if([APPUserDataIofo AccessToken].length <= 0) {
//                ShowMessage(@"您还未登录");
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [DCURLRouter pushURLString:@"route://loginVC" animated:YES];
                });
                return;
            }
        }
        [DCURLRouter pushURLString:@"route://schoolDetailLiveVC" query:@{@"liveId" : liveId,
                                                                         @"teacherId" : model.userid.length > 0 ? model.userid : @"",
                                                                         @"isFree" : @(isFree)
                                                                         } animated:YES];
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
        text = @"暂无相关直播";
    }
    
    NSDictionary *attribute = @{NSFontAttributeName: MediumFont(font(15)), NSForegroundColorAttributeName: HEXColor(@"#999999")};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if([UserInfoSingleObject shareInstance].networkStatus == NotReachable) {
        return [UIImage imageNamed:@"网络问题空白页"];
    } else {
        return [UIImage imageNamed:@"老师详情直播空"];
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

