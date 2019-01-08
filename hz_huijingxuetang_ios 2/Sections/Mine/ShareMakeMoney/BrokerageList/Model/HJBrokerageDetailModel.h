//
//  HJBrokerageDetailModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/3.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJBrokerageDetailModel : BaseModel

@property (nonatomic , copy) NSString              * coursename;
@property (nonatomic , assign) NSInteger              count;
@property (nonatomic , assign) NSInteger              coursemoneysum;
@property (nonatomic , assign) CGFloat              commission;


@end

NS_ASSUME_NONNULL_END
