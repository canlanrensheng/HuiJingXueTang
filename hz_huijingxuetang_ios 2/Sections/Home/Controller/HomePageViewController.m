//
//  HomePageViewController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/1/15.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HomePageViewController.h"
#import "HJHomeHeaderView.h"
#import "HJHomeViewModel.h"
#import "HJHomeLimitKillViewCell.h"
#import "HJHomeLiveOnlineViewCell.h"
#import "HJHomeExclusiveInfoViewCell.h"
#import "HJHomeStuntJudgeStockViewCell.h"
#import "HJHomeTeacherRecommendedViewCell.h"
#import "HJHomeCourseRecommendedViewCell.h"
#import "HJHomeCourseRecommendedModel.h"
#import "HJHomeLatestSatausView.h"

//区头
#import "HJHomeSectionHeaderView.h"

@interface HomePageViewController ()<UITableViewDataSource,UITableViewDataSource>


//慧鲸头试图
@property (nonatomic,strong) UIScrollView *backgroundScrollView;
//轮播图
@property (nonatomic,strong) HJHomeHeaderView *homeHeaderView;
//最新的动态
@property (nonatomic,strong) HJHomeLatestSatausView *latestSatausView;

@property (nonatomic,strong) HJHomeViewModel *viewModel;

@property (nonatomic,assign) BOOL isFirstLoad;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    self.tableViewStyle = UITableViewStyleGrouped;
    [super viewDidLoad];
}

- (void)injected{
    [self viewDidLoad];
}

- (HJHomeHeaderView *)homeHeaderView {
    if(!_homeHeaderView){
        _homeHeaderView = [[HJHomeHeaderView alloc] init];
    }
    return _homeHeaderView;
}

//最新动态
- (HJHomeLatestSatausView *)latestSatausView {
    if(!_latestSatausView){
        _latestSatausView = [[HJHomeLatestSatausView alloc] init];
    }
    return _latestSatausView;
}

- (HJHomeViewModel *)viewModel {
    if(!_viewModel){
        _viewModel = [[HJHomeViewModel alloc] init];
    }
    return _viewModel;
}

- (void)hj_setNavagation {
    self.title = @"首页";
    if(!MaJia) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:nil image:V_IMAGE(@"搜索ICON") action:^(id sender) {
            NSDictionary *para =  @{@"type" : @"1"};
            [DCURLRouter pushURLString:@"route://searchResultVC" query:para  animated:YES];
        }];
    }
}

- (void)hj_configSubViews{
    if(MaJia) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, kHeight(185.0 + 100))];
        //轮播图
        self.homeHeaderView.frame = CGRectMake(0, 0, Screen_Width, kHeight(185.0 + 100));
        [headerView addSubview:self.homeHeaderView];
        self.tableView.tableHeaderView = headerView;
    } else {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, kHeight(185.0 + 100) + kHeight(72.0))];
        //轮播图
        self.homeHeaderView.frame = CGRectMake(0, 0, Screen_Width, kHeight(185.0 + 100));
        [headerView addSubview:self.homeHeaderView];
        //最新的动态
        self.latestSatausView.frame = CGRectMake(0, CGRectGetMaxY(self.homeHeaderView.frame), Screen_Width, kHeight(72.0));
        [headerView addSubview:self.latestSatausView];
        
        self.tableView.tableHeaderView = headerView;
    }
   
    self.numberOfSections = 1;
    
    self.sectionFooterHeight = 0.001f;
    
    //限时秒杀
    [self.tableView registerClass:[HJHomeLimitKillViewCell class] forCellReuseIdentifier:NSStringFromClass([HJHomeLimitKillViewCell class])];
    //正在直播
    [self.tableView registerClassCell:[HJHomeLiveOnlineViewCell class]];
    //独家快讯
    [self.tableView registerClassCell:[HJHomeExclusiveInfoViewCell class]];
    //绝技诊股
    [self.tableView registerClassCell:[HJHomeStuntJudgeStockViewCell class]];
    //名师推荐
    [self.tableView registerClassCell:[HJHomeTeacherRecommendedViewCell class]];
    //课程推荐
    [self.tableView registerClassCell:[HJHomeCourseRecommendedViewCell class]];
    
    //区头
//    [self.tableView registerClass:[HJHomeSectionHeaderView class] forHeaderFooterViewReuseIdentifier:@"HJHomeSectionHeaderView"];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
}

- (void)hj_loadData {
    //加载轮播图数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [YJAPPNetwork getAdSuccess:^(NSDictionary *responseObject) {
            NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
            if (code == 200) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSMutableArray *urlArr = [NSMutableArray array];
                    self.viewModel.cycleScrollViewDataArray = [NSMutableArray array];
                    if([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
                        for (NSDictionary *dic in responseObject[@"data"]) {
                            NSString *url = dic[@"picurl"];
                            [urlArr addObject:url];
                            [self.viewModel.cycleScrollViewDataArray addObject:dic];
                        }
                        self.viewModel.headerDataArray = urlArr;
                        [self.homeHeaderView setViewModel:self.viewModel];
                    }
                });
            }else{
//                [ConventionJudge NetCode:code vc:self type:@"1"];
            }
        } failure:^(NSString *error) {
            if(!self.isFirstLoad) {
                [self.viewModel.loadingView stopLoadingView];
                self.isFirstLoad = YES;
            }
            ShowError(netError);
        }];
    });
    
    //加载最新的资讯
    [self.viewModel getDynamicnewSuccess:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.latestSatausView setViewModel:self.viewModel];
        });
    }];
    //加载限时特惠
    [self.viewModel getLimitKillDataWithSuccess:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    //加载正在直播的数据
    [self.viewModel getLiveListSuccess:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self.viewModel.liveListArray.count > 0){
                 [self.homeHeaderView.onLiveButton setBackgroundImage:[UIImage imageNamed:@"直播有消息"] forState:UIControlStateNormal];
            } else {
                 [self.homeHeaderView.onLiveButton setBackgroundImage:[UIImage imageNamed:@"直播ICON"] forState:UIControlStateNormal];
            }
            [self.tableView reloadData];
        });
    }];
    
    //加载绝技诊股
    [self.viewModel stuntJudgeStockWithType:@"1" page:@"1" success:^{
        dispatch_async(dispatch_get_main_queue(), ^{
           [self.tableView reloadData];
        });
    }];
    //获取独家资讯
    [self.viewModel getExclusiveInfoSuccess:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    
    //加载课程列表
    NSString *courseType = @"";
    if(MaJia) {
        courseType = @"free";
    }
    [self.viewModel HomeRecommongCourceWithType:courseType success:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    
    //获取推荐老师
    [self.viewModel recommentTeacherWithPage:@"1" success:^{
        dispatch_async(dispatch_get_main_queue(), ^{
           [self.tableView reloadData];
        });
    }];

}

- (void)hj_refreshData {
    @weakify(self);
    self.tableView.mj_header = [MKRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self hj_loadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
        });
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0) {
        if(MaJia) {
            return 0.00001f;
        }
        if(self.viewModel.limitKillArray.count > 0) {
            return kHeight(170 + 25.0);
        }
        return 0.00001f;
    }
    if (indexPath.section == 1) {
        if(MaJia) {
            return 0.00001f;
        }
        if (self.viewModel.liveListArray.count > 3) {
            return kHeight(160.0 + 25.0);
        }
        return 0.00001f;
    }
    if (indexPath.section == 2) {
        return kHeight(220 + 10);
    }
    if (indexPath.section == 3) {
        return kHeight(276 + 25);
    }
    if (indexPath.section == 4) {
        return kHeight(141);
    }
    if(indexPath.section == 5){
        if(indexPath.row == 0) {
            return  kHeight(100.0);
        }
        return  kHeight(111.0);
    }
    return  0.0001f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0) {
        return 1;
    }
    if (section == 1) {
        return 1;
    }
    if (section == 2) {
        return 1;
    }
    if (section == 3) {
        return 1;
    }
    if (section == 4) {
        return 1;
    }
    return self.viewModel.recommongCourceDataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0) {
        HJHomeLimitKillViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJHomeLimitKillViewCell class]) forIndexPath:indexPath];
        self.tableView.separatorColor = clear_color;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(MaJia) {
            cell.hidden = YES;
        } else {
            if(self.viewModel.limitKillArray.count > 0) {
                cell.hidden = NO;
                [cell setViewModel:self.viewModel indexPath:indexPath];
            } else {
                cell.hidden = YES;
            }
        }
        
        return cell;
    }
    if (indexPath.section == 1) {
        HJHomeLiveOnlineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJHomeLiveOnlineViewCell class]) forIndexPath:indexPath];
        self.tableView.separatorColor = clear_color;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(MaJia) {
            cell.hidden = YES;
        } else {
            if (self.viewModel.liveListArray.count > 3) {
                cell.hidden = NO;
                [cell setViewModel:self.viewModel indexPath:indexPath];
            } else {
                cell.hidden = YES;
            }
        }
        return cell;
    }
    if (indexPath.section == 2) {
        HJHomeExclusiveInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJHomeExclusiveInfoViewCell class]) forIndexPath:indexPath];
        self.tableView.separatorColor = clear_color;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setViewModel:self.viewModel indexPath:indexPath];
        return cell;
    }
    if (indexPath.section == 3) {
        HJHomeStuntJudgeStockViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJHomeStuntJudgeStockViewCell class]) forIndexPath:indexPath];
        self.tableView.separatorColor = clear_color;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setViewModel:self.viewModel indexPath:indexPath];
        return cell;
    }
    if (indexPath.section == 4) {
        HJHomeTeacherRecommendedViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJHomeTeacherRecommendedViewCell class]) forIndexPath:indexPath];
        self.tableView.separatorColor = clear_color;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setViewModel:self.viewModel indexPath:indexPath];
        return cell;
    }
    
    HJHomeCourseRecommendedViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJHomeCourseRecommendedViewCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = clear_color;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setViewModel:self.viewModel indexPath:indexPath];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HJHomeSectionHeaderView *
        sectionHeaderView = [[HJHomeSectionHeaderView alloc] initWithReuseIdentifier:@"HJHomeSectionHeaderView"];
    
    if(section == 0) {
        sectionHeaderView.titleTextLabel.text = @"秒杀特供";
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = white_color;
        sectionHeaderView.backgroundView = backView;
        sectionHeaderView.moreBtn.hidden = NO;
        [sectionHeaderView.backSubject subscribeNext:^(id  _Nullable x) {
            [DCURLRouter pushURLString:@"route://limitTimeKillVC" animated:YES];
        }];
        if(MaJia) {
            sectionHeaderView.hidden = YES;
        } else {
            if(self.viewModel.limitKillArray.count > 0) {
                if(self.viewModel.limitKillArray.count > 2) {
                    sectionHeaderView.moreBtn.hidden = NO;
                } else {
                    sectionHeaderView.moreBtn.hidden = YES;
                }
            } else {
                sectionHeaderView.hidden = YES;
            }
        }
        return  sectionHeaderView;
    }
    if (section == 1) {
        sectionHeaderView.titleTextLabel.text = @"正在直播";
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = HEXColor(@"#F5F5F5");
        sectionHeaderView.backgroundView = backView;
        sectionHeaderView.moreBtn.hidden = YES;
        [sectionHeaderView.backSubject subscribeNext:^(id  _Nullable x) {
            //更多的直播的列表
            
        }];
        if(MaJia) {
            sectionHeaderView.hidden = YES;
        } else {
            if (self.viewModel.liveListArray.count > 3) {
                sectionHeaderView.hidden = NO;
            } else {
                sectionHeaderView.hidden = YES;
            }
        }
        return  sectionHeaderView;
    }
    if (section == 2) {
        sectionHeaderView.titleTextLabel.text = @"独家快讯";
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = white_color;
        sectionHeaderView.backgroundView = backView;
        sectionHeaderView.moreBtn.hidden = NO;
        [sectionHeaderView.backSubject subscribeNext:^(id  _Nullable x) {
            if(MaJia) {
                VisibleViewController().tabBarController.selectedIndex = 2;
            } else {
                VisibleViewController().tabBarController.selectedIndex = 3;
            }
        }];
        return  sectionHeaderView;
    }
    if (section == 3) {
        sectionHeaderView.titleTextLabel.text = @"绝技诊股";
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = HEXColor(@"#F5F5F5");
        sectionHeaderView.backgroundView = backView;
        sectionHeaderView.moreBtn.hidden = NO;
        [sectionHeaderView.backSubject subscribeNext:^(id  _Nullable x) {
            if([APPUserDataIofo AccessToken].length <= 0) {
//                ShowMessage(@"您还未登录");
                [DCURLRouter pushURLString:@"route://loginVC" animated:YES];
                return;
            }
            [DCURLRouter pushURLString:@"route://stuntJudgeVC" animated:YES];
        }];
        return  sectionHeaderView;
    }
    if (section == 4) {
        sectionHeaderView.titleTextLabel.text = @"名师推荐";
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = white_color;
        sectionHeaderView.backgroundView = backView;
        sectionHeaderView.moreBtn.hidden = NO;
        [sectionHeaderView.backSubject subscribeNext:^(id  _Nullable x) {
            [DCURLRouter pushURLString:@"route://teacherRecommondVC" animated:YES];
        }];
        
        if(self.viewModel.recommentTeacherArray.count > 4) {
            sectionHeaderView.moreBtn.hidden = NO;
        } else {
            sectionHeaderView.moreBtn.hidden = YES;
        }
        return  sectionHeaderView;
    }
    sectionHeaderView.titleTextLabel.text = @"课程推荐";
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = white_color;
    sectionHeaderView.backgroundView = backView;
    if(MaJia) {
        sectionHeaderView.moreBtn.hidden = YES;
    } else {
        sectionHeaderView.moreBtn.hidden = NO;
    }
    [sectionHeaderView.backSubject subscribeNext:^(id  _Nullable x) {
        [DCURLRouter pushURLString:@"route://recommentCourseVC" animated:YES];
    }];
    return  sectionHeaderView;
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0) {
        if(MaJia) {
            return 0.00001f;
        } else {
            if(self.viewModel.limitKillArray.count > 0) {
                return kHeight(60);
            } else {
                return 0.00001f;
            }
        }
       
    }
    if (section == 1) {
        if (MaJia) {
            return 0.00001f;
        } else {
            if (self.viewModel.liveListArray.count > 3) {
                return kHeight(60);
            } else {
                return 0.00001f;
            }
        }
    }
    return kHeight(60);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 5) {
        //课程推荐
        if([APPUserDataIofo AccessToken].length <= 0) {
            [DCURLRouter pushURLString:@"route://loginVC" animated:YES];
            return;
        }
        kRepeatClickTime(1.0);
        HJHomeCourseRecommendedModel *model = self.viewModel.recommongCourceDataArray[indexPath.row];
        [DCURLRouter pushURLString:@"route://classDetailVC" query:@{@"courseId" : model.courseid .length > 0 ? model.courseid : @""} animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if(section == 0) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, kHeight(10.0))];
        footerView.backgroundColor = clear_color;
        if(self.viewModel.limitKillArray.count > 0 && self.viewModel.liveListArray.count <= 0) {
            return footerView;
        } else {
            return nil;
        }
    }
    if (section == 5) {
        //我是有底线的
        UILabel *noDataLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(@"我是有底线的！",MediumFont(font(11)),HEXColor(@"#999999"));
            label.textAlignment = NSTextAlignmentCenter;
            [label sizeToFit];
        }];
        noDataLabel.frame = CGRectMake(0, 0, Screen_Width, kHeight(31.0));
        return noDataLabel;
    }
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(section == 0) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, kHeight(10.0))];
        footerView.backgroundColor = Line_Color;
        if(self.viewModel.limitKillArray.count > 0 && self.viewModel.liveListArray.count <= 0) {
            return kHeight(10.0);
        } else {
            return 0.00001f;
        }
    }
    if (section == 5) {
        return kHeight(31.0);
    }
    return 0.0001f;
}


@end
