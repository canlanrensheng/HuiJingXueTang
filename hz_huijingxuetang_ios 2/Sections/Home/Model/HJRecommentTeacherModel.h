//
//  HJRecommentTeacherModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/26.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJRecommentTeacherModel : BaseModel

@property (nonatomic , assign) NSInteger              famousteacherord;
@property (nonatomic , copy) NSString              * userid;
@property (nonatomic , assign) NSInteger              video_count;
@property (nonatomic , copy) NSString              * teacherurl;
@property (nonatomic , assign) NSInteger              course_count;
@property (nonatomic,copy) NSString *realname;
@property (nonatomic,copy) NSString *teacprofessional;
@property (nonatomic,assign) BOOL isspecialgrade;
@property (nonatomic,copy) NSString *iconurl;

@end

NS_ASSUME_NONNULL_END
