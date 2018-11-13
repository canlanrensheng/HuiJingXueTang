//
//  HJMessageDetailViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/8.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJMessageDetailViewController.h"
#import "HJMessageDetailCell.h"

@interface HJMessageDetailViewController ()

@end

@implementation HJMessageDetailViewController

- (void)hj_setNavagation {
    self.title = @"消息通知";
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
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  kHeight(111.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HJMessageDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJMessageDetailCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = clear_color;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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

