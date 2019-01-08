//
//  HJCourseDetailCommentModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/14.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJCourseDetailCommentModel : BaseModel

@property (nonatomic,copy) NSString *userid;
@property (nonatomic,copy) NSString *commentcontent;
@property (nonatomic,copy) NSString *coursescore;
@property (nonatomic,copy) NSString *createtime;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *iconurl;
@property (nonatomic,assign) CGFloat cellHeight;


@end

NS_ASSUME_NONNULL_END
