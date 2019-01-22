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
#import "HJTopSementView.h"
#import "HJClassDetailTitleView.h"

#import "HJClassDetailViewModel.h"

#import <NELivePlayerFramework/NELivePlayerFramework.h>
#import "NEVideoPlayerControlView.h"

#import <CoreMedia/CMTime.h>
#import "HJCourseSelectJiModel.h"

@interface HJClassDetailViewController() <NEVideoPlayerControlViewProtocol,UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *controllersClass;
@property (nonatomic,assign) NSInteger  selectIndex;
@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIButton *footerView;


@property (nonatomic,strong) HJTopSementView *toolView;
@property (nonatomic,strong) HJClassDetailTitleView *titleView;
@property (nonatomic,strong) UIButton *playBtn;



@property (nonatomic,strong) HJClassDetailViewModel *viewModel;
@property (nonatomic,strong) HJBaseClassDetailViewController *baseClassDetailVC;
@property (nonatomic,strong) HJBaseSelectJiViewController *selectJiVC;
@property (nonatomic,strong) HJBaseEvaluationViewController *evaluationVC;

@property (nonatomic,strong) UIButton *shareBtn;

@property(nonatomic,strong) NELivePlayerController *player;   //播放器
@property(nonatomic,strong) UIImageView *playerContainerView;          //播放器包裹视图
@property(nonatomic,strong) NEVideoPlayerControlView *controlView; //播放器控制视图

@property (nonatomic,assign) BOOL isFullScreen;

//当前播放的视频Id
@property (nonatomic,copy) NSString *videoid;
@property (nonatomic,strong) HJCourseSelectJiModel *model;
@property (nonatomic,copy) NSString *videoUrl;

//遮罩视图
@property (nonatomic,strong) UIView *coverView;
//点击试看视图
@property (nonatomic,strong) UILabel *tryToWatchLabel;


@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) NSTimer *timer;

//进入购物车的按钮
@property (nonatomic,strong) UIButton *goInShopCarBtn;
//购物车的数量
@property (nonatomic,strong) UILabel *redBotLabel;


@end


@implementation HJClassDetailViewController

- (HJClassDetailViewModel *)viewModel {
    if(!_viewModel){
        _viewModel = [[HJClassDetailViewModel alloc] init];
    }
    return _viewModel;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.timer setFireDate:[NSDate distantPast]];
    
    [self.viewModel.loadingView startAnimating];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CGFLOAT_MIN * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    });
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
    self.fd_interactivePopDisabled = YES;
    
    if(!MaJia){
        //加载消息红点的数量
        [self loadShopCarMessageCountData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.controlView.playBtn setSelected:NO];
    [self.player pause];
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)dealloc {
    [self doDestroyPlayer];
    [self.timer setFireDate:[NSDate distantFuture]];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //存储上一次播放的时间
    if(self.player.currentPlaybackTime  > 0) {
        NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
        [defa setValue:@(self.player.currentPlaybackTime) forKey:self.model.courseid];
        [defa synchronize];
    }
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    self.fd_interactivePopDisabled = NO;
}

//加载购物车消息的红点的数量
- (void)loadShopCarMessageCountData {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/myshopcat",API_BASEURL];
    NSDictionary *parameters = nil;
    parameters = @{
                   @"accesstoken" : [APPUserDataIofo AccessToken],
                   @"page" : @"1"
                   };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __weak typeof(self)weakSelf = self;
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            DLog(@"获取到的购物车的数据是:%@",[NSString convertToJsonData:dic]);
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSDictionary *dataDict = dic[@"data"];
                NSArray *courseListArr = dataDict[@"cartlist"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(courseListArr.count > 0) {
                        weakSelf.redBotLabel.hidden = NO;
                        weakSelf.redBotLabel.text = [NSString stringWithFormat:@"%ld",(long)courseListArr.count];
                    } else {
                        weakSelf.redBotLabel.hidden = YES;
                    }
                });
            } else {
                ShowError([dic objectForKey:@"msg"]);
            }
        } fail:^(id error) {
            hideHud();
            ShowError(error);
        }];
    });
}

//加载课程详情的数据
- (void)hj_loadData {
    if(MaJia) {
        //领取免费课程
        NSString *courseId = self.params[@"courseId"];
        __weak typeof(self)weakSelf = self;
        [self.viewModel createFreeCourseOrderWithCourseId:courseId Success:^(BOOL succcessFlag) {
//            if(succcessFlag){
                NSString *courseId = self.params[@"courseId"];
                self.viewModel.courseId = courseId;
                [weakSelf.viewModel.loadingView startAnimating];
                [self.viewModel getCourceDetailWithCourseid:courseId Success:^(BOOL successFlag) {
                    weakSelf.viewModel.model.buy = @"y";
                    [weakSelf.viewModel.loadingView stopLoadingView];
                    [weakSelf.controlView sd_setImageWithURL:URL(weakSelf.viewModel.model.coursepic) placeholderImage:V_IMAGE(@"占位图-1") options:SDWebImageRefreshCached];
                    weakSelf.baseClassDetailVC.viewModel = weakSelf.viewModel;
                    weakSelf.selectJiVC.viewModel = weakSelf.viewModel;
                    weakSelf.evaluationVC.viewModel = weakSelf.viewModel;
                    //处理显示隐藏的部分
                    [weakSelf dealViewShowOrHidden];
                    weakSelf.titleView.titleTextLabel.text = weakSelf.viewModel.model.coursename;
                }];
//            } else {
//                [weakSelf.viewModel.loadingView stopLoadingView];
//            }
        }];
        return;
    } else {
        NSString *courseId = self.params[@"courseId"];
        self.viewModel.courseId = courseId;
        __weak typeof(self)weakSelf = self;
        [self.viewModel getCourceDetailWithCourseid:courseId Success:^(BOOL successFlag) {
            [weakSelf.viewModel.loadingView stopLoadingView];
            [weakSelf.controlView sd_setImageWithURL:URL(weakSelf.viewModel.model.coursepic) placeholderImage:V_IMAGE(@"占位图-1") options:SDWebImageRefreshCached];
            weakSelf.baseClassDetailVC.viewModel = weakSelf.viewModel;
            weakSelf.selectJiVC.viewModel = weakSelf.viewModel;
            weakSelf.evaluationVC.viewModel = weakSelf.viewModel;
            weakSelf.titleView.titleTextLabel.text = weakSelf.viewModel.model.coursename;
            //处理显示隐藏的部分
            [weakSelf dealViewShowOrHidden];
        }];
    }
}

- (void)hj_setNavagation {
    if(isFringeScreen) {
        //适配全面屏 自定义状态栏的视图
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, kTopStatusHeight)];
        topView.backgroundColor = black_color;
        [self.view addSubview:topView];
        self.topView = topView;
    }
   
    //播放器背景视图
    _playerContainerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kTopStatusHeight, Screen_Width, kHeight(210))];
    _playerContainerView.image = V_IMAGE(@"占位图-1");
    _playerContainerView.backgroundColor = black_color;
    [self.view addSubview:_playerContainerView];

    //播放器控制视图
    _controlView = [[NEVideoPlayerControlView alloc] initWithFrame:CGRectMake(0, kTopStatusHeight, Screen_Width, kHeight(210))];
    _controlView.fileTitle = @"慧鲸学堂";
    _controlView.delegate = self;
    [self.view addSubview:_controlView];
    _controlView.fileName.hidden = YES;

    //添加播放按钮
    [_controlView addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_controlView);
    }];
    
    //添加付费课程点击试看视图
    _tryToWatchLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"点击试看",MediumFont(font(15)),white_color);
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [_controlView addSubview:_tryToWatchLabel];
    [_tryToWatchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_controlView);
        make.top.equalTo(self.playBtn.mas_bottom).offset(kWidth(12.0));
        make.height.mas_equalTo(kHeight(15.0));
    }];
    _tryToWatchLabel.hidden = YES;

    //点击返回的操作
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

    //点击流量弹窗的操作
    [_controlView.keepPlaySubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.controlView.loadingView startAnimating];
        self.controlView.loadingView.speedTextLabel.hidden = NO;
        [self.player setPlayUrl:URL(self.videoUrl)];
        //准备播放
        [self.player prepareToPlay];
//        self.controlView.killPriceImageV.hidden = YES;
    }];

    //点击分享的处理
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

    //初始化播放控制器参数
    [self doInitPlayer];

    //课程名称和限时秒杀的倒计时视图
    HJClassDetailTitleView *titleView = [[HJClassDetailTitleView alloc] init];
    [self.view addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(kHeight(55));
        make.top.mas_equalTo(kHeight(210) + kTopStatusHeight);
    }];
    self.titleView = titleView;

    //详情 选集 评价的插板视图
    __weak typeof(self)weakSelf = self;
    HJTopSementView *toolView = [[HJTopSementView alloc] initWithFrame:CGRectMake(0, kHeight(210 + 65) + kTopStatusHeight, Screen_Width, kHeight(40)) titleColor:HEXColor(@"#333333") selectTitleColor:HEXColor(@"#22476B") lineColor:HEXColor(@"#22476B")  buttons:@[@"详情",@"选集",@"评价"] block:^(NSInteger index) {
        weakSelf.selectIndex = index;
        [UIView animateWithDuration:0.25 animations:^{
            [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.selectIndex * Screen_Width, 0)];
        }];

    }];
    [self.view addSubview:toolView];
    [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(kHeight(40));
        make.top.mas_equalTo(kHeight(210 + 55) + kTopStatusHeight);
    }];
    self.toolView = toolView;

    //子控制器的配置
    self.controllersClass = @[@"HJBaseClassDetailViewController",@"HJBaseSelectJiViewController",@"HJBaseEvaluationViewController"];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kHeight(305) + kTopStatusHeight , Screen_Width, Screen_Height - kHeight(305) - kTopStatusHeight)];
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(Screen_Width * self.controllersClass.count,  Screen_Height - kHeight(305) - kTopStatusHeight);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.delegate = self;
    scrollView.bounces = NO;

    [self.view addSubview:scrollView];
    self.scrollView = scrollView;

    for(int i = 0; i < self.controllersClass.count;i++){
        if( i == 0) {
            //课程详情
            HJBaseClassDetailViewController *baseClassDetailVC = [[HJBaseClassDetailViewController alloc] init];
            baseClassDetailVC.view.frame = CGRectMake(i * Screen_Width, 0, Screen_Width, Screen_Height - kHeight(305) - kTopStatusHeight);
            [self addChildViewController:baseClassDetailVC];
            [self.scrollView addSubview:baseClassDetailVC.view];
            self.baseClassDetailVC = baseClassDetailVC;

            //免费领取的之后刷新页面的操作 调整视图 去掉免费领取的按钮
            @weakify(self);
            RACSubject *backSub = [[RACSubject alloc] init];
            [backSub subscribeNext:^(id x) {
                @strongify(self);
                [self.timer invalidate];
                self.timer = nil;
                [self hj_loadData];
            }];
            baseClassDetailVC.courseMessageSubject = backSub;
        }
        else if (i == 1) {
            //课程选集
            HJBaseSelectJiViewController *listVC = [[HJBaseSelectJiViewController alloc] init];
            listVC.view.frame = CGRectMake(i * Screen_Width, 0, Screen_Width, Screen_Height - kHeight(305) - kTopStatusHeight);
            [self addChildViewController:listVC];

            //点击选集的时候进行的操作
            RACSubject *backSub = [[RACSubject alloc] init];
            @weakify(self);
            [backSub subscribeNext:^(HJCourseSelectJiModel * model) {
                @strongify(self);
                [self.player pause];
                [self.timer setFireDate:[NSDate distantFuture]];
                [self.timer invalidate];
                self.timer = nil;

                [self doInitPlayer];
                
                self.model = model;
                self.videoUrl = model.videourl;
                NSString *videoName = model.videoname;
                self.videoid = model.videoid;
//                self.titleView.titleTextLabel.text = videoName;
                self.controlView.fileTitleLabel.text = model.videoname.length > 0 ? model.videoname : @"暂无课程名称";
                [self playClick:self.playBtn];
                
            }];

            RACSubject *selectJiSub = [[RACSubject alloc] init];
            [selectJiSub subscribeNext:^(id x) {
                @strongify(self);
                [self hj_loadData];
            }];
            listVC.backSub = backSub;
            listVC.selectJiSubject = selectJiSub;
            [self.scrollView addSubview:listVC.view];
            self.selectJiVC = listVC;

        } else {
            //课程评价
            HJBaseEvaluationViewController *listVC = [[HJBaseEvaluationViewController alloc] init];
            listVC.view.frame = CGRectMake(i * Screen_Width, 0, Screen_Width, Screen_Height - kHeight(305) -kTopStatusHeight );
            [self addChildViewController:listVC];
            [self.scrollView addSubview:listVC.view];
            self.evaluationVC = listVC;

            RACSubject *evaluationSub = [[RACSubject alloc] init];
            @strongify(self);
            [evaluationSub subscribeNext:^(id x) {
                @strongify(self);
                [self hj_loadData];
            }];
            listVC.evaluationSubject = evaluationSub;
        }
    }

    //添加进入购物车
    if(!MaJia) {
        [self.goInShopCarBtn setFrame:CGRectMake(Screen_Width - kWidth(14.0) - kWidth(46.0), Screen_Height - KHomeIndicatorHeight - kHeight(122 + 49.0), kWidth(46.0), kHeight(46.0))];
        [self.view addSubview:self.goInShopCarBtn];
        
//        [self.goInShopCarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.view).offset(-kWidth(14.0));
//            make.size.mas_equalTo(CGSizeMake(kWidth(46.0), kHeight(46.0)));
//            make.bottom.equalTo(self.view).offset(-kHeight(122 + 49.0));
//        }];
    }
    
}

//点击分享进行的操作
- (void)shareOperation {
    NSString *courceName = self.model.videoname.length > 0 ? self.model.videoname : @"慧鲸学堂";
    NSString *coursedes = self.viewModel.model.coursedes.length > 0 ? self.viewModel.model.coursedes : @"慧鲸学堂";
    id shareImg = self.viewModel.model.coursepic;
    if(self.viewModel.model.coursepic.length <= 0) {
        shareImg = V_IMAGE(@"shareImg");
    }
    //免费的课程
    if (self.viewModel.model.courselimit == 1) {
        //修改分享的链接 课程详情
        NSString *shareUrl = [NSString stringWithFormat:@"%@courseDetails?selected=2&courseid=%@&userid=%@&type=1",API_SHAREURL,self.viewModel.model.courseid,[APPUserDataIofo UserID]];
        [HJShareTool shareWithTitle:courceName content:coursedes images:@[shareImg] url:shareUrl];
    } else {
        //付费的课程
        if(self.viewModel.model.canpromote == 0){
            //课程详情
            NSString *shareUrl = [NSString stringWithFormat:@"%@courseDetails?selected=2&courseid=%@&userid=%@&type=1",API_SHAREURL,self.viewModel.model.courseid,[APPUserDataIofo UserID]];
            [HJShareTool shareWithTitle:courceName content:coursedes images:@[shareImg] url:shareUrl];
        } else {
            //推广赚钱
            NSString *shareUrl = [NSString stringWithFormat:@"%@courseDetails?selected=2&courseid=%@&userid=%@&type=2",API_SHAREURL,self.viewModel.model.courseid,[APPUserDataIofo UserID]];
            [HJShareTool shareWithTitle:courceName content:coursedes images:@[shareImg] url:shareUrl];
        }
    }
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

//点击播放播放按钮进行的操作
- (void)playClick:(UIButton *)sender {
    if([self.viewModel.model.buy isEqualToString:@"n"]) {
        //点击试看2分钟
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
                        sender.hidden = YES;
                        self.tryToWatchLabel.hidden = YES;
                    }
                } otherButtonTitles:@"确定", nil];
                self.viewModel.hasShowedTrafficMonitoringView = YES;
                return;
            }
        }
        
        [self.controlView.loadingView startAnimating];
        self.controlView.loadingView.speedTextLabel.hidden = NO;
        [self.player setPlayUrl:URL(self.videoUrl)];
        //准备播放
        [self.player prepareToPlay];
        sender.hidden = YES;
        self.tryToWatchLabel.hidden = YES;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ModifySlectJiFistDataStatus" object:nil userInfo:nil];
    } else {
        if(self.videoUrl.length <= 0){
            self.controlView.playBtn.selected = NO;
            ShowMessage(@"暂无视频播放");
            return;
        }
        sender.hidden = YES;
        //检测流量的弹窗的提示
        if([UserInfoSingleObject shareInstance].networkStatus == ReachableViaWWAN) {
            if(self.viewModel.hasShowedTrafficMonitoringView == NO) {
                self.controlView.trafficMonitoringView.hidden = NO;
                self.viewModel.hasShowedTrafficMonitoringView = YES;
                return;
            }
        }
        [self.controlView.loadingView startAnimating];
        self.controlView.loadingView.speedTextLabel.hidden = NO;
        [self.player setPlayUrl:URL(self.videoUrl)];
        //准备播放
        [self.player prepareToPlay];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ModifySlectJiFistDataStatus" object:nil userInfo:nil];
    }
}

- (void)hj_bindViewModel {
    //设置第一次的播放的按钮
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"SetFirstPlayVideoMessage" object:nil] subscribeNext:^(NSNotification *x) {
        @strongify(self);
        NSDictionary *dict = x.userInfo;
        HJCourseSelectJiModel *model = [dict objectForKey:@"model"];
        self.model = model;
        self.videoUrl = model.videourl;
        NSString *videoName = model.videoname;
        self.videoid = model.videoid;
//        self.titleView.titleTextLabel.text = videoName;
        self.controlView.fileTitleLabel.text = model.videoname.length > 0 ? model.videoname : @"暂无课程名称";
    }];
    
    //点击加入购物车的时候处理消息红点的操作
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"ModifyShopCarMessageCountNotifacation" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self loadShopCarMessageCountData];
    }];
}

- (void)dealViewShowOrHidden {
    //没有购买隐藏下边的工具条
    if([self.viewModel.model.buy isEqualToString:@"n"]) {
        //点击试看
        self.tryToWatchLabel.hidden = NO;
    } else {
        //点击试看
        self.tryToWatchLabel.hidden = YES;
    }
    
    if (self.viewModel.model.courselimit == 1) {
        //修改分享的链接 分享详情 ?
        
        //是否限时特惠 隐藏倒计时控件
        self.titleView.timeCountDownView.hidden = YES;
        
        //免费的课程 隐藏分享好友饿试图
        self.controlView.killPriceImageV.hidden = YES;
    } else {
        //付费的课程
        if(MaJia) {
            self.controlView.killPriceImageV.hidden = YES;
        } else {
            //是否能推广
            if(self.viewModel.model.canpromote == 0){
                //不能推广
                self.controlView.killPriceImageV.hidden = YES;
            } else {
                //可以推广
                //显示分享好友的弹窗
                self.controlView.killPriceImageV.hidden = NO;
            }
        }
        
        //是否可以限时特惠
        if(self.viewModel.model.hassecond == 0){
            //不能秒杀
            self.titleView.timeCountDownView.hidden = YES;
        } else {
            //可以秒杀
            self.titleView.timeCountDownView.hidden = NO;
            //显示倒计时时间
            
            NSDate *endDate = [NSDate dateWithString:self.viewModel.model.endtime formatString:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *startDate = [NSDate date];
            
            if([startDate isEarlierThan:endDate]) {
                DTTimePeriod *timePeriod =[[DTTimePeriod alloc] initWithStartDate:startDate endDate:endDate];
                double  durationInSeconds  = [timePeriod durationInSeconds];
                self.titleView.timeCountDownView.timestamp = durationInSeconds;
            } else {
                self.titleView.timeCountDownView.hidden = YES;
            }
        }
    }
}

//初始化播放控制器
- (void)doInitPlayer {
    if(self.player){
        [self doDestroyPlayer];
    }
    [NELivePlayerController setLogLevel:NELP_LOG_VERBOSE];
    NSError *error = nil;
    self.player = [[NELivePlayerController alloc] init];
    if (self.player == nil) {
        DLog(@"播放器初始化失败, please tay again.error = [%@]!", error);
    }
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.player.view.frame = _playerContainerView.bounds;
    [self.playerContainerView addSubview:self.player.view];

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

    if([self.viewModel.model.buy isEqualToString:@"y"]){
        //记录上一次播放的时间
        NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
        NSString *lastPlayTime = [defa valueForKey:self.model.courseid];
        if(lastPlayTime.floatValue > 0) {
            self.player.currentPlaybackTime = lastPlayTime.floatValue;
        }
        
        [self memoryHistoryVideo];
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

//记录播放存为历史的播放
- (void)memoryHistoryVideo {
    self.model.totalTime = self.player.duration;
    self.model.date = [NSDate date];
    self.model.realName = self.viewModel.model.username;
    
    NSMutableArray *modelArr = [[TXDataManage shareManage] unarchiveObjectWithFileName:[NSString stringWithFormat:@"WatchedVideo%@",[APPUserDataIofo UserID]]];
    NSMutableArray *marr = [NSMutableArray arrayWithArray:modelArr];
    [marr addObject:self.model];
    NSMutableDictionary *marrDict  = [NSMutableDictionary dictionary];
    //排重
    for (HJCourseSelectJiModel *model in marr) {
        [marrDict setValue:model forKey:model.courseid];
    }
    [[TXDataManage shareManage] archiveObject:marrDict.allValues withFileName:[NSString stringWithFormat:@"WatchedVideo%@",[APPUserDataIofo UserID]]];
    
    //播放量加一
    [self.viewModel addCourseCommentCountWithVideoId:self.videoid Success:^{
        
    }];
}

- (void)syncUIStatus {
    _controlView.isPlaying = NO;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    //把定时器添加到当前runloop中，并设置该runloop的运行模式，避免它受runloop的影响
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

//定时器改变
- (void)timeChange {
//    DLog(@"获取到的播放的状态是:%ld",self.player.playbackState);
    if(self.isFullScreen) {
        self.controlView.killPriceImageV.hidden = YES;
    } else {
        if(MaJia) {
           self.controlView.killPriceImageV.hidden = YES;
        } else {
            if(self.player.playbackState == NELPMoviePlaybackStatePlaying) {
                self.controlView.killPriceImageV.hidden = YES;
            } else {
                //是否能推广
                if(self.viewModel.model.canpromote == 0){
                    //不能推广
                    self.controlView.killPriceImageV.hidden = YES;
                } else {
                    //可以推广
                    //显示分享好友的弹窗
                    self.controlView.killPriceImageV.hidden = NO;
                }
            }
        }
    }
    
    NSTimeInterval mDuration = 0;
    bool getDurFlag = false;
    if (!getDurFlag) {
        mDuration = [self.player duration];
        if (mDuration > 0) {
            getDurFlag = true;
        }
    }
    self.controlView.isAllowSeek = YES;
    self.controlView.duration = mDuration;
    
    if([self.viewModel.model.buy isEqualToString:@"n"]) {
        if(self.player.currentPlaybackTime >= 2 * 60) {
            [self.player pause];
            self.controlView.loadingView.speedTextLabel.hidden = YES;
            [self.controlView.loadingView stopAnimating];
            [_timer setFireDate:[NSDate distantFuture]];
            [TXAlertView showAlertWithTitle:@"" message:@"试看已结束,点击购买观看更多精彩内容！" cancelButtonTitle:@"取消" style:TXAlertViewStyleAlert buttonIndexBlock:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    
                }
            } otherButtonTitles:@"确定", nil];
        }
    }
    self.controlView.currentPos = self.player.currentPlaybackTime;
    self.controlView.isPlaying = ([self.player playbackState] == NELPMoviePlaybackStatePlaying);
}

- (void)NELivePlayerPlaybackStateChanged:(NSNotification*)notification {
    DLog(@"[NELivePlayer Demo] 收到 NELivePlayerPlaybackStateChangedNotification 通知");
}

- (void)NeLivePlayerloadStateChanged:(NSNotification*)notification {
    DLog(@"[NELivePlayer Demo] 收到 NELivePlayerLoadStateChangedNotification 通知");
    NELPMovieLoadState nelpLoadState = _player.loadState;
    if (nelpLoadState == NELPMovieLoadStatePlaythroughOK)
    {
        NSLog(@"finish buffering");
        _controlView.isBuffing = NO;
    }
    else if (nelpLoadState == NELPMovieLoadStateStalled)
    {
        NSLog(@"begin buffering");
        _controlView.isBuffing = YES;
    }
}

//播放结束或者失败的通知
- (void)NELivePlayerPlayBackFinished:(NSNotification*)notification {
    DLog(@"[NELivePlayer Demo] 收到 NELivePlayerPlaybackFinishedNotification 通知");
    switch ([[[notification userInfo] valueForKey:NELivePlayerPlaybackDidFinishReasonUserInfoKey] intValue])
    {
        case NELPMovieFinishReasonPlaybackEnded:{
            NSString *warnString = @"视频播放结束";
            if([self.viewModel.model.buy isEqualToString:@"n"]) {
                warnString = @"试看已结束,点击购买观看更多精彩内容！";
            }
            self.controlView.loadingView.speedTextLabel.hidden = YES;
            [self.controlView.loadingView stopAnimating];
            if(self.isFullScreen) {
                //全屏的时候播放结束回到竖屏
                [self backVerticalScreen];
                [TXAlertView showAlertWithTitle:nil message:warnString cancelButtonTitle:nil style:TXAlertViewStyleAlert buttonIndexBlock:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                    }
                } otherButtonTitles:@"确定", nil];
                return;
            }
            [TXAlertView showAlertWithTitle:nil message:warnString cancelButtonTitle:nil style:TXAlertViewStyleAlert buttonIndexBlock:^(NSInteger buttonIndex) {
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
    DLog(@"[NELivePlayer Demo] 收到 NELivePlayerFirstVideoDisplayedNotification 通知");
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
    DLog(@"[NELivePlayer Demo] 收到 NELivePlayerFirstAudioDisplayedNotification 通知");
}

- (void)NELivePlayerVideoParseError:(NSNotification*)notification {
    DLog(@"[NELivePlayer Demo] 收到 NELivePlayerVideoParseError 通知");
}

- (void)NELivePlayerSeekComplete:(NSNotification*)notification {
    self.controlView.loadingView.speedTextLabel.hidden = YES;
    [self.controlView.loadingView stopAnimating];
    DLog(@"[NELivePlayer Demo] 收到 NELivePlayerMoviePlayerSeekCompletedNotification 通知");
}

- (void)NELivePlayerReleaseSuccess:(NSNotification*)notification {
    DLog(@"[NELivePlayer Demo] 收到 NELivePlayerReleaseSueecssNotification 通知");
}

#pragma mark - 控制页面的事件
//点击播放进行的操作
- (void)controlViewOnClickPlay:(NEVideoPlayerControlView *)controlView isPlay:(BOOL)isPlay {
    NSLog(@"[NELivePlayer Demo] 点击播放，当前状态: [%@]", (isPlay ? @"播放" : @"暂停"));
    if([self.viewModel.model.buy isEqualToString:@"n"]) {
        if(self.player.currentPlaybackTime >= 2 * 60) {
            self.controlView.currentPos = 2 * 60;
            self.controlView.loadingView.speedTextLabel.hidden = YES;
            [self.controlView.loadingView stopAnimating];
            [self.controlView.playBtn setSelected:NO];
            [self.player pause];
            [_timer setFireDate:[NSDate distantFuture]];
            [TXAlertView showAlertWithTitle:@"" message:@"试看已结束,点击购买观看更多精彩内容！" cancelButtonTitle:@"取消" style:TXAlertViewStyleAlert buttonIndexBlock:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    
                }
            } otherButtonTitles:@"确定", nil];
            return;
        }
    }
    if (isPlay) {
        if(self.playBtn.hidden == NO) {
            [self playClick:self.playBtn];
            //播放成功之后延时两秒之后隐藏是视图
            double delayInSeconds = 2.0;
            __weak typeof(self)weakSelf = self;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [weakSelf.controlView controlOverlayHide];
            });
        } else{
            [self.player play];
            //播放成功之后延时两秒之后隐藏是视图
            double delayInSeconds = 2.0;
            __weak typeof(self)weakSelf = self;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [weakSelf.controlView controlOverlayHide];
            });
        }
    } else {
        self.controlView.loadingView.speedTextLabel.hidden = YES;
        [self.controlView.loadingView stopAnimating];
        [self.player pause];
    }
}

//定位到指定的播放的时间
- (void)controlViewOnClickSeek:(NEVideoPlayerControlView *)controlView dstTime:(NSTimeInterval)dstTime {
    DLog(@"[NELivePlayer Demo] 执行seek，目标时间: [%f]", dstTime);
    self.controlView.loadingView.speedTextLabel.hidden = NO;
    [self.controlView.loadingView startAnimating];
    self.player.currentPlaybackTime = dstTime;
    
    if([self.viewModel.model.buy isEqualToString:@"n"]) {
        if(self.player.currentPlaybackTime >= 2 * 60) {
            self.controlView.currentPos = 2 * 60;
            [self.controlView.playBtn setSelected:NO];
            [self.player pause];
            self.controlView.loadingView.speedTextLabel.hidden = YES;
            [self.controlView.loadingView stopAnimating];
            [_timer setFireDate:[NSDate distantFuture]];
            self.player.currentPlaybackTime = 2 * 60;
            [TXAlertView showAlertWithTitle:@"" message:@"试看已结束,点击购买观看更多精彩内容！" cancelButtonTitle:@"取消" style:TXAlertViewStyleAlert buttonIndexBlock:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    
                }
            } otherButtonTitles:@"确定", nil];
        } else {
           [_timer setFireDate:[NSDate distantPast]];
        }
    }
}

//静音开关进行的操作
- (void)controlViewOnClickMute:(NEVideoPlayerControlView *)controlView isMute:(BOOL)isMute{
    DLog(@"[NELivePlayer Demo] 点击静音，当前状态: [%@]", (isMute ? @"静音开" : @"静音关"));
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
        self.titleView.hidden = YES;
        [self.playBtn setImage:[UIImage imageNamed:@"直播播放屏幕中央"] forState:UIControlStateNormal];
        
        self.toolView.hidden = YES;
        self.scrollView.hidden = YES;
        self.goInShopCarBtn.hidden = YES;
        _controlView.fileName.hidden = NO;

        [self.player setScalingMode:NELPMovieScalingModeAspectFill];
        [UIView animateWithDuration:0.3 animations:^{
            [_playerContainerView setFrame:CGRectMake(0, 0, Screen_Width, kHeight(210))];
            self.player.view.transform = CGAffineTransformMakeRotation(M_PI/2);
            _controlView.transform = CGAffineTransformMakeRotation(M_PI/2);
            CGRect f = self.player.view.frame;
            f = CGRectMake(0, 0, kW, kH);
            _controlView.frame = f;
            self.player.view.frame = f;
            _controlView.isFull = YES;
        }];
    } else {
        [self.playBtn setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
        
        self.isFullScreen = NO;
        self.titleView.hidden = NO;
        self.toolView.hidden = NO;
        self.scrollView.hidden = NO;
        self.goInShopCarBtn.hidden = NO;
        _controlView.fileName.hidden = YES;
        [UIApplication sharedApplication].statusBarHidden = NO;
        [self.player setScalingMode:NELPMovieScalingModeAspectFit];
        [UIView animateWithDuration:0.3 animations:^{
            [_playerContainerView setFrame:CGRectMake(0, kTopStatusHeight, Screen_Width, kHeight(210))];
            self.player.view.transform = CGAffineTransformIdentity;
            _controlView.transform = CGAffineTransformIdentity;
            CGRect f = self.player.view.frame;
            f = CGRectMake(0, kTopStatusHeight, kW, kHeight(210));
            _controlView.frame = f;
            self.player.view.frame = _playerContainerView.bounds;
            _controlView.isFull = NO;
        }];
    }
}

//滚动切换控制器的操作
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = self.view.frame.size.width;
    CGFloat offsetX = scrollView.contentOffset.x;
    //获取索引
    NSInteger scrollIndex = offsetX / width;
    self.selectIndex = scrollIndex;
    self.toolView.selectIndex = scrollIndex;
}

//进入购物车的的按钮
- (UIButton *)goInShopCarBtn {
    if(!_goInShopCarBtn) {
        _goInShopCarBtn = [UIButton creatButton:^(UIButton *button) {
            button.backgroundColor = clear_color;
            [button setBackgroundImage:V_IMAGE(@"购物车 入口") forState:UIControlStateNormal];
            [button clipWithCornerRadius:kHeight(23.0) borderColor:white_color borderWidth:0];
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                if([APPUserDataIofo AccessToken].length <= 0) {
                    [DCURLRouter pushURLString:@"route://loginVC" animated:YES];
                    return;
                }
                [DCURLRouter pushURLString:@"route://shopCarVC" animated:YES];
            }];
            //购物车的课程的数量
            UILabel *courseCountLabel = [UILabel creatLabel:^(UILabel *label) {
                label.ljTitle_font_textColor(@" ",MediumFont(font(10.0)),white_color);
                label.textAlignment = NSTextAlignmentCenter;
                label.numberOfLines = 0;
                [label sizeToFit];
            }];
            courseCountLabel.backgroundColor = HEXColor(@"#F02D2D");
            [courseCountLabel clipWithCornerRadius:kHeight(6.5) borderColor:HEXColor(@"#F02D2D") borderWidth:0];
            [button addSubview:courseCountLabel];
            [courseCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(button).offset(kHeight(7.0));
                make.right.equalTo(button).offset(-kWidth(9.0));
                make.size.mas_equalTo(CGSizeMake(kWidth(13.0), kHeight(13.0)));
            }];
            courseCountLabel.hidden = YES;
            self.redBotLabel = courseCountLabel;
        }];
        
        UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [_goInShopCarBtn addGestureRecognizer:pan];//给图片添加手势
    }
    return _goInShopCarBtn;
}

//按钮拖动的时候进型的操作
- (void)handlePan:(UIPanGestureRecognizer *)rec {
    [self.goInShopCarBtn setHighlighted:YES];
    CGFloat KWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat KHeight = [UIScreen mainScreen].bounds.size.height;
   //拖动后，相对坐标的偏移量
    CGPoint point = [rec translationInView:self.view];
    
//     NSLog(@"%f,%f",point.x,point.y);
    CGFloat centerX = rec.view.center.x + point.x;
    CGFloat centerY = rec.view.center.y + point.y;
    CGFloat viewHalfH = rec.view.frame.size.height / 2;
    CGFloat viewhalfW = rec.view.frame.size.width / 2;
    //确定特殊的centerY
    if (centerY - viewHalfH < 0 ) {
        centerY = viewHalfH;
     }
    if (centerY + viewHalfH > KHeight ) {
       centerY = KHeight - viewHalfH;
    }
     //确定特殊的centerX
    if (centerX - viewhalfW < 0){
        centerX = viewhalfW;
    }
    if (centerX + viewhalfW > KWidth){
       centerX = KWidth - viewhalfW;
    }
    rec.view.center = CGPointMake(centerX, centerY);
   
    //拖动完之后，每次都要用setTranslation:方法制0这样才不至于不受控制般滑动出视图
    [rec setTranslation:CGPointMake(0, 0) inView:self.view];
}


@end

