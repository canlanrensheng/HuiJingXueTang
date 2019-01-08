//
//  HJProfitViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/23.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJProfitViewController.h"
#import "HJProfitHeaderView.h"
#import "HJGoodCourseShareCell.h"
#import "HJShareViewModel.h"
@interface HJProfitViewController ()

@property (nonatomic,strong) HJShareViewModel *viewModel;
@property (nonatomic,strong) HJProfitHeaderView *headerView;

@end

@implementation HJProfitViewController

- (HJShareViewModel *)viewModel {
    if(!_viewModel){
        _viewModel = [[HJShareViewModel alloc] init];
    }
    return _viewModel;
}

- (void)hj_configSubViews{
    self.tableView.backgroundColor = Background_Color;
    
    self.numberOfSections = 1;
    
    self.sectionFooterHeight = 0.001f;
    
    [self.tableView registerClass:[HJGoodCourseShareCell class] forCellReuseIdentifier:NSStringFromClass([HJGoodCourseShareCell class])];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kHeight(220), 0, 0, 0));
    }];
    
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(kHeight(150));
    }];
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = RGBA(0, 0, 0, 0.1);
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(kHeight(28));
    }];
    [self.view addSubview:topView];
    //社区人数统计与规则
    UILabel *ruleTextLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"每月月初统一打款至绑定账户（除保证金外）",MediumFont(font(11)),white_color);
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
    }];
    [topView addSubview:ruleTextLabel];
    [ruleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.left.equalTo(topView).offset(kWidth(10.0));
    }];
    
    //问号按钮
    UIButton *questionBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"",H15,white_color,0);
        [button setBackgroundImage:V_IMAGE(@"问号") forState:UIControlStateNormal];
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            
        }];
    }];
    [topView addSubview:questionBtn];
    [questionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.left.equalTo(ruleTextLabel.mas_right).offset(kWidth(10.0));
    }];
}

- (HJProfitHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[HJProfitHeaderView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, kHeight(220))];
    }
    return _headerView;
}

- (void)hj_loadData {
    //获取推广收益
    [self.viewModel getPromoteProfitMessageSuccess:^{
        self.headerView.model = self.viewModel.profitModel;
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  kHeight(45.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0) {
        return 1;
    }
    if (section == 1) {
        return 2;
    }
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = HEXColor(@"#333333");
    cell.textLabel.font = MediumFont(font(15));
    cell.detailTextLabel.textColor = HEXColor(@"#999999");
    cell.detailTextLabel.font = MediumFont(font(11));
    if (indexPath.section == 0) {
        cell.textLabel.text = @"账户管理";
        cell.detailTextLabel.text = @"绑定或管理提现账户";
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"提现记录";
            cell.detailTextLabel.text = @"";
        } else {
            cell.textLabel.text = @"佣金明细";
            cell.detailTextLabel.text = @"";
        }
    }
    if (indexPath.section == 2) {
        cell.textLabel.text = @"我的推广社区";
        cell.detailTextLabel.text = @"查看团体人数与订单";
    }
    self.tableView.separatorColor = HEXColor(@"#EAEAEA");
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    kRepeatClickTime(1.0);
    if(indexPath.section == 0) {
        //账户管理
        [DCURLRouter pushURLString:@"route://accountManagerVC" animated:YES];
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //提现记录
            [DCURLRouter pushURLString:@"route://withDrawRecordVC" animated:YES];
        } else {
            //佣金明细
            [DCURLRouter pushURLString:@"route://brokerageListVC" animated:YES];
        }
    }
    
    if (indexPath.section == 2) {
        //我的推广社区
        [DCURLRouter pushURLString:@"route://shareCommunityVC" animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0) {
        return 0.0001f;
    }
    return kHeight(10.0);
}

#pragma mark 数据为空的占位视图

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"绝技诊股空白页"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"暂时还没有问题哦";
    NSDictionary *attribute = @{NSFontAttributeName: MediumFont(font(15)), NSForegroundColorAttributeName: HEXColor(@"#999999")};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

@end

