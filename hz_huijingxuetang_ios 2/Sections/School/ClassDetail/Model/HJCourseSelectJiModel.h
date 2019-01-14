//
//  HJCourseSelectJiModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/14.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJCourseSelectJiModel : BaseModel

//课程id
@property (nonatomic,copy) NSString *courseid;
//选集id
@property (nonatomic,copy) NSString *videoid;
//选集的名称
@property (nonatomic,copy) NSString *videoname;
//播放量
@property (nonatomic,copy) NSString *hits;
//选集的展示图片
@property (nonatomic,copy) NSString *videoppicurl;
//选集的播放链接
@property (nonatomic,copy) NSString *videourl;
//视频总时间
@property (nonatomic,assign) NSTimeInterval totalTime; 
//讲师名称
@property (nonatomic,copy) NSString *realName;
//视频当前的播放时间
@property (nonatomic,strong) NSDate *date;
//是否正在播放的标示
@property (nonatomic,assign) BOOL isOnPlay;
//已经播放过了
@property (nonatomic,assign) BOOL isPlayed;

@end

NS_ASSUME_NONNULL_END
