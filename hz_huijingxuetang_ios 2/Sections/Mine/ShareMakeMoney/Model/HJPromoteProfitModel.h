//
//  HJPromoteProfitModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/4.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJPromoteProfitModel : BaseModel

@property (nonatomic , assign) CGFloat              lastmonthaccount;
@property (nonatomic , assign) NSInteger              commCount;
@property (nonatomic , assign) NSInteger              orderCount;
@property (nonatomic , assign) CGFloat              canWithedSum;
@property (nonatomic , assign) CGFloat              freezingsum;

@end

NS_ASSUME_NONNULL_END
