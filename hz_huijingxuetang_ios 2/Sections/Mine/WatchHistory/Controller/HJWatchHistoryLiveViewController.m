//
//  HJWatchHistoryLiveViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/9.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJWatchHistoryLiveViewController.h"
#import "HJLiveDetailModel.h"
#import "HJWatchHistoryLiveCell.h"
@interface HJWatchHistoryLiveViewController ()

@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation HJWatchHistoryLiveViewController

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)hj_configSubViews{
    //    self.tableView.scrollEnabled = NO;
    self.numberOfSections = 1;
    
    self.sectionFooterHeight = 0.001f;
    
    [self.tableView registerClass:[HJWatchHistoryLiveCell class] forCellReuseIdentifier:NSStringFromClass([HJWatchHistoryLiveCell class])];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)hj_loadData {
    NSMutableArray *modelArr = [[TXDataManage shareManage] unarchiveObjectWithFileName:[NSString stringWithFormat:@"WatchedHistoryLive%@",[APPUserDataIofo UserID]]];
    [self.dataArr addObjectsFromArray:modelArr];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  kHeight(91.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HJWatchHistoryLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJWatchHistoryLiveCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = HEXColor(@"#EAEAEA");
    if (indexPath.row < self.dataArr.count) {
        HJLiveDetailModel *model = self.dataArr[indexPath.row];
        cell.model = model;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.dataArr.count) {
        kRepeatClickTime(1.0);
        HJLiveDetailModel *detailModel = self.dataArr[indexPath.row];
        Course *model = detailModel.course;
        NSString *liveId = @"";
        if (model.courseid.length > 0) {
            //正在直播
            liveId = model.courseid;
        } else {
            //暂无直播
            ShowMessage(@"暂无直播");
            return;
        }
        if(model.courseid.integerValue != -1) {
            //未登陆先登陆
            if([APPUserDataIofo AccessToken].length <= 0) {
//                ShowMessage(@"您还未登录");
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [DCURLRouter pushURLString:@"route://loginVC" animated:YES];
                });
                return;
            }
        }
        //校验密码
        [[HJCheckLivePwdTool shareInstance] checkLivePwdWithPwd:@"" courseId:liveId success:^(BOOL isSetPwd){
            //没有设置密码
            if(isSetPwd) {
                [DCURLRouter pushURLString:@"route://schoolDetailLiveVC" query:@{@"liveId" : liveId,
                                                                                 @"teacherId" : model.userid.length > 0 ? model.userid : @""
                                                                                 } animated:YES];
            } else {
                //设置了密码，弹窗提示
                HJCheckLivePwdAlertView *alertView = [[HJCheckLivePwdAlertView alloc] initWithLiveId:liveId  teacherId:model.userid BindBlock:^(NSString * _Nonnull pwd) {
                    [DCURLRouter pushURLString:@"route://schoolDetailLiveVC" query:@{@"liveId" : liveId,
                                                                                     @"teacherId" : model.userid.length > 0 ? model.userid : @""
                                                                                     } animated:YES];
                }];
                [alertView show];
            }
            
        } error:^{
            
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}

#pragma mark 数据为空的占位视图
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return - kHeight(40);
}

// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除进行的操作
        if (indexPath.row < self.dataArr.count) {
            NSMutableArray *modelArr = [[TXDataManage shareManage] unarchiveObjectWithFileName:[NSString stringWithFormat:@"WatchedHistoryLive%@",[APPUserDataIofo UserID]]];
            [self.dataArr removeObjectAtIndex:indexPath.row];
            NSMutableArray *marr = [NSMutableArray arrayWithArray:modelArr];
            [marr removeObjectAtIndex:indexPath.row];
            [[TXDataManage shareManage] archiveObject:marr withFileName:[NSString stringWithFormat:@"WatchedHistoryLive%@",[APPUserDataIofo UserID]]];
            [self.tableView reloadData];
        }
    }
}

// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}


-(NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
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
