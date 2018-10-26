//
//  HJConfirmOrderViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/24.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJConfirmOrderViewController.h"

#import "HJConfirmOrderListCell.h"
#import "HJConfirmOrderTotalMoneyCell.h"

#import "HJPayTypeAlert.h"

@interface HJConfirmOrderViewController ()

@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIView *bottomView;

@end

@implementation HJConfirmOrderViewController

- (void)hj_configSubViews{
    self.title = @"确认订单";
    [self createTopView];
    //创建底部试图
    [self createBottomView];
    
    self.sectionFooterHeight = 0.001f;
    
    [self.tableView registerClass:[HJConfirmOrderListCell class] forCellReuseIdentifier:NSStringFromClass([HJConfirmOrderListCell class])];
    [self.tableView registerClass:[HJConfirmOrderTotalMoneyCell class] forCellReuseIdentifier:NSStringFromClass([HJConfirmOrderTotalMoneyCell class])];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kHeight(45.0), 0, kHeight(49.0), 0));
    }];
}

- (void)createTopView {
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = white_color;
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(kHeight(45.0));
    }];
    
    
    UILabel *countLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"购买账户：明天会更好",MediumFont(font(13)),HEXColor(@"#666666"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 1.0;
        [label sizeToFit];
    }];
    [self.topView addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView);
        make.left.equalTo(self.topView).offset(kWidth(10.0));
        make.height.mas_equalTo(kHeight(13.0));
    }];
}

- (void)createBottomView {
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = white_color;
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(kHeight(49.0));
    }];
    
    
    UILabel *countLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"实付金额：￥1299",MediumFont(font(14)),HEXColor(@"#666666"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 1.0;
        [label sizeToFit];
    }];
    [self.bottomView addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView);
        make.left.equalTo(self.bottomView).offset(kWidth(10.0));
        make.height.mas_equalTo(kHeight(14.0));
    }];
    
    UIButton *buyButton = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"提交订单",MediumFont(font(15)),white_color,0);
        button.backgroundColor = HEXColor(@"#FF4400");
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            HJPayTypeAlert *alert = [[HJPayTypeAlert alloc] initWithBlock:^(PayType payType) {
                
            }];
            [alert show];
        }];
    }];
    [self.bottomView addSubview:buyButton];
    [buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.top.equalTo(self.bottomView);
        make.width.mas_equalTo(kWidth(119));
    }];
}

- (void)hj_loadData {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0) {
        return  kHeight(120.0);
    }
    return  kHeight(40.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 3.0;
    }
    return 2;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0) {
        HJConfirmOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJConfirmOrderListCell class]) forIndexPath:indexPath];
        self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    HJConfirmOrderTotalMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJConfirmOrderTotalMoneyCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = clear_color;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kHeight(10.0);
}



@end
