//
//  HJTeacherRecommentModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/15.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJTeacherRecommentModel : BaseModel

@property (nonatomic , copy) NSString              * userid;
@property (nonatomic , copy) NSString              * teacherurl;
@property (nonatomic , copy) NSString              * iconurl;
@property (nonatomic , assign) NSInteger              famousteacherord;
@property (nonatomic , assign) NSInteger              course_count;
@property (nonatomic , assign) NSInteger              video_count;
@property (nonatomic , copy) NSString              * teacprofessional;
@property (nonatomic , assign) NSInteger              member_count;
@property (nonatomic , copy) NSString              * realname;
@property (nonatomic , assign) NSInteger              isspecialgrade;

@end

NS_ASSUME_NONNULL_END
