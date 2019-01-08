//
//  HJHomeCourseRecommendedModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/23.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJHomeCourseRecommendedModel : BaseModel

@property (nonatomic , copy) NSString              * coursepic;
@property (nonatomic , assign) CGFloat              coursemoney;
@property (nonatomic , assign) NSInteger              study_count;
@property (nonatomic , assign) NSInteger              periods;
@property (nonatomic , copy) NSString              * starlevel;
@property (nonatomic , copy) NSString              * courseid;
@property (nonatomic , copy) NSString              * realname;
@property (nonatomic , assign) NSInteger              hassecond;
@property (nonatomic , assign) NSInteger              type;
@property (nonatomic , copy) NSString              * coursename;
@property (nonatomic , copy) NSString              * secondprice;

@end

NS_ASSUME_NONNULL_END
