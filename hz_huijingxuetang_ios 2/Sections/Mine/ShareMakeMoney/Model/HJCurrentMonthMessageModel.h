//
//  HJCurrentMonthMessageModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/3.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJCurrentMonthMessageModel : BaseModel

@property (nonatomic,copy) NSString *commCount;
@property (nonatomic,copy) NSString *orderCount;

@end

NS_ASSUME_NONNULL_END
