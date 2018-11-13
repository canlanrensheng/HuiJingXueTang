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
#import "HJClassDetailTitleView.h"
//#import <ZFPlayer/ZFPlayer.h>
//#import <ZFPlayer/ZFAVPlayerManager.h>
//#import <ZFPlayer/ZFPlayerControlView.h>

#import "NELivePlayerControlView.h"
#import <NELivePlayerFramework/NELivePlayerFramework.h>

static NSString *kVideoCover = @"http://www.apple.com/105/media/us/iphone-x/2017/01df5b43-28e4-4848-bf20-490c34a926a7/films/feature/iphone-x-feature-tpl-cc-us-20170912_1280x720h.mp4";

@interface HJClassDetailViewController()<UICollectionViewDataSource,UICollectionViewDelegate,NELivePlayerControlViewProtocol>
{
    dispatch_source_t _timer;
}

@property (nonatomic, weak) UICollectionView *collectionMain;
@property (nonatomic, strong) NSArray *controllersClass;
@property (nonatomic, strong) NSMutableArray *controllers;

@property (nonatomic,assign) NSInteger  selectIndex;
@property (nonatomic,strong) UIButton *footerView;

//@property (nonatomic, strong) ZFPlayerController *player;

//@property (nonatomic, strong) UIImageView *containerView;
//@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic,strong) HJClassDetailToolView *toolView;
@property (nonatomic,strong) UIButton *playBtn;

@property (nonatomic, strong) NELivePlayerController *player; //播放器sdk
@property (nonatomic, strong) UIView *playerContainerView; //播放器包裹视图
@property (nonatomic, strong) NELivePlayerControlView *controlView; //播放器控制视图


@end


@implementation HJClassDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CGFLOAT_MIN * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    });
//    self.player.viewControllerDisappear = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    [self createCollectionView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.player.viewControllerDisappear = YES;
}

//- (UIImageView *)containerView {
//    if (!_containerView) {
//        _containerView = [UIImageView new];
//        [_containerView sd_setImageWithURL:URL(kVideoCover) placeholderImage:[UIImage imageWithColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1]]];
//    }
//    return _containerView;
//}

- (void)hj_setNavagation {
    
    _playerContainerView = [[UIView alloc] init];
    _playerContainerView.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    [self.view addSubview:_playerContainerView];
    [_playerContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(kHeight(210));
    }];
    
    _controlView = [[NELivePlayerControlView alloc] init];
//    _controlView.fileTitle = [URL(@"http://www.apple.com/105/media/us/iphone-x/2017/01df5b43-28e4-4848-bf20-490c34a926a7/films/feature/iphone-x-feature-tpl-cc-us-20170912_1280x720h.mp4").absoluteString lastPathComponent];
    _controlView.delegate = self;
    [self.view addSubview:_controlView];
    [_controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(_playerContainerView);
    }];
    
    [_controlView controlOverlayHide];
    
//    [self.view addSubview:self.containerView];
//    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(self.view);
//        make.height.mas_equalTo(kHeight(210));
//    }];
    
    [_playerContainerView addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_playerContainerView);
        make.width.height.mas_equalTo(kHeight(60.0));
    }];
    
    [self doInitPlayer];
    [self doInitPlayerNotication];
//    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
//    /// 播放器相关
//    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
//    self.player.controlView = self.controlView;
//    /// 设置退到后台继续播放
//    self.player.pauseWhenAppResignActive = NO;
//
//    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
//        [self setNeedsStatusBarAppearanceUpdate];
//    };
//
//    /// 播放完成
//    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
//        self.player.pauseByEvent = YES;
//
//    };
    
//    self.player.playerReadyToPlay = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSURL * _Nonnull assetURL) {
//        NSLog(@"======开始播放了");
//        if(self.player.progress == 1) {
//            [self.player.currentPlayerManager replay];
//        }
//    };
    
//    NSArray *assetURLs = @[URL(@"http://www.apple.com/105/media/us/iphone-x/2017/01df5b43-28e4-4848-bf20-490c34a926a7/films/feature/iphone-x-feature-tpl-cc-us-20170912_1280x720h.mp4")];
//    self.player.assetURLs = assetURLs;

    
    //分享按钮
    UIButton *carBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"",nil,white_color,0);
        [button setBackgroundImage:V_IMAGE(@"分享") forState:UIControlStateNormal];
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
             [HJShareTool shareWithTitle:@"慧鲸学堂，投资者教育，集智而行，改变世界！" content:@"慧鲸学堂，投资者教育，集智而行，改变世界！" images:@[[UIImage imageNamed:@"hjIcon"]] url:@"http://mp.huijingschool.com/#/share"];
        }];
    }];
    [self.view addSubview:carBtn];
    [carBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kStatusBarHeight + kHeight(9.0));
        make.right.equalTo(self.view).offset(-kWidth(10.0));
        make.width.height.mas_offset(kWidth(30));
    }];
    
    //分享的弹窗的图片
    UIImageView *killPriceImageV = [[UIImageView alloc] init];
    killPriceImageV.image = V_IMAGE(@"砍价提示-1");
    [self.view addSubview:killPriceImageV];
    [killPriceImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(carBtn);
        make.top.equalTo(carBtn.mas_bottom).offset(kHeight(3.0));
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
    
    //标题试图
    HJClassDetailTitleView *titleView = [[HJClassDetailTitleView alloc] init];
    titleView.backgroundColor = white_color;
    [self.view addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(kHeight(50));
        make.top.mas_equalTo(kHeight(210));
    }];
    
    //工具条的按钮的操作
    HJClassDetailToolView *toolView = [[HJClassDetailToolView alloc] init];
    [self.view addSubview:toolView];
    [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(kHeight(40));
        make.top.mas_equalTo(kHeight(210 + 50));
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

//- (void)replayClick:(UIButton *)btn {
//    [self.player.currentPlayerManager replay];
//    [btn removeFromSuperview];
//}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}


- (void)playClick:(UIButton *)sender {
    [self.player prepareToPlay];
    
//    [self.controlView showTitle:@"" coverURLString:kVideoCover fullScreenMode:ZFFullScreenModeLandscape];
}
//
//- (ZFPlayerControlView *)controlView {
//    if (!_controlView) {
//        _controlView = [ZFPlayerControlView new];
//        _controlView.fastViewAnimated = YES;
//    }
//    return _controlView;
//}
//
//- (UIStatusBarStyle)preferredStatusBarStyle {
//    if (self.player.isFullScreen) {
//        return UIStatusBarStyleLightContent;
//    }
//    return UIStatusBarStyleDefault;
//}

//- (BOOL)prefersStatusBarHidden {
//    /// 如果只是支持iOS9+ 那直接return NO即可，这里为了适配iOS8
//    return self.player.isStatusBarHidden;
//}
//
//- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
//    return UIStatusBarAnimationSlide;
//}
//
//- (BOOL)shouldAutorotate {
//    return self.player.shouldAutorotate;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    if (self.player.isFullScreen) {
//        return UIInterfaceOrientationMaskLandscape;
//    }
//    return UIInterfaceOrientationMaskPortrait;
//}


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
        make.top.equalTo(self.view).offset(kHeight(210 + 40 + 50));
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

- (void)syncUIStatus{
    _controlView.isPlaying = NO;
    NSTimeInterval mDuration = 0;
    mDuration = [self.player duration];
    self.controlView.isAllowSeek = (mDuration > 0);
    //视频播放的时长
    self.controlView.duration = [self.player duration];
    //当前的播放时间
    self.controlView.currentPos = [self.player currentPlaybackTime];
    
    [self.player pause];
}

#pragma mark - 播放器SDK功能
- (void)doInitPlayer {
//    [NELivePlayerController setLogLevel:NELP_LOG_VERBOSE];
    NSError *error = nil;
    self.player = [[NELivePlayerController alloc] initWithContentURL:[NSURL URLWithString:@"http://www.apple.com/105/media/us/iphone-x/2017/01df5b43-28e4-4848-bf20-490c34a926a7/films/feature/iphone-x-feature-tpl-cc-us-20170912_1280x720h.mp4"] error:&error];
    if (self.player == nil) {
        DLog(@"player initilize failed, please tay again.error = [%@]!", error);
    }
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.player.view.frame = _playerContainerView.bounds;
    [_playerContainerView addSubview:self.player.view];
    
    self.view.autoresizesSubviews = YES;
    [self.player setBufferStrategy:NELPAntiJitter]; // 点播抗抖动
    [self.player setScalingMode:NELPMovieScalingModeNone]; // 设置画面显示模式，默认原始大小
    [self.player setShouldAutoplay:YES]; // 设置prepareToPlay完成后是否自动播放
    //    [self.player setHardwareDecoder:_isHardware]; // 设置解码模式，是否开启硬件解码
    [self.player setPauseInBackground:NO]; // 设置切入后台时的状态，暂停还是继续播放
    [self.player setPlaybackTimeout:15 *1000]; // 设置拉流超时时间
    
//    [self.player prepareToPlay];
}

- (void)doInitPlayerNotication {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerDidPreparedToPlay:)
                                                 name:NELivePlayerDidPreparedToPlayNotification
                                               object:_player];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NeLivePlayerloadStateChanged:)
                                                 name:NELivePlayerLoadStateChangedNotification
                                               object:_player];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerPlayBackFinished:)
                                                 name:NELivePlayerPlaybackFinishedNotification
                                               object:_player];
    
}

- (void)doDestroyPlayer {
    [self.player shutdown]; // 退出播放并释放相关资源
    [self.player.view removeFromSuperview];
    self.player = nil;
}

#pragma mark - 播放器通知事件
- (void)NELivePlayerDidPreparedToPlay:(NSNotification*)notification {
    //获取视频信息，主要是为了告诉界面的可视范围，方便字幕显示
    NELPVideoInfo info;
    memset(&info, 0, sizeof(NELPVideoInfo));
    [_player getVideoInfo:&info];
    _controlView.videoResolution = CGSizeMake(info.width, info.height);
    
    [self syncUIStatus];
    [_player play]; //开始播放
    
    //开
    [_player setRealTimeListenerWithIntervalMS:500 callback:^(NSTimeInterval realTime) {
        NSLog(@"当前时间戳：[%f]", realTime);
    }];
    //关
    [_player setRealTimeListenerWithIntervalMS:500 callback:nil];
}


- (void)NeLivePlayerloadStateChanged:(NSNotification*)notification {
    NELPMovieLoadState nelpLoadState = _player.loadState;
    if (nelpLoadState == NELPMovieLoadStatePlaythroughOK){
        NSLog(@"finish buffering");
        _controlView.isBuffing = NO;
    }else if (nelpLoadState == NELPMovieLoadStateStalled){
        NSLog(@"begin buffering");
        _controlView.isBuffing = YES;
    }
}

- (void)NELivePlayerPlayBackFinished:(NSNotification*)notification {

}

#pragma mark - 控制页面的事件
- (void)controlViewOnClickQuit:(NELivePlayerControlView *)controlView {
    [self doDestroyPlayer];
    
    // 释放timer
    if (_timer != nil) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)controlViewOnClickPlay:(NELivePlayerControlView *)controlView isPlay:(BOOL)isPlay {
    if (isPlay) {
        [self.player play];
    } else {
        [self.player pause];
    }
}

- (void)controlViewOnClickSeek:(NELivePlayerControlView *)controlView dstTime:(NSTimeInterval)dstTime {
    self.player.currentPlaybackTime = dstTime;
}

- (void)controlViewOnClickMute:(NELivePlayerControlView *)controlView isMute:(BOOL)isMute{
    [self.player setMute:isMute];
}

- (void)controlViewOnClickSnap:(NELivePlayerControlView *)controlView{
    UIImage *snapImage = [self.player getSnapshot];
    UIImageWriteToSavedPhotosAlbum(snapImage, nil, nil, nil);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"截图已保存到相册" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)controlViewOnClickScale:(NELivePlayerControlView *)controlView isFill:(BOOL)isFill {
    if (isFill) {
        [self.player setScalingMode:NELPMovieScalingModeAspectFill];
    } else {
        [self.player setScalingMode:NELPMovieScalingModeAspectFit];
    }
}

#pragma mark - Tools
dispatch_source_t CreateDispatchSyncUITimerN(double interval, dispatch_queue_t queue, dispatch_block_t block) {
    //创建Timer
    dispatch_source_t timer  = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);//queue是一个专门执行timer回调的GCD队列
    if (timer) {
        //使用dispatch_source_set_timer函数设置timer参数
        dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval*NSEC_PER_SEC), interval*NSEC_PER_SEC, (1ull * NSEC_PER_SEC)/10);
        //设置回调
        dispatch_source_set_event_handler(timer, block);
        //dispatch_source默认是Suspended状态，通过dispatch_resume函数开始它
        dispatch_resume(timer);
    }
    
    return timer;
}

- (void)decryptWarning:(NSString *)msg {
    UIAlertController *alertController = NULL;
    UIAlertAction *action = NULL;
    
    alertController = [UIAlertController alertControllerWithTitle:@"注意" message:msg preferredStyle:UIAlertControllerStyleAlert];
    action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        if (self.presentingViewController) {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}



- (BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
                         
                         
