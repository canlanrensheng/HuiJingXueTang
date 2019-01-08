//
//  HJBaseSelectJiViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/25.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJBaseSelectJiViewController.h"
#import "HJSelectJiListCell.h"
#import "HJClassDetailBottomView.h"
#import "HJCourseSelectJiModel.h"
#define BottomViewHeight kHeight(49)
@interface HJBaseSelectJiViewController ()

@property (nonatomic,strong) HJClassDetailBottomView *bottomView;
//选中的model
@property (nonatomic,strong) HJCourseSelectJiModel *lastSelectModel;

@end

@implementation HJBaseSelectJiViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    self.tableViewStyle = UITableViewStyleGrouped;
    [super viewDidLoad];
}

- (void)hj_configSubViews{
    self.bottomView = [[HJClassDetailBottomView alloc] init];
    [self.view addSubview:self.bottomView];
    self.bottomView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    self.bottomView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1].CGColor;
    self.bottomView.layer.shadowOffset = CGSizeMake(0,1);
    self.bottomView.layer.shadowOpacity = 1;
    self.bottomView.layer.shadowRadius = 5;
    
    self.bottomView.hidden = YES;
    @weakify(self);
    [self.bottomView.backSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if ([x intValue] == 1) {
            //加入购物车
            __weak typeof(self)weakSelf = self;
            [self.viewModel addShopListOperationWithCourseId:self.viewModel.model.courseid Success:^{
                weakSelf.bottomView.carBtn.select = YES;
                ShowMessage(@"加入购物车成功");
            }];
        } else if ([x intValue] == 2) {
            //邀请好友砍价
            if([APPUserDataIofo Eval].integerValue == 0) {
                NSDictionary *para = @{@"index" : @(0),
                                       @"selectMarr" :@[],
                                       @"courseId" : self.viewModel.courseId.length > 0 ? self.viewModel.courseId : @"",
                                       @"isKillPrice" : @(1),
                                       @"coursepic" : self.viewModel.model.coursepic.length > 0 ? self.viewModel.model.coursepic :@""
                                       };
                [DCURLRouter pushURLString:@"route://riskEvaluationVC" query:para animated:YES];
            }else {
                self.viewModel.courseId = self.viewModel.model.courseid;
                NSDictionary *para = @{@"courseId" : self.viewModel.courseId,
                                       @"isKillPrice" : @(1),
                                       @"coursepic" : self.viewModel.model.coursepic.length > 0 ? self.viewModel.model.coursepic :@""};
                [DCURLRouter pushURLString:@"route://buyCourseProtocolVC" query:para animated:YES];
            }
        } else if ([x intValue] == 3) {
            //立即购买
            if([APPUserDataIofo Eval].integerValue == 0) {
                NSDictionary *para = @{@"index" : @(0),
                                       @"selectMarr" :@[],
                                       @"courseId" : self.viewModel.courseId.length > 0 ? self.viewModel.courseId : @"",
                                       @"isKillPrice" : @(0)
                                       };
                [DCURLRouter pushURLString:@"route://riskEvaluationVC" query:para animated:YES];
            }else {
                self.viewModel.courseId = self.viewModel.model.courseid;
                NSDictionary *para = @{@"courseId" : self.viewModel.courseId,
                                       @"isKillPrice" : @(0)};
                [DCURLRouter pushURLString:@"route://buyCourseProtocolVC" query:para animated:YES];
            }
        } else if ([x intValue] == 4) {
            //免费领取
            __weak typeof(self)weakSelf = self;
            [self.viewModel createFreeCourseOrderWithCourseId:self.viewModel.model.courseid Success:^(BOOL succcessFlag) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    ShowMessage(@"领取成功");
                    //刷新数据
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.selectJiSubject sendNext:nil];
                    });
                });
            }];
        }
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-KHomeIndicatorHeight);
        make.height.mas_equalTo(kHeight(49.0));
    }];
    
    [self.tableView registerClassCell:[HJSelectJiListCell class]];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, BottomViewHeight, 0));
    }];
    
    if(isFringeScreen) {
        UIView *homeInditorView = [[UIView alloc] init];
        homeInditorView.backgroundColor = white_color;
        [self.view addSubview:homeInditorView];
        [homeInditorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.mas_equalTo(kHeight(KHomeIndicatorHeight));
        }];
    }
}

- (void)setViewModel:(HJClassDetailViewModel *)viewModel {
    _viewModel = viewModel;
    if(MaJia) {
        self.bottomView.hidden = YES;
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];

        
        self.tableView.mj_footer.hidden = YES;
        __weak typeof(self)weakSelf = self;
        [_viewModel getCourceSelectJiWithCourseid:self.viewModel.courseId Success:^{
            if(weakSelf.viewModel.selectJiArray.count > 0){
                HJCourseSelectJiModel *model = weakSelf.viewModel.selectJiArray.firstObject;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SetFirstPlayVideoMessage" object:nil userInfo:@{@"model" : model}];
            }
            [weakSelf.tableView reloadData];
        }];
        return;
    }
    //免费课程
    if (self.viewModel.model.courselimit == 1) {
        //是否已经购买
        if([self.viewModel.model.buy isEqualToString:@"n"]){
            //没有购买 不能点击播放
            self.bottomView.freeGetBtn.hidden = NO;
            self.bottomView.hidden = NO;
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, BottomViewHeight + KHomeIndicatorHeight, 0));
            }];

        } else {
            //购买完了
            self.bottomView.hidden = YES;
            //改变frame
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
            }];
        }

    } else {
        //付费的课程
        //隐藏免费领取按钮
        self.bottomView.freeGetBtn.hidden = YES;
        //是否邀请好友砍价
        if(self.viewModel.model.canbargain == 0){
            //不能砍价
            self.bottomView.killPriceBtn.hidden = YES;
        } else {
            //可以砍价
            self.bottomView.killPriceBtn.hidden = NO;
            //砍价的价格的展示
            NSString *bargaintoprice = [NSString stringWithFormat:@"¥%.2f",self.viewModel.model.bargaintoprice];
            self.bottomView.killPriceLabel.attributedText = [bargaintoprice attributeWithStr:@"¥" color:white_color font:MediumFont(font(10))];
        }
        //是否已经购买
        if([self.viewModel.model.buy isEqualToString:@"n"]){
            self.bottomView.hidden = NO;
            //是否可以限时特惠
            if(self.viewModel.model.hassecond == 0){
                //不能秒杀
                self.bottomView.originLineView.hidden = YES;
                self.bottomView.originPriceLabel.hidden = YES;
                self.bottomView.afterSecondKillPriceLabel.hidden = YES;

                self.bottomView.noKillPriceLabel.hidden = NO;
                NSString *bargaintoprice = [NSString stringWithFormat:@"¥%.2f",self.viewModel.model.coursemoney];
                self.bottomView.noKillPriceLabel.attributedText = [bargaintoprice attributeWithStr:@"¥" color:white_color font:MediumFont(font(10))];
            } else {
                //可以秒杀
                self.bottomView.originLineView.hidden = NO;
                self.bottomView.originPriceLabel.hidden = NO;
                self.bottomView.afterSecondKillPriceLabel.hidden = NO;

                self.bottomView.noKillPriceLabel.hidden = YES;
                self.bottomView.originPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",self.viewModel.model.coursemoney];
                NSString *bargaintoprice = [NSString stringWithFormat:@"¥%.2f",self.viewModel.model.secondprice.floatValue];
                self.bottomView.afterSecondKillPriceLabel.attributedText = [bargaintoprice attributeWithStr:@"¥" color:white_color font:MediumFont(font(10))];
            }
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, BottomViewHeight + KHomeIndicatorHeight, 0));
            }];
        } else {
            //购买完了
            self.bottomView.hidden = YES;
            //改变frame
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
            }];
        }
    }

    self.tableView.mj_footer.hidden = YES;
    __weak typeof(self)weakSelf = self;
    [_viewModel getCourceSelectJiWithCourseid:self.viewModel.courseId Success:^{
        if(weakSelf.viewModel.selectJiArray.count > 0){
            HJCourseSelectJiModel *model = weakSelf.viewModel.selectJiArray.firstObject;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SetFirstPlayVideoMessage" object:nil userInfo:@{@"model" : model}];
        }
        [weakSelf.tableView reloadData];
    }];
}

- (void)hj_loadData {
    
}

- (void)hj_refreshData {
    __weak typeof(self)weakSelf = self;
    self.tableView.mj_header = [MKRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf.viewModel getCourceSelectJiWithCourseid:weakSelf.viewModel.courseId Success:^{
            [weakSelf.tableView reloadData];
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer resetNoMoreData];
        });
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  kHeight(48.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.selectJiArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HJSelectJiListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJSelectJiListCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorColor = HEXColor(@"#EAEAEA");
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = RGBA(255, 255, 255, 0.5);
    if(indexPath.row < self.viewModel.selectJiArray.count) {
        [cell setViewModel:self.viewModel indexPath:indexPath];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.viewModel.selectJiArray.count) {
        kRepeatClickTime(1.0);
//        if([self.viewModel.model.buy isEqualToString:@"n"]) {
//            if (self.viewModel.model.courselimit == 1) {
//                ShowMessage(@"请先领取课程");
//                return;
//            } else {
//                ShowMessage(@"请先购买课程");
//                return;
//            }
//        }
        HJCourseSelectJiModel *model = self.viewModel.selectJiArray[indexPath.row];

        [self.backSub sendNext:model];

        //播放量加一
        if (self.lastSelectModel) {
            self.lastSelectModel.isOnPlay = NO;
            //存储是否已经播放
            NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
            [defa setValue:@"1" forKey:self.lastSelectModel.videourl];
            [defa synchronize];

            self.lastSelectModel = model;

            model.isOnPlay = YES;

            //刷新数据
            [self.tableView reloadData];

        } else {
            self.lastSelectModel = model;
            model.isOnPlay = YES;
            //刷新数据
            [self.tableView reloadData];

            NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
            [defa setValue:@"1" forKey:model.videourl];
            [defa synchronize];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001f;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"暂无数据空白页"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"暂无相关选集";
    NSDictionary *attribute = @{NSFontAttributeName: MediumFont(font(15)), NSForegroundColorAttributeName: HEXColor(@"#999999")};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}


@end
