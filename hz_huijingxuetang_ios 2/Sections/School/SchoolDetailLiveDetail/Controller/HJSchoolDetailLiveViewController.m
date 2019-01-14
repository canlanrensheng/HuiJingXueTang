//
//  HJSchoolDetailLiveViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/26.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSchoolDetailLiveViewController.h"
#import "HJSchoolDetailChatViewController.h"
#import "HJSchoolDetailReviewPastViewController.h"
#import "HJTopSementView.h"

//直播的试图
#import <NELivePlayerFramework/NELivePlayerFramework.h>
#import "NELivePlayerControlView.h"

#import "HJSchoolDetailTeacherInfoView.h"
#import "HJGiftRewardAlertView.h"
#import "HJGiftPayAlertView.h"

#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>
#import <NIMSDK/NIMSDK.h>
//#import <WXApiObject.h>

#import "HJSchoolLiveDetailViewModel.h"

//static NSString *kVideoCover = @"https://upload-images.jianshu.io/upload_images/635942-14593722fe3f0695.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240";

@interface HJSchoolDetailLiveViewController() <NELivePlayerControlViewProtocol,NIMChatManagerDelegate,UIScrollViewDelegate>
{
    dispatch_source_t _timer;
}

@property (nonatomic, strong) NSArray *controllersClass;
@property (nonatomic,assign) NSInteger  selectIndex;
@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIButton *footerView;


@property (nonatomic, strong) UIImageView *containerView;
@property (nonatomic,strong) HJTopSementView *toolView;
@property (nonatomic,strong) HJSchoolDetailTeacherInfoView *teacherInfoView;
@property (nonatomic,strong) UIButton *playBtn;
@property (nonatomic,strong) UIButton *rePlayBtn;
@property (nonatomic,strong) UIButton *playShangButton;
@property (nonatomic,assign) NSInteger payType;

@property(nonatomic,strong) NELivePlayerController *player;   //播放器
@property(nonatomic,strong) UIImageView *playerContainerView;          //播放器包裹视图
@property(nonatomic,strong) NELivePlayerControlView *controlView; //播放器控制视图

//礼物的Id
@property (nonatomic,copy) NSString *goodsid;
//礼物的名称
@property (nonatomic,strong) NSString *giftName;

@property (nonatomic,strong) HJSchoolLiveDetailViewModel *viewModel;

@property (nonatomic,strong) HJSchoolDetailChatViewController *chartVC;
@property (nonatomic,strong) HJSchoolDetailReviewPastViewController *reviewPastVC;

@property (nonatomic,assign) BOOL isFullScreen;

@property (nonatomic,strong) UIView *topView;

@end


@implementation HJSchoolDetailLiveViewController

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
            @weakify(self);
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self);
                [self rewardOperation];
            }];
        }];
    }
    return _playShangButton;
}

//打赏操作
- (void)rewardOperation {
    [YJAPPNetwork GiftTasksuccess:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            if(self.viewModel.liveDetailErrorCode == 29) {
                ShowMessage(@"暂无购买课程或者课程已过期");
                return;
            }
            if([APPUserDataIofo AccessToken].length <= 0) {
                //                            ShowMessage(@"您还未登录");
                [DCURLRouter pushURLString:@"route://loginVC" animated:YES];
                return;
            }
            HJGiftRewardAlertView *alertView = [[HJGiftRewardAlertView alloc] initWithDataArray:[responseObject valueForKey:@"data"]  Block:^(NSDictionary * _Nonnull dict) {
                //支付的信息
                if (dict) {
                    self.goodsid = dict[@"goodsid"];
                    self.giftName = dict[@"goodsname"];
                    HJGiftPayAlertView *payAlertView = [[HJGiftPayAlertView alloc] initWithPrice:[dict valueForKey:@"price"] Block:^(PayType payType) {
                        self.payType = payType;
                        //支付的操作
                        [self AffrimPayAction];
                    }];
                    [payAlertView show];
                }
            }];
            [alertView show];
        }else{
            ShowMessage(responseObject[@"msg"]);
        }
    } failure:^(NSString *error) {
        ShowMessage(error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    self.fd_interactivePopDisabled = NO;
}

//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    [self doDestroyPlayer];
//    [[NIMSDK sharedSDK].chatManager removeDelegate:self];
//}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.controlView.playBtn setSelected:NO];
    [self.player pause];
}

- (void)dealloc {
    [self doDestroyPlayer];
    [[NIMSDK sharedSDK].chatManager removeDelegate:self];
}

- (void)hj_loadData {
    NSString *liveId = self.params[@"liveId"];
    //老师的id获取
    self.viewModel.teacherId = self.params[@"teacherId"];
    self.viewModel.liveId = liveId;
    
    [self.viewModel getLiveDetailDataWithLiveId:liveId Success:^(BOOL successFlag) {
        if(successFlag) {
            self.chartVC.viewModel = self.viewModel;
            self.teacherInfoView.viewModel = self.viewModel;
            //是否是免费的课程
            if(self.viewModel.model.course.coursekind == 1) {
                self.viewModel.isFree = YES;
            }
            //获取老师的ID用于获取往期回顾的数据
            self.viewModel.teacherId = self.viewModel.model.course.userid;
            self.reviewPastVC.viewModel = self.viewModel;
            
            self.controlView.fileTitleLabel.text = self.viewModel.model.course.coursename.length > 0 ? self.viewModel.model.course.coursename : @"暂无直播名称";

            if(self.viewModel.model.room.hlsPullUrl) {
                //初始化播放控制器
                [self.controlView.loadingView startAnimating];
                self.controlView.loadingView.speedTextLabel.hidden = NO;
                [self doInitPlayer];
            
            } else {
                if(self.viewModel.model.course.liveflag == 2) {
                    //往期回顾
                    ShowMessage(@"暂无直播");
                } else if(self.viewModel.model.course.liveflag == 3) {
                    //预告直播
                    ShowMessage(@"直播尚未开始");
                } else {
                    ShowMessage(@"暂无直播");
                }
            }
            NSMutableArray *modelArr = [[TXDataManage shareManage] unarchiveObjectWithFileName:[NSString stringWithFormat:@"WatchedHistoryLive%@",[APPUserDataIofo UserID]]];
            NSMutableArray *marr = [NSMutableArray arrayWithArray:modelArr];
            [marr addObject:self.viewModel.model];
            NSMutableDictionary *marrDict  = [NSMutableDictionary dictionary];
            for (HJLiveDetailModel *model in marr) {
                model.course.date = [NSDate date];
                [marrDict setValue:model forKey:model.course.courseid];
            }
            [[TXDataManage shareManage] archiveObject:marrDict.allValues withFileName:[NSString stringWithFormat:@"WatchedHistoryLive%@",[APPUserDataIofo UserID]]];
        }else {
//            没有购买课程的时候不能分享
         
        }
    }];
}

- (void)hj_bindViewModel {
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"GiftRewardSuccessNoty" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        //礼物打赏成功
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GiftRewardSuccessSendSystemNoty" object:nil userInfo:@{@"giftName" : self.giftName.length > 0 ? self.giftName : @""}];
    }];
    
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"BackToLiveDetailVC" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        //弹起打赏视图
        self.toolView.selectIndex = 0;
        self.selectIndex = 0;
        [self.scrollView setContentOffset:CGPointMake(0, 0)];
        [UIView animateWithDuration:0.25 animations:^{
           [self rewardOperation];
        }];
    }];
}

//设置导航条的属性
- (void)hj_setNavagation {
    if (isFringeScreen) {
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, kTopStatusHeight)];
        topView.backgroundColor = black_color;
        [self.view addSubview:topView];
        self.topView = topView;
    }
    
    _playerContainerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kTopStatusHeight, Screen_Width, kHeight(210))];
    _playerContainerView.image = V_IMAGE(@"占位图-1");
    _playerContainerView.backgroundColor = black_color;
    [self.view addSubview:_playerContainerView];
    
    _controlView = [[NELivePlayerControlView alloc] initWithFrame:CGRectMake(0, kTopStatusHeight, Screen_Width, kHeight(210))];
    _controlView.fileTitle = @"慧鲸学堂";
    _controlView.delegate = self;
    [self.view addSubview:_controlView];
     _controlView.sendChatBtn.hidden = YES;

    @weakify(self);
    [_controlView.backSubject subscribeNext:^(id  _Nullable x) {
        //点击返回的时候进行的操作
        @strongify(self);
        if(self.isFullScreen) {
            [self backVerticalScreen];
        } else {
            [DCURLRouter popViewControllerAnimated:YES];
        }
    }];
    
    [_controlView.shareSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if(self.viewModel.liveDetailErrorCode == 29) {
            ShowMessage(@"暂无购买课程或者课程已过期");
            return;
        }
        //分享进行的操作
        if(self.isFullScreen) {
            [self backVerticalScreen];

            NSString *courceName = self.viewModel.model.course.coursename.length > 0 ? self.viewModel.model.course.coursename : @"慧鲸学堂";
            NSString *coursedes = [NSString stringWithFormat:@"学投资，来慧鲸学堂。ㅣ%@老师ㅣ正在直播《%@》，快来围观吧！",self.viewModel.model.course.realname,self.viewModel.model.course.coursename];
            id shareImg = self.viewModel.model.course.coursepic;
            if(self.viewModel.model.course.coursepic.length <= 0) {
                shareImg = V_IMAGE(@"shareImg");
            }
            NSString *shareUrl = [NSString stringWithFormat:@"%@liveshow?courseid=%@",API_SHAREURL,self.params[@"liveId"]];
            if([APPUserDataIofo UserID].length > 0) {
                shareUrl = [NSString stringWithFormat:@"%@&userid=%@",shareUrl,[APPUserDataIofo UserID]];
            }
            [HJShareTool shareWithTitle:courceName content:coursedes images:@[shareImg] url:shareUrl];
        } else {
            NSString *courceName = self.viewModel.model.course.coursename.length > 0 ? self.viewModel.model.course.coursename : @"慧鲸学堂";
            NSString *coursedes = [NSString stringWithFormat:@"学投资，来慧鲸学堂。ㅣ%@老师ㅣ正在直播《%@》，快来围观吧！",self.viewModel.model.course.realname,self.viewModel.model.course.coursename];
            id shareImg = self.viewModel.model.course.coursepic;
            if(self.viewModel.model.course.coursepic.length <= 0) {
                shareImg = V_IMAGE(@"shareImg");
            }
            
            NSString *shareUrl = [NSString stringWithFormat:@"%@liveshow?courseid=%@",API_SHAREURL,self.params[@"liveId"]];
            if([APPUserDataIofo UserID].length > 0) {
                shareUrl = [NSString stringWithFormat:@"%@&userid=%@",shareUrl,[APPUserDataIofo UserID]];
            }
            
            DLog(@"获取到的分享的链接是:%@",shareUrl);
            [HJShareTool shareWithTitle:courceName content:coursedes images:@[shareImg] url:shareUrl];
        }
    }];

    [_controlView.sendChatSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        //发送消息进行的操作
        [self backVerticalScreen];
        //键盘弹起
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SendChatMessageKeyboardShow" object:nil userInfo:nil];
    }];

    //老师简介的试图创建
    HJSchoolDetailTeacherInfoView *teacherInfoView = [[HJSchoolDetailTeacherInfoView alloc] init];
    teacherInfoView.frame = CGRectMake(0, kHeight(210) + kTopStatusHeight, Screen_Width, kHeight(65));
    [self.view addSubview:teacherInfoView];

    self.teacherInfoView = teacherInfoView;
    
    __weak typeof(self)weakSelf = self;
    HJTopSementView *toolView = [[HJTopSementView alloc] initWithFrame:CGRectMake(0, kHeight(210 + 65) + kTopStatusHeight, Screen_Width, kHeight(40)) titleColor:HEXColor(@"#333333") selectTitleColor:HEXColor(@"#22476B") lineColor:HEXColor(@"#22476B")  buttons:@[@"聊天",@"往期回顾"] block:^(NSInteger index) {
        weakSelf.selectIndex = index;
        [UIView animateWithDuration:0.25 animations:^{
            [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.selectIndex * Screen_Width, 0)];
        }];
        
    }];
    [self.view addSubview:toolView];
    self.toolView = toolView;

    self.controllersClass = @[@"HJSchoolDetailChatViewController",@"HJSchoolDetailReviewPastViewController"];

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kHeight(210 + 40 + 65) + kTopStatusHeight, Screen_Width, Screen_Height - kHeight(210 + 40 + 65) - kTopStatusHeight)];

    scrollView.contentSize = CGSizeMake(Screen_Width * self.controllersClass.count,  Screen_Height - kHeight(210 + 40 + 65) - kTopStatusHeight);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.delegate = self;
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];

    self.scrollView = scrollView;

    for(int i = 0; i < self.controllersClass.count;i++){
        if( i == 0) {
            HJSchoolDetailChatViewController *listVC = [[HJSchoolDetailChatViewController alloc] init];
            listVC.view.frame = CGRectMake(i * Screen_Width, 0, Screen_Width, Screen_Height - kHeight(210 + 40 + 65) - kTopStatusHeight);
            [self addChildViewController:listVC];
            [self.scrollView insertSubview:listVC.view atIndex:200];
            self.chartVC = listVC;

        } else if ( i == 1){
            HJSchoolDetailReviewPastViewController *listVC = [[HJSchoolDetailReviewPastViewController alloc] init];
            listVC.view.frame = CGRectMake(i * Screen_Width, 0, Screen_Width, Screen_Height - kHeight(210 + 40 + 65) - kTopStatusHeight);
            [self addChildViewController:listVC];
            [self.scrollView insertSubview:listVC.view atIndex:200];
            self.reviewPastVC = listVC;
            
            @weakify(self);
            [listVC.careSubject subscribeNext:^(id  _Nullable x) {
                @strongify(self);
                self.teacherInfoView.careSelected = [x boolValue];
            }];
        }
    }

    [self.view addSubview:self.playShangButton];
    [self.playShangButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-kWidth(12));
        make.size.mas_equalTo(CGSizeMake(kWidth(41), kHeight(41)));
        make.bottom.equalTo(self.view).offset(-kHeight(111));
    }];
}

//初始化播放控制器
- (void)doInitPlayer {
    [NELivePlayerController setLogLevel:NELP_LOG_VERBOSE];
    NSLog(@"%@", [NELivePlayerController getSDKVersion]);
    NSError *error = nil;
    
    self.player = [[NELivePlayerController alloc] initWithContentURL:URL(self.viewModel.model.room.hlsPullUrl) error:&error];
    if (self.player == nil) {
        NSLog(@"player initilize failed, please tay again.error = [%@]!", error);
    }
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.player.view.frame = _playerContainerView.bounds;
    [_playerContainerView addSubview:self.player.view];
    
    self.view.autoresizesSubviews = YES;
    
    [self.player setBufferStrategy:NELPLowDelay]; // 直播低延时模式
    
    [self.player setScalingMode:NELPMovieScalingModeNone]; // 设置画面显示模式，默认原始大小
    [self.player setShouldAutoplay:YES]; // 设置prepareToPlay完成后是否自动播放
    [self.player setHardwareDecoder:NO]; // 设置解码模式，是否开启硬件解码
    [self.player setPauseInBackground:NO]; // 设置切入后台时的状态，暂停还是继续播放
    [self.player setPlaybackTimeout:15 *1000]; // 设置拉流超时时间
    
    //准备播放
    [self.player prepareToPlay];
    
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
    
    [self syncUIStatus];
    
    [_player play]; //开始播放
    
    //开
    [_player setRealTimeListenerWithIntervalMS:500 callback:^(NSTimeInterval realTime) {
        NSLog(@"当前时间戳：[%f]", realTime);
    }];
    
    //关
    [_player setRealTimeListenerWithIntervalMS:500 callback:nil];
}

- (void)syncUIStatus {
    _controlView.isPlaying = NO;
    __block NSTimeInterval mDuration = 0;
    __block bool getDurFlag = false;
    __weak typeof(self) weakSelf = self;
    dispatch_queue_t syncUIQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = CreateSyncUITimerN(1.0, syncUIQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!getDurFlag) {
                mDuration = [weakSelf.player duration];
                if (mDuration > 0) {
                    getDurFlag = true;
                }
            }
            weakSelf.controlView.isAllowSeek = (mDuration > 0);
            weakSelf.controlView.duration = mDuration;
            weakSelf.controlView.currentPos = [weakSelf.player currentPlaybackTime];
            weakSelf.controlView.isPlaying = ([weakSelf.player playbackState] == NELPMoviePlaybackStatePlaying);
        });
    });
}

dispatch_source_t CreateSyncUITimerN(double interval, dispatch_queue_t queue, dispatch_block_t block) {
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
        self.controlView.loadingView.speedTextLabel.hidden = YES;
        [self.controlView.loadingView stopAnimating];

    }
    else if (nelpLoadState == NELPMovieLoadStateStalled)
    {
        NSLog(@"begin buffering");
        _controlView.isBuffing = YES;
    }
}

//播放结束或者失败的通知
- (void)NELivePlayerPlayBackFinished:(NSNotification*)notification {
    NSLog(@"[NELivePlayer Demo] 收到 NELivePlayerPlaybackFinishedNotification 通知");
    
    switch ([[[notification userInfo] valueForKey:NELivePlayerPlaybackDidFinishReasonUserInfoKey] intValue])
    {
        case NELPMovieFinishReasonPlaybackEnded:
        {
            self.controlView.loadingView.speedTextLabel.hidden = YES;
            [self.controlView.loadingView stopAnimating];
            if(self.isFullScreen) {
                //全屏的时候播放结束回到竖屏
                [self backVerticalScreen];
                [TXAlertView showAlertWithTitle:nil message:@"直播结束" cancelButtonTitle:nil style:TXAlertViewStyleAlert buttonIndexBlock:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                    }
                } otherButtonTitles:@"确定", nil];
                return;
            }
            [TXAlertView showAlertWithTitle:nil message:@"直播结束" cancelButtonTitle:nil style:TXAlertViewStyleAlert buttonIndexBlock:^(NSInteger buttonIndex) {
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
    self.controlView.loadingView.speedTextLabel.hidden = YES;
    [self.controlView.loadingView stopAnimating];
    _playerContainerView.image = nil;

//    播放成功之后延时两秒之后隐藏是视图
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
- (void)controlViewOnClickPlay:(NELivePlayerControlView *)controlView isPlay:(BOOL)isPlay {
    NSLog(@"[NELivePlayer Demo] 点击播放，当前状态: [%@]", (isPlay ? @"播放" : @"暂停"));
    if(self.viewModel.liveDetailErrorCode == 29) {
        ShowMessage(@"暂无购买课程或者课程已过期");
        return;
    }
    if (isPlay) {
        [self.player play];
    } else {
        [self.player pause];
    }
}

//定位到指定的播放的时间
- (void)controlViewOnClickSeek:(NELivePlayerControlView *)controlView dstTime:(NSTimeInterval)dstTime {
    NSLog(@"[NELivePlayer Demo] 执行seek，目标时间: [%f]", dstTime);
    self.controlView.loadingView.speedTextLabel.hidden = NO;
    [self.controlView.loadingView startAnimating];
    self.player.currentPlaybackTime = dstTime;
}

//静音开关进行的操作
- (void)controlViewOnClickMute:(NELivePlayerControlView *)controlView isMute:(BOOL)isMute{
    NSLog(@"[NELivePlayer Demo] 点击静音，当前状态: [%@]", (isMute ? @"静音开" : @"静音关"));
    [self.player setMute:isMute];
}

//全屏之后点击返回进行的操作
- (void)backVerticalScreen {
    [self controlViewOnClickScale:self.controlView isFill:NO];
}

//点击全屏和竖屏的操作
- (void)controlViewOnClickScale:(NELivePlayerControlView *)controlView isFill:(BOOL)isFill {
    NSLog(@"[NELivePlayer Demo] 点击屏幕缩放，当前状态: [%@]", (isFill ? @"全屏" : @"适应"));
    if (isFill) {
        
        self.teacherInfoView.hidden = YES;
        self.toolView.hidden = YES;
        self.scrollView.hidden = YES;
        self.playShangButton.hidden = YES;
        [self.view endEditing:YES];
        self.isFullScreen = YES;
        [UIApplication sharedApplication].statusBarHidden = YES;
        [self.player setScalingMode:NELPMovieScalingModeAspectFill];

        _playerContainerView.image =  [V_IMAGE(@"占位图-1") rotate:UIImageOrientationRight];
        [UIView animateWithDuration:0.3 animations:^{
            self.player.view.transform = CGAffineTransformMakeRotation(M_PI/2);
            _controlView.transform = CGAffineTransformMakeRotation(M_PI/2);
//            _playerContainerView.transform = CGAffineTransformMakeRotation(M_PI/2);
            _controlView.sendChatBtn.hidden = NO;
            CGRect f = self.player.view.frame;
            f = CGRectMake(0, 0, kW, kH);
            [_playerContainerView setFrame:f];
            _controlView.frame = f;
            self.player.view.frame = _playerContainerView.bounds;
            _controlView.isFull = YES;
        }];
        
    } else {

        self.isFullScreen = NO;
        self.teacherInfoView.hidden = NO;
        self.toolView.hidden = NO;
        self.scrollView.hidden = NO;
        self.playShangButton.hidden = NO;
        
        [UIApplication sharedApplication].statusBarHidden = NO;
        [self.player setScalingMode:NELPMovieScalingModeAspectFit];
        _playerContainerView.image =  V_IMAGE(@"占位图-1");
        [UIView animateWithDuration:0.3 animations:^{
            self.player.view.transform = CGAffineTransformIdentity;
            _controlView.transform = CGAffineTransformIdentity;
            _playerContainerView.transform = CGAffineTransformIdentity;
            _controlView.sendChatBtn.hidden = YES;
            CGRect f = self.player.view.frame;
            f = CGRectMake(0, kTopStatusHeight, kW, kHeight(210));
            _controlView.frame = f;
            [_playerContainerView setFrame:f];
            self.player.view.frame = _playerContainerView.bounds;
            _controlView.isFull = NO;
        }];
    }
}


//打赏的操作
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
            }else if (self.payType == 1){
                //微信支付
                [UserInfoSingleObject shareInstance].payType = WxOrAlipayTypeReward;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = self.view.frame.size.width;
    CGFloat offsetX = scrollView.contentOffset.x;
    //获取索引
    NSInteger scrollIndex = offsetX / width;
    self.selectIndex = scrollIndex;
    self.toolView.selectIndex = scrollIndex;
}


@end


