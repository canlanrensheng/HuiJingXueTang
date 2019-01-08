//
//  HJPromoteInfoModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/3.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJPromoteInfoModel : BaseModel

@property (nonatomic , assign) NSInteger              ordercount;
@property (nonatomic , copy) NSString              * datadaterange;
@property (nonatomic , assign) NSInteger              commcount;
@property (nonatomic , copy) NSString              * date;
@property (nonatomic,copy) NSString *cycletime;

@end

NS_ASSUME_NONNULL_END
