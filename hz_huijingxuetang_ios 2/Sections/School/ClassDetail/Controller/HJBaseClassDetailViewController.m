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
            [self.viewModel createFreeCourseOrderWithCourseId:self.viewModel.model.courseid Success:^(BOOL succcessFlag) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    ShowMessage(@"领取成功");
                    //刷新数据
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.courseMessageSubject sendNext:nil];
                    });
                });
            }];
        }
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-(KHomeIndicatorHeight));
        make.height.mas_equalTo(kHeight(49.0));
    }];
    
    [self.tableView registerClassCell:[HJBaseClassDetailTeacherInfoCell class]];
    [self.tableView registerClassCell:[HJBaseClassDetailCourceInfoCell class]];
    [self.tableView registerClassCell:[HJBaseClassDetailGroupCell class]];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, KHomeIndicatorHeight, 0));
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
    [self.tableView reloadData];
    if(MaJia) {
        self.bottomView.hidden = YES;
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
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
}

- (void)hj_loadData {

}

- (void)hj_refreshData {
    @weakify(self);
    self.tableView.mj_header = [MKRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel getCourceDetailWithCourseid:self.viewModel.courseId Success:^(BOOL successFlag) {
            [self.tableView reloadData];
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
        });
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0) {
        if(self.viewModel.model.teacherIntroCellHeight){
            return self.viewModel.model.teacherIntroCellHeight;
        }
        return kHeight(148);
    }
    if(self.viewModel.model.courseCellHeight){
        return self.viewModel.model.courseCellHeight;
    }
    return kHeight(127);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0) {
        HJBaseClassDetailTeacherInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJBaseClassDetailTeacherInfoCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
        if(self.viewModel.model) {
            cell.model = self.viewModel.model;
        }
        return cell;
    }
    
    HJBaseClassDetailCourceInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJBaseClassDetailCourceInfoCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
    if(self.viewModel.model) {
        cell.model = self.viewModel.model;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.0001f;
    }
    return kHeight(10.0);
}

@end
