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
#import "HJShopCarViewModel.h"
#import "HJShopCarListModel.h"

#define MaxCourseCount 9
@interface HJShopCarViewController ()

@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) HJShopCarViewModel *viewModel;

@property (nonatomic,strong) UIButton *allSelectButton;
@property (nonatomic,strong) UILabel *selctCountLabel;

@end

@implementation HJShopCarViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
    self.fd_interactivePopDisabled = YES;
    [self loadData];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    self.fd_interactivePopDisabled = NO;
}


- (HJShopCarViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[HJShopCarViewModel alloc] init];
    }
    return _viewModel;
}

- (void)hj_configSubViews{
    self.title = @"购物车";
    //创建底部试图
    [self createBottomView];
    
    self.sectionFooterHeight = 0.001f;
    
    [self.tableView registerClass:[HJShopCarListCell class] forCellReuseIdentifier:NSStringFromClass([HJShopCarListCell class])];
    [self.tableView registerClass:[HJShopCarTotalMoneyCell class] forCellReuseIdentifier:NSStringFromClass([HJShopCarTotalMoneyCell class])];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, kHeight(49.0) + KHomeIndicatorHeight, 0));
    }];
}

- (void)createBottomView {
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = white_color;
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-KHomeIndicatorHeight);
        make.height.mas_equalTo(kHeight(49.0));
    }];
    
    self.bottomView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1].CGColor;
    self.bottomView.layer.shadowOffset = CGSizeMake(0,1);
    self.bottomView.layer.shadowOpacity = 1;
    self.bottomView.layer.shadowRadius = 5;
    
    //已选的按钮
    UIButton *allSelectButton = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@" 已选（0） ",MediumFont(font(14)),HEXColor(@"#22476B"),0);
        [button setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"勾选"] forState:UIControlStateSelected];
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            button.selected = !button.selected;
            [self allSelectOrDeselect:button.selected];
        }];
    }];
    
    [self.bottomView addSubview:allSelectButton];
    self.allSelectButton = allSelectButton;
    [allSelectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView);
        make.left.equalTo(self.bottomView).offset(kWidth(10.0));
        make.height.mas_equalTo(kHeight(15.0));
        make.width.mas_equalTo(kWidth(100.0));
    }];
    
    //立即购买的按钮
    UIButton *buyButton = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"立即购买",MediumFont(font(15)),white_color,0);
        button.backgroundColor = HEXColor(@"#FF4400");
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self buyOperation];
        }];
    }];
    [self.bottomView addSubview:buyButton];
    [buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.top.equalTo(self.bottomView);
        make.width.mas_equalTo(kWidth(119));
    }];
    
    //适配iPhone X
    if(isFringeScreen) {
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = white_color;
        [self.view addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.mas_equalTo(KHomeIndicatorHeight);
        }];
    }
}

//立即购买的操作
- (void)buyOperation {
    if (self.viewModel.totalMoney <= 0) {
        ShowMessage(@"请选择购买课程");
        return;
    }
    NSMutableArray * marr = [NSMutableArray array];
    for (HJShopCarListModel *model in self.viewModel.shopCarListArray) {
        if (model.isSelect) {
            [marr addObject:model.courseid];
        }
    }
    NSString *cids = [marr componentsJoinedByString:@","];
    //创建购物车订单
    ShowHint(@"");
    [YJAPPNetwork WillPayWithAccesstoken:[APPUserDataIofo AccessToken] cids:DealNil(cids) picData:nil  success:^(NSDictionary *responseObject) {
        hideHud();
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            NSString *orderid = [responseObject objectForKey:@"data"];
            //确认订单页面
            NSDictionary *para = @{@"orderId" : orderid};
            [DCURLRouter pushURLString:@"route://confirmOrderVC" query:para animated:YES];
        } else {
            ShowMessage([responseObject valueForKey:@"msg"]);
        }
    } failure:^(NSString *error) {
        hideHud();
        ShowMessage(error);
    }];

//    if([APPUserDataIofo Eval].integerValue == 0) {
//        NSDictionary *para = @{@"index" : @(0), @"selectMarr" :@[],
//                               @"isKillPrice" : @(0),
//                               @"courseId" : cids
//                               };
//        [DCURLRouter pushURLString:@"route://riskEvaluationVC" query:para animated:YES];
//    }else {
//        NSDictionary *para = @{@"courseId" : cids,
//                               @"isKillPrice" : @(0)};
//        [DCURLRouter pushURLString:@"route://buyCourseProtocolVC" query:para animated:YES];
//    }
}

- (void)loadData {
    self.viewModel.page = 1;
    self.viewModel.tableView = self.tableView;
    self.tableView.mj_footer.hidden = YES;
    [self.viewModel getShopCarListDataWithSuccess:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self.viewModel.shopCarListArray.count <= 0) {
                self.bottomView.hidden = YES;
            } else {
                self.bottomView.hidden = NO;
            }
            [self.tableView reloadData];
        });
    }];
}

- (void)hj_refreshData {
    @weakify(self);
    self.tableView.mj_header = [MKRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.viewModel.page = 1;
        [self loadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
        });
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.viewModel.page++;
        if(self.viewModel.currentpage < self.viewModel.totalpage){
            [self.viewModel getShopCarListDataWithSuccess:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [self.tableView.mj_footer endRefreshing];
                });
            }];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.tableView reloadData];
        }
    }];
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
        return self.viewModel.shopCarListArray.count;
    }
    if(self.viewModel.shopCarListArray.count > 0) {
        return 1;
    }
    return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0) {
        HJShopCarListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJShopCarListCell class]) forIndexPath:indexPath];
        self.tableView.separatorColor = HEXColor(@"#EAEAEA");
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row < self.viewModel.shopCarListArray.count) {
            [cell setViewModel:self.viewModel indexPath:indexPath];
        }
        return cell;
    }
    HJShopCarTotalMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJShopCarTotalMoneyCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = HEXColor(@"#EAEAEA");
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(self.viewModel.shopCarListArray.count > 0) {
        cell.hidden = NO;
        cell.desLabel.text = @"合计：";
        NSString *price = [NSString stringWithFormat:@"￥%.2f",self.viewModel.totalMoney];
        cell.priceLabel.attributedText = [price attributeWithStr:@"￥" color:HEXColor(@"#FF4400") font:MediumFont(font(13))];
    } else {
        cell.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.viewModel.shopCarListArray.count) {
        kRepeatClickTime(1.0);
        HJShopCarListModel *model = self.viewModel.shopCarListArray[indexPath.row];
        model.isSelect = !model.isSelect;
        [self dealSelectData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
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
            if (indexPath.row < self.viewModel.shopCarListArray.count) {
                HJShopCarListModel *model = self.viewModel.shopCarListArray[indexPath.row];
                [self.viewModel deleteShopListWithCourseid:model.courseid Success:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (indexPath.row < self.viewModel.shopCarListArray.count) {
                            [self.viewModel.shopCarListArray removeObjectAtIndex:indexPath.row];
                            [self dealSelectData];
                        }
                    });
                }];
            }
        }
    }
}

// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

//处理选中的数据
- (void)dealSelectData {
    CGFloat totalMoney = 0.00;
    NSMutableArray *marr = [NSMutableArray array];
    for (HJShopCarListModel *model in self.viewModel.shopCarListArray) {
        if (model.isSelect) {
            if(marr.count < MaxCourseCount) {
                [marr addObject:model];
                if(model.hassecond == 1) {
                    totalMoney += model.secondprice.floatValue;
                } else {
                    totalMoney += model.coursemoney.floatValue;
                }
            } else {
                model.isSelect = NO;
                ShowMessage([NSString stringWithFormat:@"一次最多只能购买%d门课程",MaxCourseCount]);
                break;
            }
        }
    }
    [self.allSelectButton setTitle:[NSString stringWithFormat:@" 已选（%ld）",marr.count] forState:UIControlStateNormal];
    if (marr.count == self.viewModel.shopCarListArray.count) {
        self.allSelectButton.selected = YES;
    } else {
        self.allSelectButton.selected = NO;
    }
    self.viewModel.totalMoney = totalMoney;
    [self.tableView reloadData];
}

//全部选中 或者全部反选的操作
- (void)allSelectOrDeselect:(BOOL)isSelect {
    CGFloat totalMoney = 0.00;
    NSMutableArray *marr = self.viewModel.shopCarListArray;
    if(isSelect && marr.count > MaxCourseCount) {
        //全选时候的操作
        ShowMessage([NSString stringWithFormat:@"一次最多只能购买%d门课程",MaxCourseCount]);
        marr = (NSMutableArray *)[self.viewModel.shopCarListArray subarrayWithRange:NSMakeRange(0, 2)];
    }
    for (HJShopCarListModel *model in marr) {
        model.isSelect = isSelect;
        if (model.isSelect) {
//            totalMoney += model.coursemoney.floatValue;
            if(model.hassecond == 1) {
                totalMoney += model.secondprice.floatValue;
            } else {
                totalMoney += model.coursemoney.floatValue;
            }
        }
    }
    if (isSelect) {
//        self.selctCountLabel.text = [NSString stringWithFormat:@"已选（%ld）",marr.count];
        
        [self.allSelectButton setTitle:[NSString stringWithFormat:@" 已选（%ld）",marr.count] forState:UIControlStateNormal];
    } else {
//        self.selctCountLabel.text = @"已选（0）";
        [self.allSelectButton setTitle:@" 已选（0）" forState:UIControlStateNormal];
    }
    self.viewModel.totalMoney = totalMoney;
    [self.tableView reloadData];
    
   
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"";
    if([UserInfoSingleObject shareInstance].networkStatus == NotReachable) {
        text = @"网络好像出了点问题";
    } else{
        text = @"购物车空空如也";
    }
    NSDictionary *attribute = @{NSFontAttributeName: MediumFont(font(15)), NSForegroundColorAttributeName: HEXColor(@"#999999")};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if([UserInfoSingleObject shareInstance].networkStatus == NotReachable) {
        return [UIImage imageNamed:@"网络问题空白页"];
    } else {
        return [UIImage imageNamed:@"购物车空白页"];
    }
}


- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    if([UserInfoSingleObject shareInstance].networkStatus == NotReachable) {
        return  [UIImage imageNamed:@"点击刷新"];
    } else {
        return  [UIImage imageNamed:@"添加课程按钮"];
    }
}

#pragma mark - 空白数据集 按钮被点击时 触发该方法：
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    if([UserInfoSingleObject shareInstance].networkStatus == NotReachable) {
        [self hj_loadData];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"JumpToSchoolVCourse" object:nil userInfo:nil];
        [self.tabBarController setSelectedIndex:1];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


@end
