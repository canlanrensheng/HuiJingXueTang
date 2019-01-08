//
//  HJHomeLimitKillModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/22.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJHomeLimitKillModel : BaseModel

@property (nonatomic , copy) NSString              * endtime;
@property (nonatomic , copy) NSString              * coursepic;
@property (nonatomic , assign) CGFloat              coursemoney;
@property (nonatomic , copy) NSString              * periods;
@property (nonatomic , copy) NSString              * starttime;
@property (nonatomic , copy) NSString              * courseid;
@property (nonatomic , copy) NSString              * browsingcount;
@property (nonatomic , copy) NSString              * hassecond;
@property (nonatomic , copy) NSString              * coursename;
@property (nonatomic , copy) NSString              * coursescore;
@property (nonatomic , copy) NSString              * secondprice;

@end

NS_ASSUME_NONNULL_END
