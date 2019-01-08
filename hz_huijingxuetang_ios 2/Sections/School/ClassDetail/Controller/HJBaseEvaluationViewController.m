//
//  HJBaseEvaluationViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/25.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJBaseEvaluationViewController.h"
#import "HJEvaluationTotalCourseCell.h"
#import "HJEvaluationSingleCell.h"
#import "HJClassDetailBottomView.h"
#import "HJCourseDetailCommentModel.h"
#define BottomViewHeight kHeight(49)
@interface HJBaseEvaluationViewController ()

@property (nonatomic,strong) HJClassDetailBottomView *bottomView;
//撰写评论的按钮
@property (nonatomic,strong) UIButton *writeCommotBtn;

@end

@implementation HJBaseEvaluationViewController

- (void)viewDidLoad {
    self.tableViewStyle = UITableViewStyleGrouped;
    [super viewDidLoad];
}

- (UIButton *)writeCommotBtn {
    if(!_writeCommotBtn) {
        _writeCommotBtn = [UIButton creatButton:^(UIButton *button) {
            button.ljTitle_font_titleColor_state(@"撰写评价",MediumFont(font(15)),white_color,0);
            button.backgroundColor = HEXColor(@"#22476B");
            @weakify(self);
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self);
                RACSubject *backSubject = [[RACSubject alloc] init];
                [backSubject subscribeNext:^(id  _Nullable x) {
                    [self.tableView.mj_header beginRefreshing];
                    self.bottomView.hidden = YES;
                    self.writeCommotBtn.hidden = YES;
                    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
                    }];
                }];
                [DCURLRouter pushURLString:@"route://postEvaluationVC" query:@{@"subject" : backSubject,
                                                                               @"courseid" : self.viewModel.courseId
                                                                               } animated:YES];
            }];
        }];
    }
    return _writeCommotBtn;
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
                        [self.evaluationSubject sendNext:nil];
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
    self.bottomView.hidden = YES;
    
    [self.view addSubview:self.writeCommotBtn];
    self.writeCommotBtn.hidden = YES;
    [self.writeCommotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-KHomeIndicatorHeight);
        make.height.mas_equalTo(kHeight(49.0));
    }];
    
    [self.tableView registerClassCell:[HJEvaluationTotalCourseCell class]];
    [self.tableView registerClassCell:[HJEvaluationSingleCell class]];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, BottomViewHeight + KHomeIndicatorHeight, 0));
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
    self.tableView.mj_footer.hidden = YES;
    self.viewModel.tableView = self.tableView;
    self.viewModel.page = 1;
    __weak typeof(self)weakSelf = self;
    [_viewModel getCourceCommentWithCourseid:self.viewModel.courseId Success:^{
        if(MaJia) {
            weakSelf.bottomView.hidden = YES;
            weakSelf.writeCommotBtn.hidden = NO;
            //改变frame
            [weakSelf.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, BottomViewHeight + KHomeIndicatorHeight, 0));
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            return;
        }
        //免费课程
        if (weakSelf.viewModel.model.courselimit == 1) {
            //是否已经购买
            if([weakSelf.viewModel.model.buy isEqualToString:@"n"]){
                //没有购买 不能点击播放
                weakSelf.bottomView.freeGetBtn.hidden = NO;
                weakSelf.writeCommotBtn.hidden = YES;
                weakSelf.bottomView.hidden = NO;
                [weakSelf.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, BottomViewHeight + KHomeIndicatorHeight, 0));
                }];

            } else {
                //购买完了
                if (weakSelf.viewModel.commentcount.integerValue == 1) {
                    //已经评论
                    weakSelf.bottomView.hidden = YES;
                    weakSelf.writeCommotBtn.hidden = YES;
                    [weakSelf.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
                    }];
                } else {
                    //还没有评论
                    weakSelf.bottomView.hidden = YES;
                    weakSelf.writeCommotBtn.hidden = NO;
                    //改变frame
                    [weakSelf.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, BottomViewHeight + KHomeIndicatorHeight, 0));
                    }];
                }
            }
        } else {
            //付费的课程
            //隐藏免费领取按钮
            weakSelf.bottomView.freeGetBtn.hidden = YES;
            //是否邀请好友砍价
            if(weakSelf.viewModel.model.canbargain == 0){
                //不能砍价
                weakSelf.bottomView.killPriceBtn.hidden = YES;
            } else {
                //可以砍价
                weakSelf.bottomView.killPriceBtn.hidden = NO;
                //砍价的价格的展示
                NSString *bargaintoprice = [NSString stringWithFormat:@"¥%.2f",weakSelf.viewModel.model.bargaintoprice];
                weakSelf.bottomView.killPriceLabel.attributedText = [bargaintoprice attributeWithStr:@"¥" color:white_color font:MediumFont(font(10))];
            }
            //是否已经购买
            if([weakSelf.viewModel.model.buy isEqualToString:@"n"]){
                weakSelf.writeCommotBtn.hidden = YES;
                weakSelf.bottomView.hidden = NO;
                //是否可以限时特惠
                if(weakSelf.viewModel.model.hassecond == 0){
                    //不能秒杀
                    weakSelf.bottomView.originLineView.hidden = YES;
                    weakSelf.bottomView.originPriceLabel.hidden = YES;
                    weakSelf.bottomView.afterSecondKillPriceLabel.hidden = YES;

                    weakSelf.bottomView.noKillPriceLabel.hidden = NO;
                    NSString *bargaintoprice = [NSString stringWithFormat:@"¥%.2f",weakSelf.viewModel.model.coursemoney];
                    weakSelf.bottomView.noKillPriceLabel.attributedText = [bargaintoprice attributeWithStr:@"¥" color:white_color font:MediumFont(font(10))];
                } else {
                    //可以秒杀
                    weakSelf.bottomView.originLineView.hidden = NO;
                    weakSelf.bottomView.originPriceLabel.hidden = NO;
                    weakSelf.bottomView.afterSecondKillPriceLabel.hidden = NO;

                    weakSelf.bottomView.noKillPriceLabel.hidden = YES;
                    weakSelf.bottomView.originPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",weakSelf.viewModel.model.coursemoney];
                    NSString *bargaintoprice = [NSString stringWithFormat:@"¥%.2f",weakSelf.viewModel.model.secondprice.floatValue];
                    weakSelf.bottomView.afterSecondKillPriceLabel.attributedText = [bargaintoprice attributeWithStr:@"¥" color:white_color font:MediumFont(font(10))];
                }
                [weakSelf.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, BottomViewHeight + KHomeIndicatorHeight, 0));
                }];
            } else {
                //购买完了
                if (weakSelf.viewModel.commentcount.integerValue == 1) {
                    //已经评论
                    weakSelf.bottomView.hidden = YES;
                    weakSelf.writeCommotBtn.hidden = YES;
                    [weakSelf.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
                    }];
                } else {
                    //还没有评论
                    weakSelf.bottomView.hidden = YES;
                    weakSelf.writeCommotBtn.hidden = NO;
                    //改变frame
                    [weakSelf.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, BottomViewHeight + KHomeIndicatorHeight, 0));
                    }];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)hj_loadData {
    
}

- (void)hj_refreshData {
    @weakify(self);
    self.tableView.mj_header = [MKRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.viewModel.page = 1;
        [self.viewModel getCourceCommentWithCourseid:self.viewModel.courseId Success:^{
            [self.tableView reloadData];
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
        });
    }];

    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.viewModel.page++;
        if(self.viewModel.currentpage < self.viewModel.totalpage){
            [self.viewModel getCourceCommentWithCourseid:self.viewModel.courseId Success:^{
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            }];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.tableView reloadData];
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row < self.viewModel.commentArray.count) {
        if(indexPath.section == 0) {
            return  kHeight(65.0);
        }
        HJCourseDetailCommentModel *model = self.viewModel.commentArray[indexPath.row];
        return  model.cellHeight;
    }
    return  0.0001f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(self.viewModel.commentArray.count > 0) {
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.viewModel.commentArray.count > 0) {
        if(section == 0) {
            return 1;
        }
        return self.viewModel.commentArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.viewModel.commentArray.count > 0) {
        if(indexPath.section == 0) {
            HJEvaluationTotalCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJEvaluationTotalCourseCell class]) forIndexPath:indexPath];
            self.tableView.separatorColor = clear_color;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.hidden = NO;
            [cell setViewModel:self.viewModel indexPath:indexPath];
            return cell;
        }
        HJEvaluationSingleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJEvaluationSingleCell class]) forIndexPath:indexPath];
        self.tableView.separatorColor = clear_color;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.hidden = NO;
        [cell setViewModel:self.viewModel indexPath:indexPath];
        return cell;
    }
    HJEvaluationSingleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJEvaluationSingleCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = clear_color;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.hidden = YES;
    [cell setViewModel:self.viewModel indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"评论 空白页"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"暂时还没有评价哦";
    NSDictionary *attribute = @{NSFontAttributeName: MediumFont(font(15)), NSForegroundColorAttributeName: HEXColor(@"#999999")};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

@end
