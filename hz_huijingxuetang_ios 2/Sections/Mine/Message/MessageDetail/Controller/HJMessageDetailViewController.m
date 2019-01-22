//
//  HJMessageDetailViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/8.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJMessageDetailViewController.h"
#import "HJMessageDetailCell.h"
#import "HJMessageDetailViewModel.h"
#import "HJMessageDetailModel.h"
#import "HJInfoCheckPwdAlertView.h"
#import "HJCheckLivePwdTool.h"
@interface HJMessageDetailViewController ()

@property (nonatomic,strong) HJMessageDetailViewModel *viewModel;

@end

@implementation HJMessageDetailViewController

- (HJMessageDetailViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[HJMessageDetailViewModel alloc] init];
    }
    return _viewModel;
}

- (void)hj_setNavagation {
//    NSString *type = self.params[@"type"];
//    self.title = @"消息通知";
}

- (void)hj_configSubViews{
    //    self.tableView.scrollEnabled = NO;
    self.numberOfSections = 1;
    
    self.sectionFooterHeight = 0.001f;
    
    [self.tableView registerClass:[HJMessageDetailCell class] forCellReuseIdentifier:NSStringFromClass([HJMessageDetailCell class])];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

 - (void)hj_loadData {
    self.tableView.mj_footer.hidden = YES;
    self.viewModel.page = 1;
    self.viewModel.tableView = self.tableView;
    self.tableView.mj_footer.hidden = YES;
    NSString *type = self.params[@"type"];
     if(type.integerValue == 1) {
         //直播
         self.title =  @"直播通知";
         
     } else if (type.integerValue == 2) {
         //订单
         self.title =  @"订单通知";
         
     } else if (type.integerValue == 3) {
         //讲师
         self.title =  @"讲师消息";
         
     } else {
         //与我有关
         self.title = @"与我相关";
     }
    [self.viewModel getFurtherMessageWithType:type Success:^(BOOL success) {
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
            NSString *type = self.params[@"type"];
            [self.viewModel getFurtherMessageWithType:type Success:^(BOOL success) {
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
    return self.viewModel.messageDetailListArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HJMessageDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJMessageDetailCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = clear_color;
    if(indexPath.row < self.viewModel.messageDetailListArray.count) {
        [cell setViewModel:self.viewModel indexPath:indexPath];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HJMessageDetailCell *cell = (HJMessageDetailCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row < self.viewModel.messageDetailListArray.count) {
        kRepeatClickTime(1.0);
        HJMessageDetailModel *model = self.viewModel.messageDetailListArray[indexPath.row];
        if(model.type == 1) {
            //直播的通知
            BOOL isFree = NO;
            if(model.contentid.integerValue == -1) {
                isFree = YES;
            }else {
                if([APPUserDataIofo AccessToken].length <= 0) {
//                    ShowMessage(@"您还未登录");
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [DCURLRouter pushURLString:@"route://loginVC" animated:YES];
                    });
                    return;
                }
            }
            //付费的课程需要登陆
            if(model.contentid.integerValue != -1) {
                //未登陆先登陆
                if([APPUserDataIofo AccessToken].length <= 0) {
//                    ShowMessage(@"您还未登录");
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [DCURLRouter pushURLString:@"route://loginVC" animated:YES];
                    });
                    return;
                }
            }
            [cell.loadingView startAnimating];
            [[HJCheckLivePwdTool shareInstance] checkLivePwdWithPwd:@"" courseId:model.contentid success:^(BOOL isSetPwd){
                [cell.loadingView stopLoadingView];
                //没有设置密码
                if(isSetPwd) {
                    [DCURLRouter pushURLString:@"route://schoolDetailLiveVC" query:@{@"liveId" : model.contentid,
                                                                                     @"teacherId" : model.senduserid.length > 0 ? model.senduserid : @""
                                                                                     } animated:YES];
                } else {
                    HJCheckLivePwdAlertView *alertView = [[HJCheckLivePwdAlertView alloc] initWithLiveId:model.contentid  teacherId:model.userid BindBlock:^(NSString * _Nonnull pwd) {
                        [DCURLRouter pushURLString:@"route://schoolDetailLiveVC" query:@{@"liveId" : model.contentid,
                                                                                         @"teacherId" : model.senduserid.length > 0 ? model.senduserid : @""
                                                                                         } animated:YES];
                    }];
                    [alertView show];
                }
                
            } error:^{
                [cell.loadingView stopLoadingView];
                //设置了密码，弹窗提示
                
            }];
        } else if (model.type == 2) {
            //订单的通知
            NSDictionary *para = @{@"orderId" : model.contentid};
            [DCURLRouter pushURLString:@"route://orderDetailVC" query:para animated:YES];
            
        } else if (model.type == 3) {
            //讲师的通知
            if(MaJia) {
                if(model.contentid) {
                    NSDictionary *para = @{@"infoId" : model.contentid
                                           };
                    [DCURLRouter pushURLString:@"route://infoDetailVC" query:para animated:YES];
                }
                return;
            }
            HJInfoCheckPwdAlertView *alertView = [[HJInfoCheckPwdAlertView alloc] initWithTeacherId:model.userid BindBlock:^(BOOL success) {
                if(model.contentid) {
                    NSDictionary *para = @{@"infoId" : model.contentid
                                           };
                    [DCURLRouter pushURLString:@"route://infoDetailVC" query:para animated:YES];
                }
            }];
            [alertView show];
        } else if (model.type == 4) {
            //与我有关
            NSDictionary *para = @{@"stuntId" : model.contentid};
            [DCURLRouter pushURLString:@"route://stuntJudgeDetailVC" query:para animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}

#pragma mark 数据为空的占位视图
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"形状 1567"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"暂时没有新的消息";
    NSDictionary *attribute = @{NSFontAttributeName: MediumFont(font(15)), NSForegroundColorAttributeName: HEXColor(@"#999999")};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

@end

