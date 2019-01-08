//
//  HJSchoolCourseListModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/14.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface Courselist :BaseModel

@property (nonatomic , copy) NSString              * userid;
@property (nonatomic , copy) NSString              * courseid;
@property (nonatomic , copy) NSString              * iconurl;
@property (nonatomic , copy) NSString              * starlevel;
@property (nonatomic , copy) NSString              * coursedes;
@property (nonatomic , copy) NSString              * updatetime;
@property (nonatomic , copy) NSString              * coursepic;
@property (nonatomic , copy) NSString              * starttime;
@property (nonatomic , copy) NSString              * endtime;
@property (nonatomic , copy) NSString              * realname;
@property (nonatomic , copy) NSString              * endtime_fmt;
@property (nonatomic , copy) NSString              * starttime_fmt;
@property (nonatomic , assign) NSInteger              browsingcount;
@property (nonatomic , copy) NSString              * coursename;
@property (nonatomic , copy) NSString              * coursekind;
@property (nonatomic , assign) NSInteger              courselimit;
@property (nonatomic , assign) NSInteger              thumbsupcount;
@property (nonatomic , assign) NSInteger              hassecond;
@property (nonatomic , copy) NSString              * secondprice;
@property (nonatomic , assign) CGFloat              coursemoney;
@property (nonatomic , copy) NSString              * introduction;
@property (nonatomic , copy) NSString              * praise;
@property (nonatomic , assign) NSInteger              periods;

@end

@interface Price :BaseModel

@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * priceId;

@end

@interface HJSchoolCourseListModel : BaseModel

@property (nonatomic , strong) NSArray<Courselist *>              * courselist;
@property (nonatomic , assign) NSInteger              totalpage;
@property (nonatomic , strong) NSArray<Price *>              * price;

@end

NS_ASSUME_NONNULL_END
