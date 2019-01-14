//
//  HJWatchHistoryVideoViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/9.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJWatchHistoryVideoViewController.h"
#import "HJCourseSelectJiModel.h"
#import "HJWatchHistoryVideoCell.h"
#import <ZFUtilities.h>

@interface HJWatchHistoryVideoViewController ()

@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation HJWatchHistoryVideoViewController

- (NSMutableArray *)dataArr {
    if(!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)hj_configSubViews{
    self.numberOfSections = 1;
    
    self.sectionFooterHeight = 0.001f;
    
    [self.tableView registerClass:[HJWatchHistoryVideoCell class] forCellReuseIdentifier:NSStringFromClass([HJWatchHistoryVideoCell class])];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)hj_loadData {
    NSMutableArray *modelArr = [[TXDataManage shareManage] unarchiveObjectWithFileName:[NSString stringWithFormat:@"WatchedVideo%@",[APPUserDataIofo UserID]]];
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
    HJWatchHistoryVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJWatchHistoryVideoCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = HEXColor(@"#EAEAEA");
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row < self.dataArr.count) {
        HJCourseSelectJiModel *model = self.dataArr[indexPath.row];
        [cell.imaV sd_setImageWithURL:URL(model.videoppicurl) placeholderImage:V_IMAGE(@"占位图") options:SDWebImageRefreshCached];
        cell.nameLabel.text = model.videoname;
        
        NSString *totalTime = [ZFUtilities convertTimeSecond:model.totalTime];
        cell.totalTimeLabel.text = [NSString stringWithFormat:@"%@",totalTime];
        cell.teacherNameLabel.text = [NSString stringWithFormat:@"讲师：%@",model.realName];
        //几小时前
        NSDate *endDate = [NSDate date];
        NSDate *startDate = model.date;
        
        DTTimePeriod *timePeriod =[[DTTimePeriod alloc] initWithStartDate:startDate endDate:endDate];
        double durationInHours  = [timePeriod durationInHours];
        cell.timeLabel.text = [NSString stringWithFormat:@"%ld小时前",(long)durationInHours];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.dataArr.count) {
        kRepeatClickTime(1.0);
        HJCourseSelectJiModel *model = self.dataArr[indexPath.row];
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


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"我的额课程空白页"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"暂时还没有问题哦";
    NSDictionary *attribute = @{NSFontAttributeName: MediumFont(font(15)), NSForegroundColorAttributeName: HEXColor(@"#999999")};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
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
            NSMutableArray *modelArr = [[TXDataManage shareManage] unarchiveObjectWithFileName:[NSString stringWithFormat:@"WatchedVideo%@",[APPUserDataIofo UserID]]];
            [self.dataArr removeObjectAtIndex:indexPath.row];
            NSMutableArray *marr = [NSMutableArray arrayWithArray:modelArr];
            [marr removeObjectAtIndex:indexPath.row];
            [[TXDataManage shareManage] archiveObject:marr withFileName:[NSString stringWithFormat:@"WatchedVideo%@",[APPUserDataIofo UserID]]];
            [self.tableView reloadData];
        }
    }
}

// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

@end
