//
//  HJLiveReviewViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/29.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJLiveReviewViewController.h"

#import "HJSchoolDetailReviewPastViewController.h"
#import "HJLiveReviewSementView.h"

#import "HJSchoolDetailTeacherInfoView.h"
#import "HJGiftRewardAlertView.h"
#import "HJGiftPayAlertView.h"

#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>
//#import <WXApiObject.h>

#import "HJSchoolLiveDetailViewModel.h"
#import "HJSchoolDetailReviewPastCell.h"
#import "HJPastListModel.h"

#import <NELivePlayerFramework/NELivePlayerFramework.h>
#import "NEVideoPlayerControlView.h"
#import <CoreMedia/CMTime.h>

@interface HJLiveReviewViewController()<NEVideoPlayerControlViewProtocol>
{
    dispatch_source_t _timer;
}

@property (nonatomic,strong) UIButton *footerView;

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) HJLiveReviewSementView *toolView;
@property (nonatomic,strong) HJSchoolDetailTeacherInfoView *teacherInfoView;
@property (nonatomic,strong) UIButton *playBtn;

@property (nonatomic,strong) UIButton *rePlayBtn;

@property (nonatomic,strong) UIButton *playShangButton;

@property (nonatomic,assign) NSInteger payType;

//礼物的Id
@property (nonatomic,copy) NSString *goodsid;

@property (nonatomic,strong) HJSchoolLiveDetailViewModel *viewModel;

@property (nonatomic,strong) HJSchoolDetailReviewPastViewController *reviewPastVC;


@property(nonatomic,strong) NELivePlayerController *player;   //播放器
@property(nonatomic,strong) UIImageView *playerContainerView;          //播放器包裹视图
@property(nonatomic,strong) NEVideoPlayerControlView *controlView; //播放器控制视图

@property (nonatomic,assign) BOOL isFullScreen;
@property (nonatomic,copy) NSString *videoUrl;
@property (nonatomic,copy) NSString *videoid;

//课程的名称
@property (nonatomic,copy) NSString *coursename;

@property (nonatomic,copy) NSString *coursedes;


@end


@implementation HJLiveReviewViewController

- (HJSchoolLiveDetailViewModel *)viewModel {
    if (!_viewModel){
        _viewModel = [[HJSchoolLiveDetailViewModel alloc] init];
    }
    return _viewModel;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CGFLOAT_MIN * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    });
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
    self.fd_interactivePopDisabled = YES;
}

- (UIButton *)playShangButton {
    if (!_playShangButton) {
        _playShangButton= [UIButton creatButton:^(UIButton *button) {
            button.ljTitle_font_titleColor_state(@"",H15,white_color,0);
            [button setBackgroundImage:V_IMAGE(@"送礼ICON") forState:UIControlStateNormal];
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                //返回直播页面大赏
                [[NSNotificationCenter defaultCenter] postNotificationName:@"BackToLiveDetailVC" object:nil userInfo:nil];
                [DCURLRouter popViewControllerAnimated:YES];
            }];
        }];
    }
    return _playShangButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //存储上一次播放的时间
    if(self.player.currentPlaybackTime  > 0) {
        NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
        [defa setValue:@(self.player.currentPlaybackTime) forKey:self.viewModel.courseid];
        [defa synchronize];
    }
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    self.fd_interactivePopDisabled = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.controlView.playBtn setSelected:NO];
    [self.player pause];
}

- (void)dealloc {
    [self doDestroyPlayer];
}

//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    [self doDestroyPlayer];
//}

- (void)hj_loadData {
    NSString *liveId = self.params[@"liveId"];
    self.viewModel.teacherId = self.params[@"teacherId"];
    self.viewModel.isFree = [self.params[@"isFree"] boolValue];
    self.coursename = self.params[@"coursename"];
    self.controlView.fileTitleLabel.text = self.coursename.length > 0 ? self.coursename : @"暂无课程名称";
    self.reviewPastVC.viewModel = self.viewModel;
    [self.viewModel getLiveDetailDataWithLiveId:liveId Success:^(BOOL successFlag) {
        self.teacherInfoView.viewModel = self.viewModel;
    }];
    
    NSString *videoUrl = self.params[@"videourl"];
    self.viewModel.videoUrl = videoUrl;
    self.viewModel.courseid = self.params[@"courseid"];
    
    if(videoUrl) {
        self.videoUrl = videoUrl;
        [self playClick:self.playBtn];
    } else {
        ShowMessage(@"播放链接为空");
    }
    
    self.viewModel.tableView = self.tableView;
    self.tableView.mj_footer.hidden = YES;
    self.viewModel.page = 1;
    [self.viewModel getPastCourseListDataWithSuccess:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)hj_refreshData {
    @weakify(self);
    self.tableView.mj_header = [MKRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.viewModel.page = 1;
        self.viewModel.tableView = self.tableView;
        self.tableView.mj_footer.hidden = YES;
        self.viewModel.page = 1;
        [self.viewModel getPastCourseListDataWithSuccess:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
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
            [self.viewModel getPastCourseListDataWithSuccess:^{
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


- (void)hj_setNavagation {
    if(isFringeScreen) {
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, kTopStatusHeight)];
        topView.backgroundColor = black_color;
        [self.view addSubview:topView];
        self.topView = topView;
    }
    
    //背景视图
    _playerContainerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kTopStatusHeight, Screen_Width, kHeight(210))];
    _playerContainerView.backgroundColor = black_color;
    _playerContainerView.image = V_IMAGE(@"占位图-1");
    [self.view addSubview:_playerContainerView];
    
    //控制视图
    _controlView = [[NEVideoPlayerControlView alloc] initWithFrame:CGRectMake(0, kTopStatusHeight, Screen_Width, kHeight(210))];
    _controlView.fileTitle = @"慧鲸学堂";
    _controlView.delegate = self;
    [self.view addSubview:_controlView];
    _controlView.fileName.hidden = YES;
    _controlView.killPriceImageV.hidden = YES;
    
    //播放的按钮
    [_controlView addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_controlView);
    }];
    
    @weakify(self);
    [_controlView.backSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        //点击返回的时候进行的操作
        if(self.isFullScreen) {
            [self backVerticalScreen];
        } else {
            [DCURLRouter popViewControllerAnimated:YES];
        }
    }];
    
    //流量监控弹窗的处理
    [_controlView.keepPlaySubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.controlView.loadingView startAnimating];
        self.controlView.loadingView.speedTextLabel.hidden = NO;
        [self.player setPlayUrl:URL(self.videoUrl)];
        //准备播放
        [self.player prepareToPlay];
        self.controlView.killPriceImageV.hidden = YES;
    }];
    
    [_controlView.shareSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        //分享进行的操作
        if(self.isFullScreen) {
            [self backVerticalScreen];
            [self shareOperation];
        } else {
            [self shareOperation];
        }
    }];
    
    //初始化播放控制器
    [self doInitPlayer];
    
    //老师简介的试图创建
    HJSchoolDetailTeacherInfoView *teacherInfoView = [[HJSchoolDetailTeacherInfoView alloc] init];
    [self.view addSubview:teacherInfoView];
    [teacherInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(kHeight(65));
        make.top.mas_equalTo(kHeight(210) + kTopStatusHeight);
    }];
    [teacherInfoView.careSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        RACSubject *backSubject = self.params[@"subject"];
        if(backSubject) {
            [backSubject sendNext:x];
        }
    }];
    self.teacherInfoView = teacherInfoView;
    
    //工具条的按钮的操作
    HJLiveReviewSementView *toolView = [[HJLiveReviewSementView alloc] init];
    [self.view addSubview:toolView];
    [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(kHeight(40));
        make.top.mas_equalTo(kHeight(210 + 65) + kTopStatusHeight);
    }];
    self.toolView = toolView;
    
    //打赏图片
    if(!MaJia) {
        [self.view addSubview:self.playShangButton];
        [self.playShangButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).offset(-kWidth(12));
            make.size.mas_equalTo(CGSizeMake(kWidth(41), kHeight(41)));
            make.bottom.equalTo(self.view).offset(-kHeight(111));
        }];
    }
    
    [self.tableView registerClassCell:[HJSchoolDetailReviewPastCell class]];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kHeight(210 + 40 + 65) + kTopStatusHeight, 0, 0, 0));
    }];
}

- (void)shareOperation {
    NSString *courceName =  @"慧鲸学堂";
    NSString *coursedes = self.coursename.length > 0 ? self.coursename : @"慧鲸学堂";
    id shareImg = self.videoUrl;
    if(self.videoUrl.length <= 0) {
        shareImg = V_IMAGE(@"shareImg");
    }
    //修改分享的链接 课程详情
    NSString *shareUrl = [NSString stringWithFormat:@"%@courseDetails?selected=2&courseid=%@&userid=%@&type=1",API_SHAREURL,self.viewModel.courseid,[APPUserDataIofo UserID]];
    [HJShareTool shareWithTitle:courceName content:coursedes images:@[shareImg] url:shareUrl];
}

//点击播放播放按钮进行的操作
- (void)playClick:(UIButton *)sender {
    if(self.videoUrl.length <= 0){
        self.controlView.playBtn.selected = !self.controlView.playBtn.selected;
        ShowMessage(@"暂无视频播放");
        return;
    }
    
    //检测流量的弹窗的提示
    if([UserInfoSingleObject shareInstance].networkStatus == ReachableViaWWAN) {
        if(self.viewModel.hasShowedTrafficMonitoringView == NO) {
            [TXAlertView showAlertWithTitle:@"温馨提示" message:@"当前为非WiFi环境，确定继续播放?" cancelButtonTitle:@"取消" style:TXAlertViewStyleAlert buttonIndexBlock:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [self.controlView.loadingView startAnimating];
                    self.controlView.loadingView.speedTextLabel.hidden = NO;
                    [self.player setPlayUrl:URL(self.videoUrl)];
                    //准备播放
                    [self.player prepareToPlay];
                    self.controlView.killPriceImageV.hidden = YES;
                    
                    sender.hidden = YES;
                }
            } otherButtonTitles:@"确定", nil];
            self.viewModel.hasShowedTrafficMonitoringView = YES;
            return;
        }
    }
    
    self.controlView.fileTitleLabel.text = self.coursename.length > 0 ? self.coursename : @"暂无课程名称";
    self.controlView.loadingView.speedTextLabel.hidden = NO;
    [self.controlView.loadingView startAnimating];
    [self.player setPlayUrl:URL(self.videoUrl)];
    //准备播放
    [self.player prepareToPlay];
}

//初始化播放控制器
- (void)doInitPlayer {
    if(self.player) {
        [self doDestroyPlayer];
    }
    [NELivePlayerController setLogLevel:NELP_LOG_VERBOSE];
    NSLog(@"%@", [NELivePlayerController getSDKVersion]);
    NSError *error = nil;
    self.player = [[NELivePlayerController alloc] init];
    if (self.player == nil) {
        NSLog(@"player initilize failed, please tay again.error = [%@]!", error);
    }
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.player.view.frame = _playerContainerView.bounds;
    [_playerContainerView addSubview:self.player.view];
    
    self.view.autoresizesSubviews = YES;
    
    [self.player setBufferStrategy:NELPAntiJitter]; // 直播低延时模式
    
    [self.player setScalingMode:NELPMovieScalingModeNone]; // 设置画面显示模式，默认原始大小
    [self.player setShouldAutoplay:YES]; // 设置prepareToPlay完成后是否自动播放
    [self.player setHardwareDecoder:NO]; // 设置解码模式，是否开启硬件解码
    [self.player setPauseInBackground:NO]; // 设置切入后台时的状态，暂停还是继续播放
    [self.player setPlaybackTimeout:15 *1000]; // 设置拉流超时时间
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerDidPreparedToPlay:)
                                                 name:NELivePlayerDidPreparedToPlayNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerPlaybackStateChanged:)
                                                 name:NELivePlayerPlaybackStateChangedNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NeLivePlayerloadStateChanged:)
                                                 name:NELivePlayerLoadStateChangedNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerPlayBackFinished:)
                                                 name:NELivePlayerPlaybackFinishedNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerFirstVideoDisplayed:)
                                                 name:NELivePlayerFirstVideoDisplayedNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerFirstAudioDisplayed:)
                                                 name:NELivePlayerFirstAudioDisplayedNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerReleaseSuccess:)
                                                 name:NELivePlayerReleaseSueecssNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerVideoParseError:)
                                                 name:NELivePlayerVideoParseErrorNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerSeekComplete:)
                                                 name:NELivePlayerMoviePlayerSeekCompletedNotification
                                               object:_player];
}

- (void)doDestroyPlayer {
    [self.player shutdown]; // 退出播放并释放相关资源
    [self.player.view removeFromSuperview];
    self.player = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 播放器通知事件
- (void)NELivePlayerDidPreparedToPlay:(NSNotification*)notification {
    //add some methods
    NSLog(@"[NELivePlayer Demo] 收到 NELivePlayerDidPreparedToPlayNotification 通知");
    
    //获取视频信息，主要是为了告诉界面的可视范围，方便字幕显示
    NELPVideoInfo info;
    memset(&info, 0, sizeof(NELPVideoInfo));
    [_player getVideoInfo:&info];
    _controlView.videoResolution = CGSizeMake(info.width, info.height);
    
    //记录上一次播放的时间
    NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
    NSString *lastPlayTime = [defa valueForKey:self.viewModel.courseid];
    if(lastPlayTime.floatValue > 0) {
        self.player.currentPlaybackTime = lastPlayTime.floatValue;
    }
    
    [self syncUIStatus];
    
    [_player play]; //开始播放
    
    //开
    [_player setRealTimeListenerWithIntervalMS:500 callback:^(NSTimeInterval realTime) {
        NSLog(@"当前时间戳：[%f]", realTime);
    }];
    
    //关
    [_player setRealTimeListenerWithIntervalMS:500 callback:nil];

}

////记录播放存为历史的播放
//- (void)memoryHistoryVideo {
//    HJCourseSelectJiModel *model = [[HJCourseSelectJiModel alloc] init];
//    model.totalTime = self.player.duration;
//    model.date = [NSDate date];
//    model.courseid = self.viewModel.courseid;
//    model.videoname = self.coursename;
//    model.videoppicurl = self.videoUrl;
//    //老师的名称
//    model.realName = self.viewModel.model.course.realname;
//
//    NSMutableArray *modelArr = [[TXDataManage shareManage] unarchiveObjectWithFileName:[NSString stringWithFormat:@"WatchedVideo%@",[APPUserDataIofo UserID]]];
//    NSMutableArray *marr = [NSMutableArray arrayWithArray:modelArr];
//    [marr addObject:model];
//    
//    NSMutableDictionary *marrDict  = [NSMutableDictionary dictionary];
//    //排重
//    for (HJCourseSelectJiModel *model in marr) {
//        [marrDict setValue:model forKey:model.courseid];
//    }
//    [[TXDataManage shareManage] archiveObject:marrDict.allValues withFileName:[NSString stringWithFormat:@"WatchedVideo%@",[APPUserDataIofo UserID]]];
//
//}

- (void)syncUIStatus {
    _controlView.isPlaying = NO;
    __block NSTimeInterval mDuration = 0;
    __block bool getDurFlag = false;
    __weak typeof(self) weakSelf = self;
    dispatch_queue_t syncUIQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = CreateLiveReviewSyncUITimerN(1.0, syncUIQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!getDurFlag) {
                mDuration = [weakSelf.player duration];
                if (mDuration > 0) {
                    getDurFlag = true;
                }
            }
            weakSelf.controlView.isAllowSeek = YES;
            weakSelf.controlView.duration = mDuration;
            weakSelf.controlView.currentPos = weakSelf.player.currentPlaybackTime;
            weakSelf.controlView.isPlaying = ([weakSelf.player playbackState] == NELPMoviePlaybackStatePlaying);
        });
    });
}

dispatch_source_t CreateLiveReviewSyncUITimerN(double interval, dispatch_queue_t queue, dispatch_block_t block) {
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

- (void)NELivePlayerPlaybackStateChanged:(NSNotification*)notification {
    NSLog(@"[NELivePlayer Demo] 收到 NELivePlayerPlaybackStateChangedNotification 通知");
}

- (void)NeLivePlayerloadStateChanged:(NSNotification*)notification {
    NSLog(@"[NELivePlayer Demo] 收到 NELivePlayerLoadStateChangedNotification 通知");
    
    NELPMovieLoadState nelpLoadState = _player.loadState;
    
    if (nelpLoadState == NELPMovieLoadStatePlaythroughOK)
    {
        NSLog(@"finish buffering");
        _controlView.isBuffing = NO;
        //        [self.controlView.loadingView stopAnimating];
    }
    else if (nelpLoadState == NELPMovieLoadStateStalled)
    {
        NSLog(@"begin buffering");
        _controlView.isBuffing = YES;
        //        [self.controlView.loadingView startAnimating];
    }
}

//播放结束或者失败的通知
- (void)NELivePlayerPlayBackFinished:(NSNotification*)notification {
    NSLog(@"[NELivePlayer Demo] 收到 NELivePlayerPlaybackFinishedNotification 通知");
    switch ([[[notification userInfo] valueForKey:NELivePlayerPlaybackDidFinishReasonUserInfoKey] intValue])
    {
        case NELPMovieFinishReasonPlaybackEnded:
        {
            if(self.isFullScreen) {
                //全屏的时候播放结束回到竖屏
                [self backVerticalScreen];
                [TXAlertView showAlertWithTitle:nil message:@"视频播放结束" cancelButtonTitle:nil style:TXAlertViewStyleAlert buttonIndexBlock:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        
                    }
                } otherButtonTitles:@"确定", nil];
                return;
            }
            [TXAlertView showAlertWithTitle:nil message:@"视频播放结束" cancelButtonTitle:nil style:TXAlertViewStyleAlert buttonIndexBlock:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    
                }
            } otherButtonTitles:@"确定", nil];
            break;
        }
        case NELPMovieFinishReasonPlaybackError:
        {
            self.controlView.loadingView.speedTextLabel.hidden = YES;
            [self.controlView.loadingView stopAnimating];
            ShowMessage(@"播放失败");
            break;
        }
            
        case NELPMovieFinishReasonUserExited:
            break;
            
        default:
            break;
    }
}

- (void)NELivePlayerFirstVideoDisplayed:(NSNotification*)notification {
    NSLog(@"[NELivePlayer Demo] 收到 NELivePlayerFirstVideoDisplayedNotification 通知");
    [self.controlView sd_setImageWithURL:nil placeholderImage:nil];
    self.controlView.loadingView.speedTextLabel.hidden = YES;
    [self.controlView.loadingView stopAnimating];
    _playerContainerView.image = nil;
    
    //播放成功之后延时两秒之后隐藏是视图
    double delayInSeconds = 2.0;
    __weak typeof(self)weakSelf = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.controlView controlOverlayHide];
    });
}

- (void)NELivePlayerFirstAudioDisplayed:(NSNotification*)notification {
    NSLog(@"[NELivePlayer Demo] 收到 NELivePlayerFirstAudioDisplayedNotification 通知");
}

- (void)NELivePlayerVideoParseError:(NSNotification*)notification {
    NSLog(@"[NELivePlayer Demo] 收到 NELivePlayerVideoParseError 通知");
}

- (void)NELivePlayerSeekComplete:(NSNotification*)notification {
    self.controlView.loadingView.speedTextLabel.hidden = YES;
    [self.controlView.loadingView stopAnimating];
    NSLog(@"[NELivePlayer Demo] 收到 NELivePlayerMoviePlayerSeekCompletedNotification 通知");
}

- (void)NELivePlayerReleaseSuccess:(NSNotification*)notification {
    NSLog(@"[NELivePlayer Demo] 收到 NELivePlayerReleaseSueecssNotification 通知");
}

#pragma mark - 控制页面的事件
//点击播放进行的操作
- (void)controlViewOnClickPlay:(NEVideoPlayerControlView *)controlView isPlay:(BOOL)isPlay {
    NSLog(@"[NELivePlayer Demo] 点击播放，当前状态: [%@]", (isPlay ? @"播放" : @"暂停"));
    if (isPlay) {
        if(self.playBtn.hidden == NO) {
            [self playClick:self.playBtn];
        } else{
            [self.player play];
        }
    } else {
        self.controlView.loadingView.speedTextLabel.hidden = YES;
        [self.controlView.loadingView stopAnimating];
        [self.player pause];
    }
}

//定位到指定的播放的时间
- (void)controlViewOnClickSeek:(NEVideoPlayerControlView *)controlView dstTime:(NSTimeInterval)dstTime {
    NSLog(@"[NELivePlayer Demo] 执行seek，目标时间: [%f]", dstTime);
    self.controlView.loadingView.speedTextLabel.hidden = NO;
    [self.controlView.loadingView startAnimating];
    
    self.player.currentPlaybackTime = dstTime;
}

//静音开关进行的操作
- (void)controlViewOnClickMute:(NEVideoPlayerControlView *)controlView isMute:(BOOL)isMute{
    NSLog(@"[NELivePlayer Demo] 点击静音，当前状态: [%@]", (isMute ? @"静音开" : @"静音关"));
    [self.player setMute:isMute];
}

//全屏之后点击返回进行的操作
- (void)backVerticalScreen {
    [self controlViewOnClickScale:self.controlView isFill:NO];
}

//点击全屏和竖屏的操作
- (void)controlViewOnClickScale:(NEVideoPlayerControlView *)controlView isFill:(BOOL)isFill {
    DLog(@"[NELivePlayer Demo] 点击屏幕缩放，当前状态: [%@]", (isFill ? @"全屏" : @"适应"));
    if (isFill) {
        self.isFullScreen = YES;
        [UIApplication sharedApplication].statusBarHidden = YES;
        self.toolView.hidden = YES;
        self.tableView.hidden = YES;
        _controlView.fileName.hidden = NO;
        self.playShangButton.hidden = YES;
        self.teacherInfoView.hidden = YES;
        _playerContainerView.image =  [V_IMAGE(@"占位图-1") rotate:UIImageOrientationRight];
        [self.player setScalingMode:NELPMovieScalingModeAspectFill];
        [UIView animateWithDuration:0.3 animations:^{
            [_playerContainerView setFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
            self.player.view.transform = CGAffineTransformMakeRotation(M_PI/2);
            _controlView.transform = CGAffineTransformMakeRotation(M_PI/2);
            CGRect f = self.player.view.frame;
            f = CGRectMake(0, 0, kW, kH);
            _controlView.frame = f;
            self.player.view.frame = f;
            _controlView.isFull = YES;
        }];
    } else {
        
        self.isFullScreen = NO;
        self.toolView.hidden = NO;
        self.tableView.hidden = NO;
        
        [UIApplication sharedApplication].statusBarHidden = NO;
        [self.player setScalingMode:NELPMovieScalingModeAspectFit];
        _playerContainerView.image =  V_IMAGE(@"占位图-1");
        [UIView animateWithDuration:0.3 animations:^{
            [_playerContainerView setFrame:CGRectMake(0, kTopStatusHeight, Screen_Width, kHeight(210))];
            self.player.view.transform = CGAffineTransformIdentity;
            _controlView.transform = CGAffineTransformIdentity;
            CGRect f = self.player.view.frame;
            f = CGRectMake(0, kTopStatusHeight, kW, kHeight(210));
            _controlView.frame = f;
            self.player.view.frame = _playerContainerView.bounds;
            _controlView.isFull = NO;
            
            _controlView.fileName.hidden = NO;
            self.playShangButton.hidden = NO;
            self.teacherInfoView.hidden = NO;
        }];
    }
}

- (void)AffrimPayAction{
    NSString *paytypestr;
    if (self.payType == 1) {
        paytypestr = @"wxpay";
    }else{
        paytypestr = @"alipay";
    }
    [YJAPPNetwork GifePayAccesstoken:[APPUserDataIofo AccessToken] Id:self.goodsid count:@"1" remark:@"" paytype:paytypestr success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 200) {
            if (self.payType == 0) {
                //支付宝支付
                [UserInfoSingleObject shareInstance].payType = WxOrAlipayTypeReward;
                NSString *orderdata = [responseObject objectForKey:@"data"];
                [self alipay:orderdata];
            } else {
                [UserInfoSingleObject shareInstance].payType = WxOrAlipayTypeReward;
                //微信支付
                NSDictionary *dic = [responseObject objectForKey:@"data"];
                //                //调起微信支付
                //                //需要创建这个支付对象
                PayReq *req   = [[PayReq alloc] init];
                //                //由用户微信号和AppID组成的唯一标识，用于校验微信用户
                req.openID =  [dic objectForKey:@"appid"];
                //                // 商家id，在注册的时候给的
                req.partnerId = [dic objectForKey:@"partnerid"];
                //                // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
                req.prepayId  = [dic objectForKey:@"prepayid"];
                //                // 根据财付通文档填写的数据和签名
                req.package  = [dic objectForKey:@"package"];
                //                // 随机编码，为了防止重复的，在后台生成
                req.nonceStr  = [dic objectForKey:@"noncestr"];
                //                // 这个是时间戳，也是在后台生成的，为了验证支付的
                NSString * stamp = [dic objectForKey:@"timestamp"];
                req.timeStamp = stamp.intValue;
                //                // 这个签名也是后台做的
                req.sign = [dic objectForKey:@"sign"];
                //发送请求到微信，等待微信返回onResp
                [WXApi sendReq:req];
            }
        }else{
            //            [ConventionJudge NetCode:code vc:vc type:@"1"];
        }
    } failure:^(NSString *error) {
        ShowMessage(netError);
    }];
    
}

//支付宝
- (void)alipay:(NSString *)orderStr{
    //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
    NSString *appScheme = @"alipay9815485a129";
    NSString * orderString = orderStr;
    // NOTE: 调用支付结果开始支付
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        DLog(@"reslut = %@",resultDic);
        NSString * memo = resultDic[@"memo"];
        DLog(@"===memo:%@", memo);
        if ([resultDic[@"ResultStatus"] isEqualToString:@"9000"]) {
            //支付成功回调
            ShowMessage(@"支付成功");
        } else {
            ShowMessage(memo);
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  kHeight(48.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.pastListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HJSchoolDetailReviewPastCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJSchoolDetailReviewPastCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = HEXColor(@"#EAEAEA");
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = RGBA(255, 255, 255, 0.5);
    if (indexPath.row < self.viewModel.pastListArray.count) {
        [cell setViewModel:self.viewModel indexPath:indexPath];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.viewModel.pastListArray.count) {
        kRepeatClickTime(1.0);
        HJPastListModel *model = self.viewModel.pastListArray[indexPath.row];
        [self.tableView reloadData];
        [self doInitPlayer];
        self.coursename = model.coursename;
        self.videoUrl = model.videourl;
        self.viewModel.courseid = model.courseid;
        self.controlView.fileTitleLabel.text = model.coursename.length > 0 ? model.coursename : @"暂无课程名称";
        [self playClick:self.playBtn];
        
        //存储上一次播放的时间
        if(self.player.currentPlaybackTime  > 0) {
            NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
            [defa setValue:@(self.player.currentPlaybackTime) forKey:self.viewModel.courseid];
            [defa synchronize];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001f;
}

@end



