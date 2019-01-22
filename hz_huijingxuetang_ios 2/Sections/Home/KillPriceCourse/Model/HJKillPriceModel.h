//
//  HJKillPriceModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2019/1/14.
//  Copyright © 2019年 Junier. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJKillPriceModel : BaseModel

@property (nonatomic , assign) NSInteger              browsingcount;
@property (nonatomic , copy) NSString              * starttime;
@property (nonatomic , copy) NSString              * endtime;
@property (nonatomic , copy) NSString              * coursepic;
@property (nonatomic , copy) NSString              * coursescore;
@property (nonatomic , assign) CGFloat              coursemoney;
@property (nonatomic , copy) NSString              * secondprice;
@property (nonatomic , copy) NSString              * coursename;
@property (nonatomic , assign) NSInteger             hassecond;
@property (nonatomic , copy) NSString              * courseid;
@property (nonatomic , assign) CGFloat              bargaintoprice;
@property (nonatomic , assign) CGFloat              savedAmount;
@property (nonatomic , assign) NSInteger              periods;

@property (nonatomic , copy) NSString              * starlevel;
@property (nonatomic , copy) NSString              * realname;

@end

NS_ASSUME_NONNULL_END
