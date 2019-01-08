//
//  HJMyCardVoucherModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/26.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJMyCardVoucherModel : BaseModel

@property (nonatomic , copy) NSString              * myCardVoucherId;
@property (nonatomic , copy) NSString              * createtime;
@property (nonatomic , copy) NSString              * expire;
@property (nonatomic , assign) NSInteger              pricecondition;
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , copy) NSString              * price;
@property (nonatomic , copy) NSString              * cpname;
@property (nonatomic , copy) NSString              * useplace;
@property (nonatomic , copy) NSString              * servicedays;
@property (nonatomic , copy) NSString              * beginuseredtime;
@property (nonatomic , assign) NSInteger              validity;
@property (nonatomic , copy) NSString              * entkbn;

@end

NS_ASSUME_NONNULL_END
