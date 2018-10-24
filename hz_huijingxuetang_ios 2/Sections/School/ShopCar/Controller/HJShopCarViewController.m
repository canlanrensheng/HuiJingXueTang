//
//  HJShopCarViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/24.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJShopCarViewController.h"
#import "HJShopCarListCell.h"
#import "HJShopCarTotalMoneyCell.h"


@interface HJShopCarViewController ()

@property (nonatomic,strong) UIView *bottomView;

@end

@implementation HJShopCarViewController

- (void)hj_configSubViews{
    self.title = @"购物车";
    //创建底部试图
    [self createBottomView];
    
    self.sectionFooterHeight = 0.001f;
    
    [self.tableView registerClass:[HJShopCarListCell class] forCellReuseIdentifier:NSStringFromClass([HJShopCarListCell class])];
    [self.tableView registerClass:[HJShopCarTotalMoneyCell class] forCellReuseIdentifier:NSStringFromClass([HJShopCarTotalMoneyCell class])];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, kHeight(49.0), 0));
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
    
    UIButton *allSelectButton = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"选择",H15,clear_color,0);
        [button setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"勾选"] forState:UIControlStateSelected];
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            
        }];
    }];
    [self.bottomView addSubview:allSelectButton];
    [allSelectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView);
        make.left.equalTo(self.bottomView).offset(kWidth(10.0));
        make.width.height.mas_equalTo(kHeight(15.0));
    }];
    
    UILabel *countLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"已选（2）",MediumFont(font(14)),HEXColor(@"#1D3043"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 1.0;
        [label sizeToFit];
    }];
    [self.bottomView addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView);
        make.left.equalTo(allSelectButton.mas_right).offset(kWidth(6.0));
        make.height.mas_equalTo(kHeight(14.0));
    }];
    
    UIButton *buyButton = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"立即购买",MediumFont(font(15)),white_color,0);
        button.backgroundColor = HEXColor(@"#FF4400");
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [DCURLRouter pushURLString:@"route://confirmOrderVC" animated:YES];
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
        HJShopCarListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJShopCarListCell class]) forIndexPath:indexPath];
        self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    HJShopCarTotalMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJShopCarTotalMoneyCell class]) forIndexPath:indexPath];
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


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return YES;
    }
    return NO;
}

// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if(indexPath.section == 0) {
            
        }
    }
}

// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

@end
