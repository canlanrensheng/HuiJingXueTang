//
//  NELivePlayerControlView.m
//  NELivePlayerDemo
//
//  Created by Netease on 2017/11/15.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "NELivePlayerControlView.h"
#import "UIView+NEPlayer.h"

#define kPlayerBtnWidth (30)

@interface NELivePlayerControlView ()
{
    BOOL _isDraggingInternal;
}
@property (nonatomic, strong) UIControl *mediaControl; //媒体覆盖层
@property (nonatomic, strong) UIControl *overlayControl; //控制层
@property (nonatomic, strong) UIActivityIndicatorView *bufferingIndicate; //缓冲动画
@property (nonatomic, strong) UILabel *bufferingReminder; //缓冲提示
@property (nonatomic, strong) UIButton *playQuitBtn; //退出
@property (nonatomic, strong) UILabel *fileName; //文件名字
@property (nonatomic, strong) UILabel *currentTime;   //播放时间
@property (nonatomic, strong) UILabel *totalDuration; //文件时长
@property (nonatomic, strong) UISlider *videoProgress;//播放进度

@property (nonatomic, strong) UIButton *muteBtn;  //静音按钮

@property (nonatomic, strong) UIButton *snapshotBtn;  //截图按钮
@property (nonatomic, strong) UILabel *subtitleLab;//字幕
@property (nonatomic, strong) UILabel *subtitleExLab;//额外的字幕



@end

@implementation NELivePlayerControlView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.userInteractionEnabled = YES;

    [self addSubview:self.mediaControl];

    [self addSubview:self.overlayControl];
    [_overlayControl addSubview:self.topControlView];

    [_topControlView addSubview:self.fileTitleLabel];
    
    [_overlayControl addSubview:self.bottomControlView];
    [_bottomControlView addSubview:self.playBtn];
    [_bottomControlView addSubview:self.scaleModeBtn];
    
    //分享按钮
    UIButton *shareBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"",nil,white_color,0);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self.shareSubject sendNext:nil];
        }];
    }];
    [_topControlView addSubview:shareBtn];

    self.shareBtn = shareBtn;
    
    //返回按钮
    UIButton *backBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"",nil,white_color,0);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self.backSubject sendNext:nil];
        }];
    }];
    [_topControlView addSubview:backBtn];
    self.backBtn = backBtn;
    
    //发送消息的按钮
    self.sendChatBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"说点什么吧~",MediumFont(font(13)),HEXColor(@"#CCCCCC"),0);
        button.titleLabel.textAlignment = NSTextAlignmentLeft;
        button.backgroundColor = white_color;
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self.sendChatSubject sendNext:nil];
        }];
    }];
    self.sendChatBtn.hidden = YES;
    [self.sendChatBtn clipWithCornerRadius:kHeight(5.0) borderColor:nil borderWidth:0];
    [_bottomControlView addSubview:self.sendChatBtn];
    
    [self addSubview:self.loadingView];
    self.loadingView.speedTextLabel.hidden = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _mediaControl.frame = self.bounds;
    
    CGFloat topViewHeight = kHeight(48);
    CGFloat bottomViewHeight = kHeight(46);
    if(!self.isFull) {
        topViewHeight = kHeight(64);
        bottomViewHeight = kHeight(46);
    }

    _overlayControl.frame = self.bounds;
    _topControlView.frame = CGRectMake(0, 0, _overlayControl.width, topViewHeight);
    
    CGFloat shareCon = self.isFull ? (-kWidth(10)-KHomeIndicatorHeight) : (-kWidth(10));
    self.shareBtn.frame = CGRectMake(self.bounds.size.width + shareCon - kWidth(30), (topViewHeight - kHeight(30)) / 2, kWidth(30), kWidth(30));
    
    CGFloat backCon = self.isFull ? (kWidth(10) + kStatusBarHeight) : (kWidth(10));
    self.backBtn.frame = CGRectMake(backCon, (topViewHeight - kHeight(30)) / 2, kHeight(30), kHeight(30));
    _bottomControlView.frame = CGRectMake(0, self.bounds.size.height - bottomViewHeight, self.bounds.size.width, bottomViewHeight);
    
    //直播的标题
    self.fileTitleLabel.frame = CGRectMake(backCon + kWidth(40), (topViewHeight - kHeight(30)) / 2, kHeight(150), kHeight(30));
    
    
    CGFloat playCon = self.isFull ? (kWidth(10.0) + kStatusBarHeight) : (kWidth(10));
    self.playBtn.frame = CGRectMake(playCon, (_bottomControlView.size.height - kHeight(30))/ 2, kWidth(30), kWidth(30));
    CGFloat scaleModeCon = self.isFull ? (-kWidth(10.0) - KHomeIndicatorHeight) : (-kWidth(10.0));
    self.scaleModeBtn.frame = CGRectMake(self.bounds.size.width + scaleModeCon - kWidth(30), (_bottomControlView.size.height - kHeight(30))/ 2, kWidth(30), kWidth(30));
    
    self.loadingView.frame = self.bounds;
    
    //发送私聊信息的按钮
    self.sendChatBtn.frame = CGRectMake((_bottomControlView.bounds.size.width - kWidth(295)) / 2, (_bottomControlView.bounds.size.height - kHeight(28)) / 2, kWidth(295), kHeight(28));
    
    if (self.isFull) {
        //全屏的操作
        [self.backBtn setImage:V_IMAGE(@"直播返回按钮横屏") forState:UIControlStateNormal];
        [self.shareBtn setImage:V_IMAGE(@"直播分享横屏") forState:UIControlStateNormal];
        [self.playBtn setImage:V_IMAGE(@"直播播放横屏") forState:UIControlStateNormal];
        [self.playBtn setImage:V_IMAGE(@"直播暂停横屏") forState:UIControlStateSelected];
        [self.scaleModeBtn setImage:V_IMAGE(@"直播全屏横屏") forState:UIControlStateNormal];
    
        
        self.topControlView.image = V_IMAGE(@"黑色遮罩横屏上");
        self.bottomControlView.image = V_IMAGE(@"黑色遮罩横屏下");
        
    } else {
        //竖屏的操作
        [self.backBtn setImage:V_IMAGE(@"直播返回按钮横屏") forState:UIControlStateNormal];
        [self.shareBtn setImage:V_IMAGE(@"直播分享横屏") forState:UIControlStateNormal];
        [self.playBtn setImage:V_IMAGE(@"直播播放横屏") forState:UIControlStateNormal];
        [self.playBtn setImage:V_IMAGE(@"直播暂停横屏") forState:UIControlStateSelected];
        [self.scaleModeBtn setImage:V_IMAGE(@"直播全屏横屏") forState:UIControlStateNormal];
        
        self.topControlView.image = V_IMAGE(@"黑色遮罩上竖屏");
        self.bottomControlView.image = V_IMAGE(@"黑色遮罩下竖屏");
    }
    
    _scaleModeBtn.selected = self.isFull;
}

- (ZFSpeedLoadingView *)loadingView {
    if(!_loadingView) {
        _loadingView = [[ZFSpeedLoadingView alloc] init];
    }
    return _loadingView;
}

- (RACSubject *)shareSubject {
    if (!_shareSubject) {
        _shareSubject = [[RACSubject alloc] init];
    }
    return _shareSubject;
}

- (RACSubject *)backSubject {
    if (!_backSubject) {
        _backSubject = [[RACSubject alloc] init];
    }
    return _backSubject;
}

- (RACSubject *)sendChatSubject {
    if (!_sendChatSubject) {
        _sendChatSubject = [[RACSubject alloc] init];
    }
    return _sendChatSubject;
}

#pragma mark - Action
- (void)onClickMediaControlAction:(UIControl *)control {
    _overlayControl.hidden = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(controlOverlayHide) object:nil];
    [self performSelector:@selector(controlOverlayHide) withObject:nil afterDelay:8];
}

- (void)onClickOverlayControlAction:(UIControl *)control {
    _overlayControl.hidden = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(controlOverlayHide) object:nil];
}

- (void)controlOverlayHide {
    _overlayControl.hidden = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(controlOverlayHide) object:nil];
}

- (void)onClickBtnAction:(UIButton *)btn {
    
    if (btn == _playQuitBtn) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(controlOverlayHide) object:nil];
        
        if (_delegate && [_delegate respondsToSelector:@selector(controlViewOnClickQuit:)]) {
            [_delegate controlViewOnClickQuit:self];
        }
    } else if (btn == _playBtn) {
        _playBtn.selected = !_playBtn.isSelected;
        if (_delegate && [_delegate respondsToSelector:@selector(controlViewOnClickPlay:isPlay:)]) {
            [_delegate controlViewOnClickPlay:self isPlay:_playBtn.isSelected];
        }
    } else if (btn == _muteBtn) {
        _muteBtn.selected = !_muteBtn.isSelected;
        if (_delegate && [_delegate respondsToSelector:@selector(controlViewOnClickMute:isMute:)]) {
            [_delegate controlViewOnClickMute:self isMute:_muteBtn.isSelected];
        }
    } else if (btn == _scaleModeBtn) {
        _scaleModeBtn.selected = !_scaleModeBtn.isSelected;
        if (_delegate && [_delegate respondsToSelector:@selector(controlViewOnClickScale:isFill:)]) {
            [_delegate controlViewOnClickScale:self isFill:_scaleModeBtn.isSelected];
        }
    } else if (btn == _snapshotBtn) {
        if (_delegate && [_delegate respondsToSelector:@selector(controlViewOnClickSnap:)]) {
            [_delegate controlViewOnClickSnap:self];
        }
    }
}

- (void)onClickSeekAction:(UISlider *)slider {
    if (_isAllowSeek) {
        NSTimeInterval currentPlayTime = slider.value;
        int mCurrentPostion = (int)currentPlayTime;
        _currentTime.text = [NSString stringWithFormat:@"%02d:%02d:%02d",
                             (int)(mCurrentPostion / 3600),
                             (int)(mCurrentPostion > 3600 ? (mCurrentPostion - (mCurrentPostion / 3600)*3600) / 60 : mCurrentPostion/60),
                             (int)(mCurrentPostion % 60)];
    }
}

- (void)onClickSeekTouchUpInside:(UISlider *)slider {
    if (_isAllowSeek) {
        if (_delegate && [_delegate respondsToSelector:@selector(controlViewOnClickSeek:dstTime:)]) {
            [_delegate controlViewOnClickSeek:self dstTime:slider.value];
        }
        _isDraggingInternal = NO;
    }
}

- (void)onClickSeekTouchUpOutside:(UISlider *)slider {
    if (_isAllowSeek) {
        _isDraggingInternal = NO;
    }
}

#pragma mark - Setter
- (BOOL)isDragging {
    return _isDraggingInternal;
}

- (void)setCurrentPos:(NSTimeInterval)currentPos {
    _currentPos = currentPos;
    NSInteger currPos  = round(currentPos);
    _currentTime.text = [NSString stringWithFormat:@"%02d:%02d:%02d",
                         (int)(currPos / 3600),
                         (int)(currPos > 3600 ? (currPos - (currPos / 3600)*3600) / 60 : currPos/60),
                         (int)(currPos % 60)];
    _videoProgress.value = currentPos;
}

- (void)setDuration:(NSTimeInterval)duration {
    _duration = duration;
    
    if (duration > 0) {
        NSInteger mDuration = round(duration);
        _totalDuration.text = [NSString stringWithFormat:@"%02d:%02d:%02d",
                               (int)(mDuration / 3600),
                               (int)(mDuration > 3600 ? (mDuration - 3600 * (mDuration / 3600)) / 60 : mDuration/60),
                               (int)(mDuration > 3600 ? ((mDuration - 3600 * (mDuration / 3600)) % 60) :(mDuration % 60))];
        _videoProgress.maximumValue = duration;
    }
    else {
        _videoProgress.value = 0.0;
        _totalDuration.text = @"--:--:--";
    }
}

- (void)setFileTitle:(NSString *)fileTitle {
    _fileTitle = fileTitle;
    if (fileTitle) {
        _fileName.text = fileTitle;
    }
}

- (void)setIsPlaying:(BOOL)isPlaying {
    _isPlaying = isPlaying;
    _playBtn.selected = isPlaying;
}

- (void)setIsBuffing:(BOOL)isBuffing {
    _isBuffing = isBuffing;
    
    if (isBuffing) {
        _bufferingIndicate.hidden = NO;
        [_bufferingIndicate startAnimating];
        _bufferingReminder.hidden = NO;
    
    } else {
        _bufferingIndicate.hidden = YES;
        [_bufferingIndicate stopAnimating];
        _bufferingReminder.hidden = YES;
    }
}

- (void)setSubtitle_ex:(NSString *)subtitle_ex {
    _subtitle_ex = (subtitle_ex ? subtitle_ex : @"");
    self.subtitleExLab.text = subtitle_ex;
}

- (void)setSubtitle:(NSString *)subtitle {
    _subtitle = (subtitle ? subtitle : @"");
    self.subtitleLab.text = subtitle;
}

- (void)setVideoResolution:(CGSize)videoResolution {
    
    //计算画面尺寸
    CGFloat oriSizeRatio = videoResolution.width * 1.0 / videoResolution.height;
    CGFloat targetSizeRatio = self.width * 1.0 / self.height;
    CGFloat width = 0.0;
    CGFloat height = 0.0;
    
    if (oriSizeRatio > targetSizeRatio) //上下添黑
    {
        width = self.width;
        height = self.width * videoResolution.height / videoResolution.width;
    }
    else if (oriSizeRatio < targetSizeRatio) //左右填黑
    {
        height = self.height;
        width = self.height * videoResolution.width / videoResolution.height;
    }
    else //不需要添黑
    {
        width = self.width;
        height = self.height;
    }
    
    CGRect venderRect = CGRectMake((self.width-width)/2, (self.height-height)/2, width, height);
    
    //调整字幕位置
    self.subtitleLab.frame = CGRectMake(0, venderRect.origin.y+venderRect.size.height - 80, self.width, 80);
    self.subtitleExLab.frame = CGRectMake(0, self.subtitleLab.top - 80, self.width, 80);
}

#pragma mark - 控件属性
- (UIControl *)mediaControl {
    if (!_mediaControl) {
        _mediaControl = [[UIControl alloc] init];
        [_mediaControl addTarget:self action:@selector(onClickMediaControlAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mediaControl;
}

- (UIControl *)overlayControl {
    if (!_overlayControl) {
        _overlayControl = [[UIControl alloc] init];
        [_overlayControl addTarget:self action:@selector(onClickOverlayControlAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _overlayControl;
}

- (UIActivityIndicatorView *)bufferingIndicate {
    if (!_bufferingIndicate) {
        _bufferingIndicate = [[UIActivityIndicatorView alloc] init];
        _bufferingIndicate.hidden = YES;
    }
    return _bufferingIndicate;
}

- (UILabel *)bufferingReminder {
    if (!_bufferingReminder) {
        _bufferingReminder = [[UILabel alloc] init];
        _bufferingReminder.text = @"缓冲中";
        _bufferingReminder.textAlignment = NSTextAlignmentCenter; //文字居中
        _bufferingReminder.textColor = [UIColor whiteColor];
        _bufferingReminder.hidden = YES;
        [_bufferingReminder sizeToFit];
    }
    return _bufferingReminder;
}

-(UIImageView *)topControlView {
    if (!_topControlView) {
        _topControlView = [[UIImageView alloc] init];
        _topControlView.userInteractionEnabled = YES;
//        _topControlView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"黑色遮罩"]];
//        _topControlView.alpha = 0.8;
    }
    return _topControlView;
}

- (UIImageView *)bottomControlView {
    if (!_bottomControlView) {
        _bottomControlView = [[UIImageView alloc] init];
        _bottomControlView.userInteractionEnabled = YES;
//        _bottomControlView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ic_background_black"]];
//        _bottomControlView.alpha = 0.8;
    }
    return _bottomControlView;
}

//直播的标题
- (UILabel *)fileTitleLabel {
    if (!_fileTitleLabel) {
        _fileTitleLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(@" ",MediumFont(font(17)),white_color);
            label.textAlignment = NSTextAlignmentLeft;
            label.numberOfLines = 0;
            [label sizeToFit];
        }];
    }
    return _fileTitleLabel;
}

- (UIButton *)playQuitBtn {
    if (!_playQuitBtn) {
        _playQuitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playQuitBtn setImage:[UIImage imageNamed:@"直播播放屏幕中央"] forState:UIControlStateNormal];
        [_playQuitBtn addTarget:self action:@selector(onClickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playQuitBtn;
}

- (UILabel *)fileName {
    if (!_fileName) {
        _fileName = [[UILabel alloc] init];
        _fileName.textAlignment = NSTextAlignmentLeft; //文字居中
        _fileName.textColor = white_color;
        _fileName.font = MediumFont(font(17));
    }
    return _fileName;
}

- (UILabel *)currentTime {
    if (!_currentTime) {
        _currentTime = [[UILabel alloc] init];
        _currentTime.text = @"00:00:00"; //for test
        _currentTime.textAlignment = NSTextAlignmentCenter;
        _currentTime.textColor = [[UIColor alloc] initWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1];
        _currentTime.font = [UIFont systemFontOfSize:10.0];
        [_currentTime sizeToFit];
    }
    return _currentTime;
}

- (UILabel *)totalDuration {
    if (!_totalDuration) {
        _totalDuration = [[UILabel alloc] init];
        _totalDuration.text = @"--:--:--";
        _totalDuration.textAlignment = NSTextAlignmentCenter;
        _totalDuration.textColor = [[UIColor alloc] initWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1];
        _totalDuration.font = [UIFont systemFontOfSize:10.0];
        [_totalDuration sizeToFit];
    }
    return _totalDuration;
}

- (UISlider *)videoProgress {
    if (!_videoProgress) {
        _videoProgress = [[UISlider alloc] init];
        [_videoProgress setThumbImage:[UIImage imageNamed:@"btn_player_slider_thumb"] forState:UIControlStateNormal];
        [_videoProgress setMaximumTrackImage:[UIImage imageNamed:@"btn_player_slider_all"] forState:UIControlStateNormal];
        [_videoProgress setMinimumTrackImage:[UIImage imageNamed:@"btn_player_slider_played"] forState:UIControlStateNormal];
        [_videoProgress addTarget:self action:@selector(onClickSeekAction:) forControlEvents:UIControlEventValueChanged];
        [_videoProgress addTarget:self action:@selector(onClickSeekTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_videoProgress addTarget:self action:@selector(onClickSeekTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    }
    return _videoProgress;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_playBtn setImage:[UIImage imageNamed:@"暂停-1"] forState:UIControlStateNormal];
//        [_playBtn setImage:[UIImage imageNamed:@"播放-1"] forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(onClickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIButton *)muteBtn {
    if (!_muteBtn) {
        _muteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_muteBtn setImage:[UIImage imageNamed:@"btn_player_mute02"] forState:UIControlStateNormal];
        [_muteBtn setImage:[UIImage imageNamed:@"btn_player_mute01"] forState:UIControlStateSelected];
        [_muteBtn addTarget:self action:@selector(onClickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _muteBtn;
}

- (UIButton *)scaleModeBtn {
    if (!_scaleModeBtn) {
        _scaleModeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_scaleModeBtn setImage:[UIImage imageNamed:@"全屏-1"] forState:UIControlStateNormal];
//        [_scaleModeBtn setImage:[UIImage imageNamed:@"全屏-1"] forState:UIControlStateSelected];
        [_scaleModeBtn addTarget:self action:@selector(onClickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scaleModeBtn;
}

- (UIButton *)snapshotBtn {
    if (!_snapshotBtn) {
        self.snapshotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.snapshotBtn setImage:[UIImage imageNamed:@"btn_player_snap"] forState:UIControlStateNormal];
        [self.snapshotBtn addTarget:self action:@selector(onClickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _snapshotBtn;
}

//字幕
- (UILabel *)subtitleLab {
    if (!_subtitleLab) {
        _subtitleLab = [[UILabel alloc] init];
        _subtitleLab.textAlignment = NSTextAlignmentCenter;
        _subtitleLab.textColor = [UIColor whiteColor];
        _subtitleLab.font = [UIFont systemFontOfSize:17.0];
        _subtitleLab.numberOfLines = 0;
    }
    return _subtitleLab;
}

//额外的字幕
- (UILabel *)subtitleExLab {
    if (!_subtitleExLab) {
        _subtitleExLab = [[UILabel alloc] init];
        _subtitleExLab.textAlignment = NSTextAlignmentCenter;
        _subtitleExLab.textColor = [UIColor redColor];
        _subtitleExLab.font = [UIFont systemFontOfSize:14.0];
        _subtitleExLab.numberOfLines = 0;
    }
    return _subtitleExLab;
}

@end
