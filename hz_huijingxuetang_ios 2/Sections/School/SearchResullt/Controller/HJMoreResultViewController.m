//
//  HJMoreResultViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/26.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJMoreResultViewController.h"
#import "HJSearchResultCourceCell.h"
#import "HJSearchResultTeacherCell.h"
#import "HJSearchResultLiveCell.h"
#import "HJSearchResultInfomationCell.h"
@interface HJMoreResultViewController ()

@property (nonatomic,copy) NSString *passTitle;

@end

@implementation HJMoreResultViewController

- (void)hj_setNavagation {
    NSDictionary *para= self.params;
    self.navigationItem.title = self.passTitle = para[@"title"];
}

- (void)hj_configSubViews{
    //    self.tableView.scrollEnabled = NO;
    self.numberOfSections = 1;
    
    self.sectionFooterHeight = 0.001f;
    
    [self.tableView registerClassCell:[HJSearchResultCourceCell class]];
    [self.tableView registerClassCell:[HJSearchResultTeacherCell class]];
    [self.tableView registerClassCell:[HJSearchResultLiveCell class]];
    [self.tableView registerClassCell:[HJSearchResultInfomationCell class]];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)hj_loadData {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.passTitle isEqualToString:@"课程"]) {
        return kHeight(111.0);
    } else if ([self.passTitle isEqualToString:@"老师"]) {
        return kHeight(90.0);
    } else if ([self.passTitle isEqualToString:@"直播"]) {
        return kHeight(110.0);
    } else {
        return kHeight(125.0);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.passTitle isEqualToString:@"课程"]) {
        HJSearchResultCourceCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJSearchResultCourceCell class]) forIndexPath:indexPath];
        self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
        return cell;
    } else if ([self.passTitle isEqualToString:@"老师"]) {
        HJSearchResultTeacherCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJSearchResultTeacherCell class]) forIndexPath:indexPath];
        self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
        return cell;
    } else if ([self.passTitle isEqualToString:@"直播"]) {
        HJSearchResultLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJSearchResultLiveCell class]) forIndexPath:indexPath];
        self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
        return cell;
    } else {
        HJSearchResultInfomationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJSearchResultInfomationCell class]) forIndexPath:indexPath];
        self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}


@end
