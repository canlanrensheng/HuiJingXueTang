//
//  HJPastListModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/28.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJPastListModel : BaseModel

//课程的ID
@property (nonatomic,copy) NSString *courseid;
//课程的名称
@property (nonatomic,copy) NSString *coursename;
//开始时间
@property (nonatomic,copy) NSString *starttime;
//结束的时间
@property (nonatomic,copy) NSString *endtime;
//视频播放链接
@property (nonatomic,copy) NSString *videourl;
//是否正在播放的标示
@property (nonatomic,assign) BOOL isPlay;

@end

NS_ASSUME_NONNULL_END
