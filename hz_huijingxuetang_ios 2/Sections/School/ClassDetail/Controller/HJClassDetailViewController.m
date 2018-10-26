//
//  HJClassDetailViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/25.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJClassDetailViewController.h"
#import "HJBaseSelectJiViewController.h"
#import "HJBaseClassDetailViewController.h"
#import "HJBaseEvaluationViewController.h"
#import "HJClassDetailToolView.h"
#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>
#import "YJShareTool.h"
static NSString *kVideoCover = @"https://upload-images.jianshu.io/upload_images/635942-14593722fe3f0695.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240";

@interface HJClassDetailViewController()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, weak) UICollectionView *collectionMain;
@property (nonatomic, strong) NSArray *controllersClass;
@property (nonatomic, strong) NSMutableArray *controllers;

@property (nonatomic,assign) NSInteger  selectIndex;
@property (nonatomic,strong) UIButton *footerView;

@property (nonatomic, strong) ZFPlayerController *player;

@property (nonatomic, strong) UIImageView *containerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic,strong) HJClassDetailToolView *toolView;
@property (nonatomic,strong) UIButton *playBtn;

@property (nonatomic,strong) UIButton *rePlayBtn;


@end


@implementation HJClassDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CGFLOAT_MIN * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    });
    self.player.viewControllerDisappear = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    [self createCollectionView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.player.viewControllerDisappear = YES;
}

- (UIImageView *)containerView {
    if (!_containerView) {
        _containerView = [UIImageView new];
        [_containerView sd_setImageWithURL:URL(kVideoCover) placeholderImage:[UIImage imageWithColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1]]];
    }
    return _containerView;
}

- (void)hj_setNavagation {
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(kHeight(210));
    }];
    
    [self.containerView addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.containerView);
        make.width.height.mas_equalTo(kHeight(60.0));
    }];
    
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    /// 播放器相关
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
    self.player.controlView = self.controlView;
    /// 设置退到后台继续播放
    self.player.pauseWhenAppResignActive = NO;
   
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        [self setNeedsStatusBarAppearanceUpdate];
    };
    
    /// 播放完成
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        self.player.pauseByEvent = YES;

    };
    
//    self.player.playerReadyToPlay = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSURL * _Nonnull assetURL) {
//        NSLog(@"======开始播放了");
//        if(self.player.progress == 1) {
//            [self.player.currentPlayerManager replay];
//        }
//    };
    
    NSArray *assetURLs = @[URL(@"http://www.apple.com/105/media/us/iphone-x/2017/01df5b43-28e4-4848-bf20-490c34a926a7/films/feature/iphone-x-feature-tpl-cc-us-20170912_1280x720h.mp4")];
    self.player.assetURLs = assetURLs;

    
    //分享按钮
    UIButton *carBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"",nil,white_color,0);
        [button setBackgroundImage:V_IMAGE(@"分享") forState:UIControlStateNormal];
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [YJShareTool ToolShareUrlWithUrl:@"http://mp.huijingschool.com/#/share" title:@"慧鲸学堂" content:@"邀请好友" andViewC:self];
        }];
    }];
    [self.view addSubview:carBtn];
    [carBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kStatusBarHeight + kHeight(9.0));
        make.right.equalTo(self.view).offset(-kWidth(10.0));
        make.width.height.mas_offset(kWidth(30));
    }];
        
    UIButton *backBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"",nil,white_color,0);
        [button setBackgroundImage:V_IMAGE(@"返回按钮") forState:UIControlStateNormal];
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(carBtn);
        make.left.equalTo(self.view).offset(kWidth(10.0));
        make.width.height.mas_offset(kWidth(30));
    }];
    
    //工具条的按钮的操作
    HJClassDetailToolView *toolView = [[HJClassDetailToolView alloc] init];
    [self.view addSubview:toolView];
    [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(kHeight(40));
        make.top.mas_equalTo(kHeight(210));
    }];
    self.toolView = toolView;
    @weakify(self);
    [toolView.clickSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.selectIndex = [x integerValue];
        [self.collectionMain scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }];

    self.controllersClass = @[@"HJBaseClassDetailViewController",@"HJBaseSelectJiViewController",@"HJBaseEvaluationViewController"];
    
}

- (void)replayClick:(UIButton *)btn {
    [self.player.currentPlayerManager replay];
    [btn removeFromSuperview];
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}


- (void)playClick:(UIButton *)sender {
    [self.player playTheIndex:0];
    [self.controlView showTitle:@"" coverURLString:kVideoCover fullScreenMode:ZFFullScreenModeLandscape];
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
    }
    return _controlView;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    /// 如果只是支持iOS9+ 那直接return NO即可，这里为了适配iOS8
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (BOOL)shouldAutorotate {
    return self.player.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.player.isFullScreen) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
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
//        make.top.equalTo(self.toolView.mas_bottom);
        make.top.equalTo(self.view).offset(kHeight(210 + 40));
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
                HJBaseClassDetailViewController *listVC = [[HJBaseClassDetailViewController alloc] init];
                [self addChildViewController:listVC];
                [controllers addObject:listVC];
            } else if (i == 1){
                HJBaseSelectJiViewController *listVC = [[HJBaseSelectJiViewController alloc] init];
                [self addChildViewController:listVC];
                [controllers addObject:listVC];
            } else {
                HJBaseEvaluationViewController *listVC = [[HJBaseEvaluationViewController alloc] init];
                [self addChildViewController:listVC];
                [controllers addObject:listVC];
            }
            
        }
        _controllers = controllers;
    }
    return _controllers;
}


@end
                         
                         
