//
//  HJShareViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/23.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJShareViewController.h"
#import "HJGoodCourseShareCell.h"
#import "HJShareHeaderView.h"
#import "HJShareViewModel.h"
#import "HJShareCourseModel.h"
@interface HJShareViewController ()

@property (nonatomic,strong) HJShareHeaderView *headerView;
@property (nonatomic,strong) HJShareViewModel *viewModel;

@property (nonatomic,strong) UIView *topView;

@end

@implementation HJShareViewController

- (HJShareViewModel *)viewModel {
    if(!_viewModel){
        _viewModel = [[HJShareViewModel alloc] init];
    }
    return  _viewModel;
}

- (void)hj_configSubViews{
    self.tableView.backgroundColor = Background_Color;
    
    self.numberOfSections = 1;
    
    self.sectionFooterHeight = 0.001f;
    
    [self.tableView registerClass:[HJGoodCourseShareCell class] forCellReuseIdentifier:NSStringFromClass([HJGoodCourseShareCell class])];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    //头图
    self.tableView.tableHeaderView = self.headerView;
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = HEXColor(@"#FC3838");
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(kHeight(28));
    }];
    [self.view addSubview:topView];
    
    topView.userInteractionEnabled = YES;
    UITapGestureRecognizer *topTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topTap)];
    [topView addGestureRecognizer:topTap];
    //社区人数统计与规则
    UILabel *ruleTextLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"您已超过15天未邀请好友加入社区，社区收入已冻结！",MediumFont(font(11)),white_color);
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [topView addSubview:ruleTextLabel];
    [ruleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.left.equalTo(topView).offset(kWidth(10.0));
    }];
    
    //问号按钮
    UIButton *questionBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"",H15,white_color,0);
        [button setBackgroundImage:V_IMAGE(@"推广问号") forState:UIControlStateNormal];
    }];
    [topView addSubview:questionBtn];
    [questionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.left.equalTo(ruleTextLabel.mas_right).offset(kWidth(5.0));
        make.size.mas_equalTo(CGSizeMake(kWidth(12), kHeight(12)));
    }];
    
    self.topView = topView;
}

- (void)topTap {
    NSDictionary *para = @{@"fromShare" : @(YES)};
    [DCURLRouter pushURLString:@"route://shareMoneyHelpVC" query:para animated:YES];
}

- (HJShareHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[HJShareHeaderView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, kHeight(238))];
        _headerView.userInteractionEnabled = YES;
    }
    return _headerView;
}

- (void)hj_loadData {
//    [self.viewModel getCurrentMonthMessageWithSuccess:^{
//        //获取到的信息是
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.headerView setViewModel:self.viewModel];
//        });
//    }];
    
    //获取分享的推荐课程的列表
    self.viewModel.tableView = self.tableView;
    self.tableView.mj_footer.hidden = YES;
    self.viewModel.page = 1;
    [self.viewModel.loadingView startAnimating];
    [self.viewModel getShareCourceListSuccess:^(BOOL successFlag) {
        self.topView.hidden = (self.viewModel.overdueInvitationStatus == 1 ? NO : YES);
        [self.viewModel.loadingView stopLoadingView];
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
            [self.viewModel getShareCourceListSuccess:^(BOOL successFlag) {
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
    HJGoodCourseShareCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJGoodCourseShareCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = HEXColor(@"#EAEAEA");
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.row < self.viewModel.courseListArray.count) {
        [cell setViewModel:self.viewModel indexPath:indexPath];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row < self.viewModel.courseListArray.count) {
        kRepeatClickTime(1.0);
        HJShareCourseModel *model = self.viewModel.courseListArray[indexPath.row];
        NSString *courceName = model.coursename.length > 0 ? model.coursename : @"慧鲸学堂";
        NSString *coursedes = model.coursedes.length > 0 ? model.coursedes : @"慧鲸学堂";
        id shareImg = model.coursepic;
        if(model.coursepic.length <= 0) {
            shareImg = V_IMAGE(@"shareImg");
        }
        //推广赚钱
        NSString *shareUrl = [NSString stringWithFormat:@"%@courseDetails?selected=2&courseid=%@&userid=%@&type=2",API_SHAREURL,model.courseid,[APPUserDataIofo UserID]];
        [HJShareTool shareWithTitle:courceName content:coursedes images:@[shareImg] url:shareUrl];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}

#pragma mark 数据为空的占位视图

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return - kHeight(238.0);
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"绝技诊股空白页"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"暂时还没有推荐课程哦";
    NSDictionary *attribute = @{NSFontAttributeName: MediumFont(font(15)), NSForegroundColorAttributeName: HEXColor(@"#999999")};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

@end
