//
//  NELivePlayerControlView.h
//  NELivePlayerDemo
//
//  Created by Netease on 2017/11/15.
//  Copyright © 2017年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFSpeedLoadingView.h"
@protocol NEVideoPlayerControlViewProtocol;

@interface NEVideoPlayerControlView : UIImageView

@property (nonatomic, assign, readonly) BOOL isDragging; //正在拖拽

@property (nonatomic, assign) NSTimeInterval currentPos; //当前播放时间

@property (nonatomic, assign) NSTimeInterval duration; //视频时长

@property (nonatomic, assign) NSString *fileTitle; //视频标题

@property (nonatomic, assign) BOOL isPlaying; //正在播放

@property (nonatomic, assign) BOOL isBuffing; //正在缓冲

@property (nonatomic, assign) BOOL isAllowSeek; //是否允许seek

@property (nonatomic, weak) id<NEVideoPlayerControlViewProtocol> delegate;

@property (nonatomic, strong) UILabel *fileName; //文件名字


@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *subtitle_ex;
@property (nonatomic, assign) CGSize videoResolution;

@property (nonatomic,strong) RACSubject *shareSubject;
@property (nonatomic,strong) RACSubject *backSubject;
//发送消息
@property (nonatomic,strong) RACSubject *sendChatSubject;

@property (nonatomic, strong) UIImageView *topControlView; //顶部控制条
@property (nonatomic, strong) UIImageView *bottomControlView; //底部控制条

//遮罩
@property (nonatomic,strong) UIImageView *coverImageView;
//砍价的试图的展示
@property (nonatomic,strong) UIImageView *killPriceImageV;
//是否全屏展示
@property (nonatomic,assign) BOOL isFull;

@property (nonatomic,strong) ZFSpeedLoadingView *loadingView;

//文章的标题
@property (nonatomic,strong) UILabel *fileTitleLabel;

@property (nonatomic, strong) UIButton *playBtn;  //播放/暂停按钮

//继续播放视频的按钮
@property (nonatomic,strong) RACSubject *keepPlaySubject;

//流量监控的试图
@property (nonatomic,strong) UIView *trafficMonitoringView;

//进度条
@property (nonatomic, strong) UISlider *videoProgress;//播放进度

- (void)controlOverlayHide;

@end

@protocol NEVideoPlayerControlViewProtocol <NSObject>

- (void)controlViewOnClickQuit:(NEVideoPlayerControlView *)controlView;
- (void)controlViewOnClickPlay:(NEVideoPlayerControlView *)controlView isPlay:(BOOL)isPlay;
- (void)controlViewOnClickSeek:(NEVideoPlayerControlView *)controlView dstTime:(NSTimeInterval)dstTime;
- (void)controlViewOnClickMute:(NEVideoPlayerControlView *)controlView isMute:(BOOL)isMute;
- (void)controlViewOnClickSnap:(NEVideoPlayerControlView *)controlView;
- (void)controlViewOnClickScale:(NEVideoPlayerControlView *)controlView isFill:(BOOL)isFill;

@end
