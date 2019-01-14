//
//  HJStuntJudgeRecommendViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/27.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJStuntJudgeRecommendViewController.h"
#import "HJStuntJudgeRecommondCell.h"
#import "HJStuntJudgeViewModel.h"
#import "HJStuntJudgeListModel.h"
@interface HJStuntJudgeRecommendViewController ()


@property (nonatomic,strong) HJStuntJudgeViewModel *viewModel;

@end

@implementation HJStuntJudgeRecommendViewController


- (instancetype)initWithViewModel:(BaseViewModel *)viewModel {
    if(self = [super initWithViewModel:viewModel]) {
        self.viewModel = (HJStuntJudgeViewModel *)viewModel;
        
    }
    return self;
}


- (void)hj_loadData {
    self.tableView.mj_footer.hidden = YES;
    self.viewModel.tableView = self.tableView;
    self.viewModel.stuntJuageType = StuntJuageTypeRecommond;
    self.viewModel.page = 1;
    [self.viewModel stuntJuageRecommendWithSuccess:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)hj_configSubViews{
    //    self.tableView.scrollEnabled = NO;
    self.numberOfSections = 1;
    
    self.sectionFooterHeight = 0.001f;
    
    [self.tableView registerClass:[HJStuntJudgeRecommondCell class] forCellReuseIdentifier:NSStringFromClass([HJStuntJudgeRecommondCell class])];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)hj_bindViewModel {
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"RefreshStuntJudgeData" object:nil] subscribeNext:^(NSNotification *noty) {
        @strongify(self);
        NSDictionary *para = noty.userInfo;
        if([[para objectForKey:@"index"] integerValue] == 0) {
            self.viewModel.stuntJuageType = StuntJuageTypeRecommond;
            self.viewModel.page = 1;
            [self.viewModel stuntJuageRecommendWithSuccess:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }];
        }
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
            [self.viewModel stuntJuageRecommendWithSuccess:^{
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
   if(indexPath.row < self.viewModel.stuntJuageRecommendArray.count) {
        HJStuntJudgeListModel *model = self.viewModel.stuntJuageRecommendArray[indexPath.row];
        return model.cellHeight;
    }
    return  kHeight(140.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.stuntJuageRecommendArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HJStuntJudgeRecommondCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJStuntJudgeRecommondCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.row < self.viewModel.stuntJuageRecommendArray.count) {
        [cell setViewModel:self.viewModel indexPath:indexPath];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row < self.viewModel.stuntJuageRecommendArray.count) {
        kRepeatClickTime(1.0);
        HJStuntJudgeListModel *model = self.viewModel.stuntJuageRecommendArray[indexPath.row];
        NSDictionary *para = @{@"stuntId" : model.stuntId};
        [DCURLRouter pushURLString:@"route://stuntJudgeDetailVC" query:para animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}

#pragma mark 数据为空的占位视图
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return - kHeight(40);
}


//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
//    return [UIImage imageNamed:@"绝技诊股空白页"];
//}
//
//- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
//    NSString *text = @"暂时还没有问题哦";
//    NSDictionary *attribute = @{NSFontAttributeName: MediumFont(font(15)), NSForegroundColorAttributeName: HEXColor(@"#999999")};
//    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
//}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"";
    if([UserInfoSingleObject shareInstance].networkStatus == NotReachable) {
        text = @"网络好像出了点问题";
    } else{
        text = @"暂时还没有问题哦";
    }
    
    NSDictionary *attribute = @{NSFontAttributeName: MediumFont(font(15)), NSForegroundColorAttributeName: HEXColor(@"#999999")};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if([UserInfoSingleObject shareInstance].networkStatus == NotReachable) {
        return [UIImage imageNamed:@"网络问题空白页"];
    } else {
        return [UIImage imageNamed:@"绝技诊股空白页"];
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
