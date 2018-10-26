//
//  HJBaseClassDetailViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/25.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJBaseClassDetailViewController.h"
#import "HJBaseClassDetailTeacherInfoCell.h"
#import "HJBaseClassDetailCourceInfoCell.h"
#import "HJBaseClassDetailGroupCell.h"
#import "HJClassDetailBottomView.h"

#define BottomViewHeight kHeight(49)
@interface HJBaseClassDetailViewController ()

@property (nonatomic,strong) HJClassDetailBottomView *bottomView;

@end

@implementation HJBaseClassDetailViewController

- (void)viewDidLoad {
    self.tableViewStyle = UITableViewStyleGrouped;
    [super viewDidLoad];
    
}

- (void)hj_configSubViews{
    //    self.tableView.scrollEnabled = NO;
    
    self.bottomView = [[HJClassDetailBottomView alloc] init];
    [self.view addSubview:self.bottomView];
    @weakify(self);
    [self.bottomView.backSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if([x integerValue] == 0) {
            //加入购物车
        } else {
            //立即购买
        }
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(kHeight(49.0));
    }];
    
    [self.tableView registerClassCell:[HJBaseClassDetailTeacherInfoCell class]];
    [self.tableView registerClassCell:[HJBaseClassDetailCourceInfoCell class]];
    [self.tableView registerClassCell:[HJBaseClassDetailGroupCell class]];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, BottomViewHeight, 0));
    }];
}

- (void)hj_loadData {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0) {
        return  kHeight(148.0);
    } else if (indexPath.section == 1) {
        return  kHeight(127.0);
    }
    return  kHeight(109.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0) {
        HJBaseClassDetailTeacherInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJBaseClassDetailTeacherInfoCell class]) forIndexPath:indexPath];
        self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    if(indexPath.section == 1) {
        HJBaseClassDetailCourceInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJBaseClassDetailCourceInfoCell class]) forIndexPath:indexPath];
        self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    HJBaseClassDetailGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJBaseClassDetailGroupCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}

@end
