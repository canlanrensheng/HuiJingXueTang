//
//  HJSchoolViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/23.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSchoolViewController.h"
#import "HJSchoolClassViewController.h"
#import "HJSchoolLiveViewController.h"
#import "HJSchoolSementView.h"
#import "HJSchoolSearchView.h"

//#import "shoppingCartViewController.h"
@interface HJSchoolViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, weak) UICollectionView *collectionMain;
@property (nonatomic, strong) NSArray *controllersClass;
@property (nonatomic, strong) NSMutableArray *controllers;

@property (nonatomic,assign) NSInteger  selectIndex;
@property (nonatomic,strong) UIButton *footerView;

@property (nonatomic,strong) HJSchoolSementView *topButtonView;
@property (nonatomic,strong) HJSchoolSearchView *searchView;

@end


@implementation HJSchoolViewController

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


- (void)hj_setNavagation {
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, kNavigationBarHeight)];
    navView.backgroundColor = NavAndBtnColor;
    [self.view addSubview:navView];
    
    self.searchView = [[HJSchoolSearchView alloc] init];
    [navView addSubview:self.searchView];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(navView).offset(kWidth(10.0));
        make.top.equalTo(navView).offset(kStatusBarHeight + kHeight(8.0));
        make.right.equalTo(navView).offset(-kWidth(37));
        make.height.mas_equalTo(kHeight(28.0));
    }];
    [self.searchView.searchSubject subscribeNext:^(id  _Nullable x) {
        [DCURLRouter pushURLString:@"route://searchResultVC" animated:YES];
    }];
    
    UIButton *carBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"",nil,white_color,0);
        [button setBackgroundImage:V_IMAGE(@"购物车") forState:UIControlStateNormal];
//        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//            @strongify(self);
            [DCURLRouter pushURLString:@"route://shopCarVC" animated:YES];
//            shoppingCartViewController *shopVC = [[shoppingCartViewController alloc] init];
//            [VisibleViewController().navigationController pushViewController:shopVC animated:YES];
        }];
    }];
    [navView addSubview:carBtn];
    [carBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.searchView);
        make.right.equalTo(navView).offset(-kWidth(10.0));
        make.width.height.mas_offset(kWidth(16));
    }];
    
    self.controllersClass = @[@"HJSchoolClassViewController",@"HJSchoolLiveViewController"];
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:nil image:V_IMAGE(@"搜索ICON") action:^(id sender) {
//
//    }];
}

- (void)hj_configSubViews {
    [self.view addSubview:self.topButtonView];
    [self createCollectionView];
}

- (void)hj_loadData {
    
}

- (void)createCollectionView{
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
    flowlayout.minimumInteritemSpacing = 2;
    flowlayout.minimumLineSpacing = 2;
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, 0 );
    [flowlayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    UICollectionView *collectionMain = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowlayout];
    collectionMain.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    collectionMain.dataSource = self;
    collectionMain.delegate = self;
    collectionMain.pagingEnabled = YES;
    
    collectionMain.bounces = NO;
    collectionMain.scrollEnabled = NO;
    collectionMain.showsHorizontalScrollIndicator = NO;
    [collectionMain registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    if (@available(iOS 11.0, *)) {
        collectionMain.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.collectionMain = collectionMain;
    
    [self.view addSubview:collectionMain];
    [self.view bringSubviewToFront:collectionMain];
    
    [self.collectionMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topButtonView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(0);
    }];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.collectionMain.frame.size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.controllersClass.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIViewController *vc = self.controllers[indexPath.row];
    [vc.view removeFromSuperview];
    [cell.contentView addSubview:vc.view];
    
    [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(cell.contentView);
        make.top.equalTo(cell.contentView);
    }];
    return cell;
}

- (NSMutableArray *)controllers{
    if (!_controllers) {
        NSMutableArray *controllers = [NSMutableArray array];
        for(int i = 0; i < self.controllersClass.count;i++){
            if( i == 0) {
                HJSchoolClassViewController *listVC = [[HJSchoolClassViewController alloc] init];
                [self addChildViewController:listVC];
                [controllers addObject:listVC];
            } else {
                HJSchoolLiveViewController *listVC = [[HJSchoolLiveViewController alloc] init];
                [self addChildViewController:listVC];
                [controllers addObject:listVC];
            }
            
        }
        _controllers = controllers;
    }
    return _controllers;
}


- (HJSchoolSementView *)topButtonView {
    if (!_topButtonView) {
        _topButtonView = [[HJSchoolSementView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, Screen_Width, kHeight(45))];
       
        @weakify(self);
        [_topButtonView.clickSubject subscribeNext:^(id x) {
            @strongify(self);
            self.selectIndex = [x integerValue];
            [self.collectionMain scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
            if(self.selectIndex == 0) {
                self.searchView.placeLabel.text = @"搜索/老师/课程";
            } else {
                self.searchView.placeLabel.text = @"搜索/老师/直播间";
            }
        }];
    }
    return _topButtonView;
}

@end
