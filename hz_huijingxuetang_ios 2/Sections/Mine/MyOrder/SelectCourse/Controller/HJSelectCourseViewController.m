//
//  HJSelectCourseViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/11.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSelectCourseViewController.h"
#import "HJSelectCourseCell.h"
#import "HJMyOrderListModel.h"
@interface HJSelectCourseViewController ()

@property (nonatomic,strong) HJMyOrderListModel *model;

@end

@implementation HJSelectCourseViewController

- (void)hj_configSubViews{
    self.title = @"选择课程";
    self.numberOfSections = 1;
    
    self.sectionFooterHeight = 0.001f;
    
    [self.tableView registerClass:[HJSelectCourseCell class] forCellReuseIdentifier:NSStringFromClass([HJSelectCourseCell class])];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)hj_loadData {
    
    self.model = self.params[@"model"];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  kHeight(101.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.courseResponses.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HJSelectCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJSelectCourseCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = HEXColor(@"#EAEAEA");
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.row < self.model.courseResponses.count) {
        cell.model = self.model.courseResponses[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row < self.model.courseResponses.count) {
        kRepeatClickTime(1.0);
        NSString *isToStudy = self.params[@"isToStudy"];
        if([isToStudy integerValue] == 1) {
            //跳转到课程详情
            CourseResponsesModel *model = self.model.courseResponses[indexPath.row];
            [DCURLRouter pushURLString:@"route://classDetailVC" query:@{@"courseId" : model.courseid
                                                                        } animated:YES];
        } else {
            //跳转到评价的页面
            CourseResponsesModel *model = self.model.courseResponses[indexPath.row];
            if([model.courseCommentStatus isEqualToString:@"y"]){
                ShowMessage(@"该课程已评价");
                return;
            }
            RACSubject *backSubject = [[RACSubject alloc] init];
            [backSubject subscribeNext:^(id  _Nullable x) {
               //刷新订单的数据
                [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderPaySuccessNoty" object:nil userInfo:nil];
            }];
            [DCURLRouter pushURLString:@"route://postEvaluationVC" query:@{@"subject" : backSubject,
                                                                           @"courseid" : model.courseid
                                                                           } animated:YES];
        }
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
    return [UIImage imageNamed:@"绝技诊股空白页"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"暂时还没有问题哦";
    NSDictionary *attribute = @{NSFontAttributeName: MediumFont(font(15)), NSForegroundColorAttributeName: HEXColor(@"#999999")};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

@end
