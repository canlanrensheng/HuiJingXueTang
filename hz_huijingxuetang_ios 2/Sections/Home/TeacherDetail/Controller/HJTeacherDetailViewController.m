//
//  HJTeacherDetailViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/5.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJTeacherDetailViewController.h"
#import "HJTeacherDetailHeaderView.h"
#import "HJTopSementView.h"

#import "HJTeacherDetailDynamicViewController.h"
#import "HJTeacherDetailCourceViewController.h"
#import "HJTeacherDetailLiveViewController.h"
#import "HJTeacherDetailActicleViewController.h"

#import "HJTeacherDetailViewModel.h"
@interface HJTeacherDetailViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) HJTeacherDetailHeaderView *headerView;
@property (nonatomic,strong) HJTopSementView *toolView;

@property (nonatomic, strong) NSArray *controllersClass;
@property (nonatomic,assign) NSInteger  selectIndex;
@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) HJTeacherDetailViewModel *viewModel;

@end

@implementation HJTeacherDetailViewController

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

- (HJTeacherDetailViewModel *)viewModel {
    if(!_viewModel){
        _viewModel = [[HJTeacherDetailViewModel alloc] init];
    }
    return  _viewModel;
}

- (HJTeacherDetailHeaderView *)headerView {
    if(!_headerView){
        _headerView = [[HJTeacherDetailHeaderView alloc] init];
    }
    return _headerView;
}

- (void)hj_loadData {
    NSString *teacherId = self.params[@"teacherId"];
    self.viewModel.teacherId = teacherId;
//    [self.viewModel play];
    [self.viewModel getTeacherDetailWithTeacherId:teacherId Success:^{
//        [self.viewModel stop];
        self.headerView.model = self.viewModel.model;
        self.headerView.viewModel = self.viewModel;
    }];
}

- (void)hj_configSubViews {
//    顶部试图
    
    CGFloat headerHeight = kHeight(255.0) + kStatusBarHeight;
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(headerHeight);
    }];

    NSArray *titleArray = @[@"动态",@"课程",@"直播",@"文章"];
    if(MaJia) {
        titleArray = @[@"动态",@"文章"];
    }
   
    __weak typeof(self)weakSelf = self;
    HJTopSementView *toolView = [[HJTopSementView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, kHeight(40)) titleColor:HEXColor(@"#333333") selectTitleColor:HEXColor(@"#22476B") lineColor:HEXColor(@"#22476B")  buttons:titleArray block:^(NSInteger index) {
        weakSelf.selectIndex = index;
        [UIView animateWithDuration:0.25 animations:^{
            [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.selectIndex * Screen_Width, 0)];
        }];
        
    }];
    [self.view addSubview:toolView];
    
    self.toolView = toolView;
    
    [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(kHeight(40));
        make.top.equalTo(self.headerView.mas_bottom);
    }];


//    @weakify(self);
//    [toolView.clickSubject subscribeNext:^(id  _Nullable x) {
//        @strongify(self);
//        //刷新数据
//        self.selectIndex = [x integerValue];
//        [UIView animateWithDuration:0.25 animations:^{
//            [self.scrollView setContentOffset:CGPointMake(self.selectIndex * Screen_Width, 0)];
//        }];
//    }];

    //创建控制器容器
    if(MaJia) {
         self.controllersClass = @[@"HJTeacherDetailDynamicViewController",@"HJTeacherDetailActicleViewController"];
    } else {
         self.controllersClass = @[@"HJTeacherDetailDynamicViewController",@"HJTeacherDetailCourceViewController",@"HJTeacherDetailLiveViewController",@"HJTeacherDetailActicleViewController"];
    }
   
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kHeight(40) + headerHeight, Screen_Width, Screen_Height - kHeight(40) - headerHeight)];
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(Screen_Width * self.controllersClass.count,  Screen_Height - kHeight(40) - headerHeight);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.delegate = self;
    scrollView.bounces = NO;

    [self.view addSubview:scrollView];
    self.scrollView = scrollView;

    for (int index = 0; index < self.controllersClass.count; index++) {
        if(MaJia) {
            if(index == 0) {
                HJTeacherDetailDynamicViewController *vc = [[HJTeacherDetailDynamicViewController alloc] init];
                vc.teacherId = self.viewModel.teacherId;
                vc.view.frame = CGRectMake(0, 0, Screen_Width, Screen_Height - kHeight(40) - headerHeight);
                [self addChildViewController:vc];
                [scrollView addSubview:vc.view];
                
            } else {
                HJTeacherDetailActicleViewController *vc = [[HJTeacherDetailActicleViewController alloc] init];
                vc.view.frame = CGRectMake(Screen_Width * index, 0, Screen_Width, Screen_Height - kHeight(40) - headerHeight);
                [self addChildViewController:vc];
                [scrollView addSubview:vc.view];
                vc.viewModel = self.viewModel;
            }
        } else {
            if(index == 0) {
                HJTeacherDetailDynamicViewController *vc = [[HJTeacherDetailDynamicViewController alloc] init];
                vc.teacherId = self.viewModel.teacherId;
                vc.view.frame = CGRectMake(0, 0, Screen_Width, Screen_Height - kHeight(40) - headerHeight);
                [self addChildViewController:vc];
                [scrollView addSubview:vc.view];
                
            }  else if (index == 1){
                HJTeacherDetailCourceViewController *vc = [[HJTeacherDetailCourceViewController alloc] init];
                vc.view.frame = CGRectMake(Screen_Width * index, 0, Screen_Width, Screen_Height - kHeight(40) - headerHeight);
                [self addChildViewController:vc];
                [scrollView addSubview:vc.view];
                
                vc.viewModel = self.viewModel;
            }  else if (index == 2){
                HJTeacherDetailLiveViewController *vc = [[HJTeacherDetailLiveViewController alloc] init];
                vc.view.frame = CGRectMake(Screen_Width * index, 0, Screen_Width , Screen_Height - kHeight(40) - headerHeight);
                [self addChildViewController:vc];
                [scrollView addSubview:vc.view];
                vc.viewModel = self.viewModel;
            } else {
                HJTeacherDetailActicleViewController *vc = [[HJTeacherDetailActicleViewController alloc] init];
                vc.view.frame = CGRectMake(Screen_Width * index, 0, Screen_Width, Screen_Height - kHeight(40) - headerHeight);
                [self addChildViewController:vc];
                [scrollView addSubview:vc.view];
                vc.viewModel = self.viewModel;
            }
        }
        
    }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = self.view.frame.size.width;
    CGFloat offsetX = scrollView.contentOffset.x;
    //获取索引
    NSInteger scrollIndex = offsetX / width;
    self.toolView.selectIndex = scrollIndex;
}

@end
