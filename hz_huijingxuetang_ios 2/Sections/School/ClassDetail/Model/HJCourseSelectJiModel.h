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

@property (nonatomic,copy) NSString *courseid;
@property (nonatomic,copy) NSString *videoid;
@property (nonatomic,copy) NSString *videoname;
@property (nonatomic,copy) NSString *hits;
@property (nonatomic,copy) NSString *videoppicurl;
@property (nonatomic,copy) NSString *videourl;

//视频总时间
@property (nonatomic,assign) NSTimeInterval totalTime; 
//讲师名称
@property (nonatomic,copy) NSString *realName;
//视频播放时间
@property (nonatomic,strong) NSDate *date;

//是否是点播的操作
@property (nonatomic,assign) BOOL isOnPlay;

//已经播放过了
@property (nonatomic,assign) BOOL isPlayed;

@end

NS_ASSUME_NONNULL_END
