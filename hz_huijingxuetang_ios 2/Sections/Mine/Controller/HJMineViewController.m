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
#import "HJMessageViewModel.h"
@interface HJMineViewController ()

@property (nonatomic,strong) HJMineViewModel *viewModel;
@property (nonatomic,strong) HJMineHeaderView *headerView;

@end

@implementation HJMineViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CGFLOAT_MIN * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    });
    if([APPUserDataIofo AccessToken].length > 0){
        [self.viewModel getUserInfoWithSuccess:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.headerView.iconImageV sd_setImageWithURL:URL([APPUserDataIofo UserIcon]) placeholderImage:V_IMAGE(@"默认头像") options:SDWebImageRefreshCached];
                self.headerView.nameLable.text = [APPUserDataIofo nikename].length > 0 ? [APPUserDataIofo nikename] : @"未设置";
                if(!MaJia){
                   self.headerView.vipLevelImageV.hidden = [[APPUserDataIofo Partner] isEqualToString:@"1"] ? NO : YES;
                }
                [self.tableView reloadData];
            });
        }];
    }
    
    if(!MaJia){
        HJMessageViewModel *viewModel = [[HJMessageViewModel alloc] init];
        [viewModel getMessageWithSuccess:^{
            if(viewModel.hasmess) {
                [self.tabBarController.tabBar showBadgeValueAtIndex:4 value:@""];
            } else {
                [self.tabBarController.tabBar hideBadgeValueAtIndex:4];
            }
            self.headerView.unReadMessageCount = viewModel.countmess;
        }];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UpdateUserInfoNotification object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.headerView.iconImageV sd_setImageWithURL:URL([APPUserDataIofo UserIcon]) placeholderImage:V_IMAGE(@"默认头像") options:SDWebImageRefreshCached];
        self.headerView.nameLable.text = [APPUserDataIofo nikename].length > 0 ? [APPUserDataIofo nikename] : @"未设置";
        if(!MaJia){
            self.headerView.vipLevelImageV.hidden = [[APPUserDataIofo Partner] isEqualToString:@"1"] ? NO : YES;
        }
    }];
}

- (HJMineViewModel *)viewModel {
    if(!_viewModel){
        _viewModel = [[HJMineViewModel alloc] init];
    }
    return _viewModel;
}

- (HJMineHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[HJMineHeaderView alloc] init];
    }
    return _headerView;
}

- (void)hj_setNavagation {
    self.navigationItem.title = @"";
}

- (void)hj_configSubViews{
    [self.view addSubview:self.headerView];
    
    
    self.sectionFooterHeight = 0.001f;
    
    [self.tableView registerClassCell:[HJMineListCell class]];
    
    if(MaJia) {
        [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
            make.height.mas_equalTo(kHeight(166));
        }];
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kHeight(166), 0, 0, 0));
        }];
    } else {
        [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
            make.height.mas_equalTo(kHeight(266));
        }];
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kHeight(266), 0, 0, 0));
        }];
    }
}

- (void)hj_loadData {
    //登陆成功获取用户信息的接口
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:LoginGetUserInfoNotification object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel getUserInfoWithSuccess:^{
            [self.headerView.iconImageV sd_setImageWithURL:URL([APPUserDataIofo UserIcon]) placeholderImage:V_IMAGE(@"默认头像") options:SDWebImageRefreshCached];
            self.headerView.nameLable.text = [APPUserDataIofo nikename].length > 0 ? [APPUserDataIofo nikename] : @"未设置";
            if(!MaJia){
                self.headerView.vipLevelImageV.hidden = [[APPUserDataIofo Partner] isEqualToString:@"1"] ? NO : YES;
            }
        }];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  kHeight(45.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(MaJia) {
       return 2;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(MaJia) {
        if(section == 0) {
            return 2;
        }
        return 1;
    }else {
        if(section == 0) {
            return 2;
        }
        if(section == 1) {
            return 2;
        }
        return 2;
    }
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HJMineListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJMineListCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setViewModel:self.viewModel indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    kRepeatClickTime(1.0);
    if (MaJia) {
        if(indexPath.section == 0){
            if(indexPath.row == 0){
                //我的关注
                if([APPUserDataIofo AccessToken].length <= 0) {
//                    ShowMessage(@"您还未登录");
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [DCURLRouter pushURLString:@"route://loginVC" animated:YES];
                    });
                    return;
                }
                [DCURLRouter pushURLString:@"route://myCareVC" animated:YES];
            }else {
                //历史观看
                [DCURLRouter pushURLString:@"route://watchHistoryVC" animated:YES];
            }
        }
        //问题反馈
        if(indexPath.section == 1) {
            [DCURLRouter pushURLString:@"route://mySuggestionVC" animated:YES];
        }
    } else {
        if(indexPath.section == 0){
            if(indexPath.row == 0){
                //我的关注
                if([APPUserDataIofo AccessToken].length <= 0) {
//                    ShowMessage(@"您还未登录");
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [DCURLRouter pushURLString:@"route://loginVC" animated:YES];
                    });
                    return;
                }
                [DCURLRouter pushURLString:@"route://myCareVC" animated:YES];
            }else {
                //历史观看
                [DCURLRouter pushURLString:@"route://watchHistoryVC" animated:YES];
            }
        }
        
        if(indexPath.section == 1) {
            if(indexPath.row == 0){
                //我的订单
//                NSDictionary *para = @{@"isJumpTopKillPriceOrder" : @(NO)};
                [DCURLRouter pushURLString:@"route://myOrderVC" animated:YES];
            }else {
                //我的卡券
                [DCURLRouter pushURLString:@"route://myCardVoucherVC" animated:YES];
            }
        }
        
        //问题反馈
        if(indexPath.section == 2) {
            if([APPUserDataIofo Eval].integerValue == 0) {
                if(indexPath.row == 0) {
                    //问题反馈
                    [DCURLRouter pushURLString:@"route://mySuggestionVC" animated:YES];
                } else {
                    //风险评估
                    [DCURLRouter pushURLString:@"route://riskEvaluationVC" animated:YES];
                }
            } else {
                //没有做过风险评估
                if(indexPath.row == 0) {
                    //问题反馈
                    [DCURLRouter pushURLString:@"route://mySuggestionVC" animated:YES];
                } else {
                    //风险评估
//                    HJMineListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//                    [cell setHidden:NO];
//                    [self setH];
//                    [DCURLRouter pushURLString:@"route://riskEvaluationVC" animated:YES];
                }
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}

@end
