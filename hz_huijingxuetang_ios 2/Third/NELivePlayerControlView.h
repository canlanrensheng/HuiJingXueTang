//
//  NELivePlayerControlView.h
//  NELivePlayerDemo
//
//  Created by Netease on 2017/11/15.
//  Copyright © 2017年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFSpeedLoadingView.h"
@protocol NELivePlayerControlViewProtocol;

@interface NELivePlayerControlView : UIImageView

@property (nonatomic, assign, readonly) BOOL isDragging; //正在拖拽

@property (nonatomic, assign) NSTimeInterval currentPos; //当前播放时间

@property (nonatomic, assign) NSTimeInterval duration; //视频时长

@property (nonatomic, assign) NSString *fileTitle; //视频标题

@property (nonatomic, assign) BOOL isPlaying; //正在播放

@property (nonatomic, assign) BOOL isBuffing; //正在缓冲

@property (nonatomic, assign) BOOL isAllowSeek; //是否允许seek

@property (nonatomic, weak) id<NELivePlayerControlViewProtocol> delegate;

@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *subtitle_ex;
@property (nonatomic, assign) CGSize videoResolution;

//发送私聊消息的按钮
@property (nonatomic,strong) UIButton *sendChatBtn;

@property (nonatomic,strong) RACSubject *shareSubject;
@property (nonatomic,strong) RACSubject *backSubject;
//发送消息
@property (nonatomic,strong) RACSubject *sendChatSubject;

//是否全屏展示
@property (nonatomic,assign) BOOL isFull;

@property (nonatomic,strong) ZFSpeedLoadingView *loadingView;


@property (nonatomic, strong) UIImageView *topControlView; //顶部控制条
@property (nonatomic, strong) UIImageView *bottomControlView; //底部控制条
@property (nonatomic, strong) UIButton *playBtn;  //播放/暂停按钮
@property (nonatomic, strong) UIButton *scaleModeBtn; //显示模式按钮
//分享的按钮
@property (nonatomic,strong) UIButton *shareBtn;
//返回的按钮
@property (nonatomic,strong) UIButton *backBtn;

//文章的标题
@property (nonatomic,strong) UILabel *fileTitleLabel;

- (void)controlOverlayHide;

@end

@protocol NELivePlayerControlViewProtocol <NSObject>

- (void)controlViewOnClickQuit:(NELivePlayerControlView *)controlView;
- (void)controlViewOnClickPlay:(NELivePlayerControlView *)controlView isPlay:(BOOL)isPlay;
- (void)controlViewOnClickSeek:(NELivePlayerControlView *)controlView dstTime:(NSTimeInterval)dstTime;
- (void)controlViewOnClickMute:(NELivePlayerControlView *)controlView isMute:(BOOL)isMute;
- (void)controlViewOnClickSnap:(NELivePlayerControlView *)controlView;
- (void)controlViewOnClickScale:(NELivePlayerControlView *)controlView isFill:(BOOL)isFill;


@end
