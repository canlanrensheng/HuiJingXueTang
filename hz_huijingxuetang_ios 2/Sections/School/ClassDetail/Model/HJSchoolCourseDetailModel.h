//
//  HJSchoolCourseDetailModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/14.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJSchoolCourseDetailModel : BaseModel

@property (nonatomic , assign) NSInteger              periods;
@property (nonatomic , copy) NSString              * userid;
@property (nonatomic , assign) NSInteger              canbargain;
@property (nonatomic , assign) NSInteger              canpromote;
@property (nonatomic , copy) NSString              * courseid;
@property (nonatomic , copy) NSString              * iconurl;
@property (nonatomic , copy) NSString              * videourl;
@property (nonatomic , copy) NSString              * coursedes;
@property (nonatomic , copy) NSString              * videoid;
@property (nonatomic , copy) NSString              * coursepic;
@property (nonatomic , assign) CGFloat              bargaintoprice;
@property (nonatomic , copy) NSString              * starttime;
@property (nonatomic , copy) NSString              * endtime;
@property (nonatomic , copy) NSString              * buy;
@property (nonatomic , assign) NSInteger              thumbsupcount;
@property (nonatomic , assign) NSInteger              courselimit;
@property (nonatomic , copy) NSString              * loginstatus;
@property (nonatomic , assign) NSInteger              hassecond;
@property (nonatomic , copy) NSString              * secondprice;
@property (nonatomic , assign) CGFloat              coursemoney;
@property (nonatomic , copy) NSString              * introduction;
@property (nonatomic , copy) NSString              * videoppicurl;
@property (nonatomic , copy) NSString              * praise;
@property (nonatomic , copy) NSString              * username;

@property (nonatomic,assign) CGFloat teacherIntroCellHeight;
@property (nonatomic,assign) CGFloat courseCellHeight;

@end

NS_ASSUME_NONNULL_END
