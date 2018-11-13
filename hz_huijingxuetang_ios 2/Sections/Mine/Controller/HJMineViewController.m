//
//  HJMineViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/7.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJMineViewController.h"
#import "HJMineHeaderView.h"
#import "HJMineListCell.h"
#import "HJMineViewModel.h"
@interface HJMineViewController ()

@property (nonatomic,strong) HJMineViewModel *viewModel;

@end

@implementation HJMineViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CGFLOAT_MIN * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
}

- (HJMineViewModel *)viewModel {
    if(!_viewModel){
        _viewModel = [[HJMineViewModel alloc] init];
    }
    return _viewModel;
}

- (void)hj_setNavagation {
    self.navigationItem.title = @"";
  
    
    
}

- (void)hj_configSubViews{
    HJMineHeaderView *headerView = [[HJMineHeaderView alloc] init];
    [self.view addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(kHeight(266));
    }];
    
    self.sectionFooterHeight = 0.001f;
    
    [self.tableView registerClassCell:[HJMineListCell class]];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kHeight(266), 0, 0, 0));
    }];
}

- (void)hj_loadData {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  kHeight(45.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0) {
        return 2;
    }
    if(section == 1) {
        return 2;
    }
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HJMineListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJMineListCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setViewModel:self.viewModel indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            //我的关注
            [DCURLRouter pushURLString:@"route://myCareVC" animated:YES];
        }else {
            //历史观看
            [DCURLRouter pushURLString:@"route://watchHistoryVC" animated:YES];
        }
    }
    
    if(indexPath.section == 1) {
        if(indexPath.row == 0){
            //我的订单
//            [DCURLRouter pushURLString:@"route://myCareVC" animated:YES];
        }else {
            //我的卡券
            [DCURLRouter pushURLString:@"route://myCardVoucherVC" animated:YES];
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}

@end
