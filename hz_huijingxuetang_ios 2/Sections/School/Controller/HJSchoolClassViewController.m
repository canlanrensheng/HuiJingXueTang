//
//  HJSchoolClassViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/23.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSchoolClassViewController.h"
#import "HJSchoolClassCell.h"
#import "HJSchoolClassSelectToolView.h"
#import "HJSchoolClassSelectView.h"
#import "HJSchoolCourseListViewModel.h"
@interface HJSchoolClassViewController ()

@property (nonatomic,strong) HJSchoolClassSelectView *selectView;
@property (nonatomic,strong) HJSchoolClassSelectToolView *toolView;
@property (nonatomic,strong) HJSchoolCourseListViewModel *viewModel;

@end

@implementation HJSchoolClassViewController


- (void)viewDidLoad {
    [super viewDidLoad];
//    [self hj_refreshData];
}

- (HJSchoolCourseListViewModel *)viewModel {
    if(!_viewModel){
        _viewModel = [[HJSchoolCourseListViewModel alloc] init];
    }
    return _viewModel;
}

//筛选的视图
- (HJSchoolClassSelectView *)selectView {
    if(!_selectView){
        _selectView = [[HJSchoolClassSelectView alloc] initWithFrame:CGRectMake(-Screen_Width, kNavigationBarHeight, Screen_Width, Screen_Height - kNavigationBarHeight)];
        _selectView.backgroundColor = white_color;
        @weakify(self);
        [_selectView.backSubject subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            if ([x integerValue] == -1) {
                //取消的按钮的点击
                self.toolView.selectButton.selected = NO;
            }else if([x integerValue] == 0) {
                self.toolView.selectButton.selected = NO;
            } else {
                self.toolView.selectButton.selected = YES;
            }
            [self.selectView setFrame:CGRectMake(-Screen_Width, kNavigationBarHeight, Screen_Width, Screen_Height - kNavigationBarHeight)];
        }];
    }
    return _selectView;
}

//加载页面视图
- (void)hj_configSubViews{
    [self.tableView registerClass:[HJSchoolClassCell class] forCellReuseIdentifier:NSStringFromClass([HJSchoolClassCell class])];
    //点击的处理
    HJSchoolClassSelectToolView *toolView = [[HJSchoolClassSelectToolView alloc] init];
    toolView.viewModel = self.viewModel;
    [self.view addSubview:toolView];
    [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(kHeight(40.0));
    }];
    @weakify(self);
    [toolView.clickSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if([x integerValue] == 0) {
            //点击筛选进行的操作
            [UIView animateWithDuration:0.3 animations:^{
                [self.selectView setFrame:CGRectMake(0, kNavigationBarHeight, Screen_Width, Screen_Height - kNavigationBarHeight)];
            }];
        }
    }];
    
    self.toolView = toolView;
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        if(isFringeScreen) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kHeight(40.0), 0, 0, 0));
        } else {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kHeight(40.0), 0, KHomeIndicatorHeight, 0));
        }
    }];
    //添加筛选的试图
    [[UIApplication sharedApplication].keyWindow addSubview:self.selectView];
}

//加载数据请求
- (void)hj_loadData {
    self.tableView.mj_footer.hidden = YES;
    self.viewModel.tableView = self.tableView;
    self.viewModel.page = 1;
    [self.viewModel getListWithSuccess:^{
        self.selectView.viewModel = self.viewModel;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

//监听通知的操作
- (void)hj_bindViewModel {
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"RefreshVideoCourseListData" object:nil] subscribeNext:^(id x) {
        @strongify(self);
//        self.viewModel.page = 1;
//        [self.tableView.mj_footer resetNoMoreData];
//        [self.viewModel getListWithSuccess:^{
//            dispatch_async(dispatch_get_main_queue(), ^{
//               [self.tableView reloadData];
//            });
//        }];
        [self.tableView.mj_header beginRefreshing];
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"HiddenSelectView" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.selectView setFrame:CGRectMake(-Screen_Width, kNavigationBarHeight, Screen_Width, Screen_Height - kNavigationBarHeight)];
    }];
}

//上拉加载和下拉刷新的操作
- (void)hj_refreshData {
    @weakify(self);
    //下拉刷新
    self.tableView.mj_header = [MKRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.viewModel.page = 1;
        [self.viewModel getListWithSuccess:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
        });
    }];
    
    //上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.viewModel.page++;
        if(self.viewModel.currentpage < self.viewModel.totalpage){
            [self.viewModel getListWithSuccess:^{
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

#pragma mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  kHeight(111.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.videoCourseListArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HJSchoolClassCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJSchoolClassCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = HEXColor(@"#EAEAEA");
    [cell setViewModel:self.viewModel indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.viewModel.videoCourseListArray.count){
        kRepeatClickTime(1.0);
        if ([APPUserDataIofo AccessToken].length <= 0) {
            [DCURLRouter pushURLString:@"route://loginVC" animated:YES];
            return;
        }
        Courselist *model = self.viewModel.videoCourseListArray[indexPath.row];
        [DCURLRouter pushURLString:@"route://classDetailVC" query:@{@"courseId" : model.courseid} animated:YES];
    }
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
