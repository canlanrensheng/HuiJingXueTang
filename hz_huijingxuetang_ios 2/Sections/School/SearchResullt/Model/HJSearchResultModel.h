//
//  HJSearchResultModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/16.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface InformationResponses :BaseModel
@property (nonatomic , copy) NSString              * informationId;
@property (nonatomic , copy) NSString              * picurl;
@property (nonatomic , copy) NSString              * infomationtitle;
@property (nonatomic , copy) NSString              * readcounts;
@property (nonatomic , copy) NSString              * createtime;

@end

@interface TeacherResponses :BaseModel
@property (nonatomic , assign) NSInteger              stuCount;
@property (nonatomic , copy) NSString              * teacprofessional;
@property (nonatomic , copy) NSString              * userid;
@property (nonatomic , assign) NSInteger             courCount;
@property (nonatomic , copy) NSString              * iconurl;
@property (nonatomic , copy) NSString              * realname;

@end

@interface CourseResponses :BaseModel
//@property (nonatomic , copy) NSString              * coursepic;
//@property (nonatomic , assign) NSInteger              coursemoney;
//@property (nonatomic , copy) NSString              * periods;
//@property (nonatomic , copy) NSString              * courseid;
//@property (nonatomic , assign) NSInteger              browsingcount;
//@property (nonatomic , copy) NSString              * coursename;
//@property (nonatomic , copy) NSString              * coursescore;

@property (nonatomic , copy) NSString              * coursepic;
@property (nonatomic , assign) CGFloat              coursemoney;
@property (nonatomic , assign) NSInteger              browsingcount;
@property (nonatomic , assign) NSInteger              periods;
@property (nonatomic , copy) NSString              * coursescore;
@property (nonatomic , copy) NSString              * courseid;
@property (nonatomic , copy) NSString              * realname;
@property (nonatomic , assign) NSInteger              hassecond;
@property (nonatomic , assign) NSInteger              type;
@property (nonatomic , copy) NSString              * coursename;
@property (nonatomic , copy) NSString              * secondprice;

@end

@interface CourseLiveModel :BaseModel

@property (nonatomic , copy) NSString              * a_courseid;
@property (nonatomic , copy) NSString              * periods;
@property (nonatomic , copy) NSString              * hassecond;
@property (nonatomic , copy) NSString              * coursename;
@property (nonatomic , copy) NSString              * l_starttime;
@property (nonatomic , copy) NSString              * l_endtime;
@property (nonatomic , copy) NSString              * endtime;
@property (nonatomic , copy) NSString              * coursekind;
@property (nonatomic , copy) NSString              * a_starttime;
@property (nonatomic , copy) NSString              * coursedes;
@property (nonatomic , copy) NSString              * realname;
@property (nonatomic , copy) NSString              * p_endtime;
@property (nonatomic , copy) NSString              * starttime_fmt;
@property (nonatomic , copy) NSString              * a_buzz;
@property (nonatomic , copy) NSString              * a_endtime;
@property (nonatomic , copy) NSString              * thumbsupcount;
@property (nonatomic , copy) NSString              * iconurl;
@property (nonatomic , copy) NSString              * courseid;
@property (nonatomic , copy) NSString              * p_starttime;
@property (nonatomic , copy) NSString              * endtime_fmt;
@property (nonatomic , copy) NSString              * secondprice;
@property (nonatomic , copy) NSString              * introduction;
@property (nonatomic , copy) NSString              * p_courseid;
@property (nonatomic , copy) NSString              * coursepic;
@property (nonatomic , copy) NSString              * courselimit;
@property (nonatomic , copy) NSString              * starttime;
@property (nonatomic , copy) NSString              * browsingcount;
@property (nonatomic , copy) NSString              * p_buzz;
@property (nonatomic , copy) NSString              * coursemoney;
@property (nonatomic , copy) NSString              * praise;
@property (nonatomic , copy) NSString              * starlevel;
@property (nonatomic , copy) NSString              * updatetime;
@property (nonatomic , copy) NSString              * l_courseid;
@property (nonatomic , copy) NSString              * l_buzz;
@property (nonatomic , copy) NSString              * userid;

@property (nonatomic,copy) NSString * l_livecoursename;
@property (nonatomic,copy) NSString * a_livecoursename;
@property (nonatomic,copy) NSString * p_livecoursename;

@end

@interface HJSearchResultModel :BaseModel
@property (nonatomic , strong) NSArray<InformationResponses *>              * informationResponses;
@property (nonatomic , strong) NSArray<TeacherResponses *>              * teacherResponses;
@property (nonatomic , assign) NSInteger              teacherMore;
@property (nonatomic , strong) NSArray<CourseResponses *>              * courseResponses;
@property (nonatomic , assign) NSInteger              courseMore;
@property (nonatomic , assign) NSInteger              inormationMore;
@property (nonatomic , strong) NSArray<CourseLiveModel *>          * courseLiveResponses;
@property (nonatomic , assign) NSInteger              courseLiveMore;


@end


NS_ASSUME_NONNULL_END
