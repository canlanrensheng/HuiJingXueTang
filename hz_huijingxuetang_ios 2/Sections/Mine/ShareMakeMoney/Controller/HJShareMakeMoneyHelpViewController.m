//
//  HJShareMakeMoneyHelpViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/28.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJShareMakeMoneyHelpViewController.h"
#import "HJShareMakeMoneyHelpCell.h"
@interface HJShareMakeMoneyHelpViewController ()

@end

@implementation HJShareMakeMoneyHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)hj_setNavagation {
    self.title = @"帮助";
}

- (void)hj_configSubViews{
    self.numberOfSections = 1;
    self.sectionFooterHeight = 0.001f;
    [self.tableView registerClassCell:[HJShareMakeMoneyHelpCell class]];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)hj_loadData {
    
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  kHeight(100.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HJShareMakeMoneyHelpCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJShareMakeMoneyHelpCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = HEXColor(@"#EAEAEA");
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.helpImageView.image = V_IMAGE(@"");
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}


@end
