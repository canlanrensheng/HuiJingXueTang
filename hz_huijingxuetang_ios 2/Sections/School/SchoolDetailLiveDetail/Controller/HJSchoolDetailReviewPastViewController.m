//
//  HJSchoolDetailReviewPastViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/26.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSchoolDetailReviewPastViewController.h"
#import "HJSchoolDetailReviewPastCell.h"
#import "HJPastListModel.h"
@interface HJSchoolDetailReviewPastViewController ()

@property (nonatomic,strong) HJPastListModel *lastModel;

@end

@implementation HJSchoolDetailReviewPastViewController

- (void)viewDidLoad {
    self.tableViewStyle = UITableViewStyleGrouped;
    [super viewDidLoad];
    
}

- (void)hj_configSubViews{
    [self.tableView registerClassCell:[HJSchoolDetailReviewPastCell class]];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)setViewModel:(HJSchoolLiveDetailViewModel *)viewModel {
    _viewModel = viewModel;
    self.viewModel.tableView = self.tableView;
    self.tableView.mj_footer.hidden = YES;
    self.viewModel.page = 1;
    [self.viewModel getPastCourseListDataWithSuccess:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)hj_refreshData {
    @weakify(self);
    self.tableView.mj_header = [MKRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.viewModel.page = 1;
        self.viewModel.tableView = self.tableView;
         self.tableView.mj_footer.hidden = YES;
         self.viewModel.page = 1;
         [self.viewModel getPastCourseListDataWithSuccess:^{
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
            [self.viewModel getPastCourseListDataWithSuccess:^{
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
    return  kHeight(48.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.pastListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HJSchoolDetailReviewPastCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJSchoolDetailReviewPastCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = HEXColor(@"#EAEAEA");
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = RGBA(255, 255, 255, 0.5);
    if (indexPath.row < self.viewModel.pastListArray.count) {
        [cell setViewModel:self.viewModel indexPath:indexPath];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.viewModel.pastListArray.count) {
        kRepeatClickTime(1.0);
        HJPastListModel *model = self.viewModel.pastListArray[indexPath.row];
        self.lastModel.isPlay = NO;
        model.isPlay = YES;
        self.lastModel = model;
        [self.tableView reloadData];
        
        NSString *playUrl = model.videourl;
        if([NSString dealNullStringWithObject:playUrl].length <= 0) {
            playUrl = @"";
        }
        [DCURLRouter pushURLString:@"route://liveReviewVC" query:@{
                                                                   @"videourl" : playUrl,
                                                                   @"liveId" : self.viewModel.liveId,
                                                                   @"teacherId" : self.viewModel.teacherId,
                                                                   @"isFree" : @(self.viewModel.isFree) ,
                                                                   @"courseid" : model.courseid ,
                                                                   @"coursename" : model.coursename.length > 0 ? model.coursename : @""
                                                                   } animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001f;
}


@end
