//
//  HJStuntJudgeReplyedViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/27.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJStuntJudgeReplyedViewController.h"
#import "HJStuntReplyedCell.h"
#import "HJStuntJudgeViewModel.h"
#import "HJStuntJudgeListModel.h"
@interface HJStuntJudgeReplyedViewController ()

@property (nonatomic,strong) HJStuntJudgeViewModel *viewModel;

@end

@implementation HJStuntJudgeReplyedViewController

- (instancetype)initWithViewModel:(BaseViewModel *)viewModel {
    if(self = [super initWithViewModel:viewModel]) {
        self.viewModel = (HJStuntJudgeViewModel *)viewModel;
    }
    return self;
}

- (void)hj_configSubViews{
    //    self.tableView.scrollEnabled = NO;
    self.numberOfSections = 1;
    
    self.sectionFooterHeight = 0.001f;
    
    [self.tableView registerClass:[HJStuntReplyedCell class] forCellReuseIdentifier:NSStringFromClass([HJStuntReplyedCell class])];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
}

- (void)hj_loadData {
    self.tableView.mj_footer.hidden = YES;
    self.viewModel.tableView = self.tableView;
    self.viewModel.stuntJuageType = StuntJuageTypeReplyed;
    self.viewModel.page = 1;
    [self.viewModel stuntJuageReplyedWithSuccess:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self.viewModel.notreadednum > 0 ) {
                self.viewModel.toolView.repleyedRedLabel.hidden = NO;
                if(self.viewModel.notreadednum < 10) {
                    self.viewModel.toolView.repleyedRedLabel.text = [NSString stringWithFormat:@"%ld",(long)self.viewModel.notreadednum];
                    [self.viewModel.toolView.repleyedRedLabel clipWithCornerRadius:kHeight(7.5) borderColor:nil borderWidth:0];
                    [self.viewModel.toolView.repleyedRedLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(kWidth(15), kHeight(15)));
                        make.centerX.equalTo(self.viewModel.toolView.liveButton).offset(kWidth(25));
                        make.centerY.equalTo(self.viewModel.toolView).offset(-kHeight(9.0));
                    }];
                } else if (self.viewModel.notreadednum < 100) {
                    self.viewModel.toolView.repleyedRedLabel.text = [NSString stringWithFormat:@"%ld",self.viewModel.notreadednum];
                    [self.viewModel.toolView.repleyedRedLabel clipWithCornerRadius:kHeight(7.5) borderColor:nil borderWidth:0];
                    [self.viewModel.toolView.repleyedRedLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(kWidth(20), kHeight(15)));
                        make.centerX.equalTo(self.viewModel.toolView.liveButton).offset(kWidth(25));
                        make.centerY.equalTo(self.viewModel.toolView).offset(-kHeight(9.0));
                    }];
                } else  if(self.viewModel.notreadednum > 99){
                    self.viewModel.toolView.repleyedRedLabel.text = @"99+";
                    [self.viewModel.toolView.repleyedRedLabel clipWithCornerRadius:kHeight(7.5) borderColor:nil borderWidth:0];
                    [self.viewModel.toolView.repleyedRedLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(kWidth(28), kHeight(15)));
                        make.centerX.equalTo(self.viewModel.toolView.liveButton).offset(kWidth(25));
                        make.centerY.equalTo(self.viewModel.toolView.liveButton).offset(-kHeight(9.0));
                    }];
                }
            } else {
                self.viewModel.toolView.repleyedRedLabel.hidden = YES;
            }
            [self.tableView reloadData];
        });
    }];
}


- (void)hj_bindViewModel {
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"RefreshStuntJudgeData" object:nil] subscribeNext:^(NSNotification *noty) {
        @strongify(self);
        NSDictionary *para = noty.userInfo;
        if([[para objectForKey:@"index"] integerValue] == 1) {
            [self hj_loadData];
        }
    }];

    //消息已读之后的刷新
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"StuntJudgeMessageRead" object:nil] subscribeNext:^(NSNotification *noty) {
         [self hj_loadData];
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
    
    self.tableView.mj_footer.hidden = YES;
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.viewModel.page++;
        if(self.viewModel.currentpage < self.viewModel.totalpage){
            [self.viewModel stuntJuageReplyedWithSuccess:^{
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
    if(indexPath.row < self.viewModel.stuntJuageReplyedArray.count) {
        HJStuntJudgeListModel *model = self.viewModel.stuntJuageReplyedArray[indexPath.row];
        return model.cellHeight;
    }
    return  kHeight(140.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.stuntJuageReplyedArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HJStuntReplyedCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJStuntReplyedCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.row < self.viewModel.stuntJuageReplyedArray.count) {
        [cell setViewModel:self.viewModel indexPath:indexPath];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row < self.viewModel.stuntJuageReplyedArray.count) {
        kRepeatClickTime(1.0);
        HJStuntJudgeListModel *model = self.viewModel.stuntJuageReplyedArray[indexPath.row];
        NSDictionary *para = @{@"stuntId" : model.stuntId};
        [DCURLRouter pushURLString:@"route://stuntJudgeDetailVC" query:para animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return - kHeight(40);
}

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
