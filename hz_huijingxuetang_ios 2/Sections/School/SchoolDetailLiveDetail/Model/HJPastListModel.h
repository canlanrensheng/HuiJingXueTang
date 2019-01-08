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

@property (nonatomic,copy) NSString *courseid;
@property (nonatomic,copy) NSString *coursename;
@property (nonatomic,copy) NSString *starttime;
@property (nonatomic,copy) NSString *endtime;
@property (nonatomic,copy) NSString *videourl;
@property (nonatomic,assign) BOOL isPlay;

@end

NS_ASSUME_NONNULL_END
