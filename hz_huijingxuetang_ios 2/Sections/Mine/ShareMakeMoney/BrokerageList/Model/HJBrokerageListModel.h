//
//  HJBrokerageListModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/3.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJBrokerageListModel : BaseModel

@property (nonatomic , copy) NSString              * userid;
@property (nonatomic , copy) NSString              * entkbn;
@property (nonatomic , copy) NSString              * brokerageListId;
@property (nonatomic , assign) CGFloat              commissionmoney;
@property (nonatomic , assign) CGFloat              freezingamount;
@property (nonatomic , assign) NSInteger              courseamount;
@property (nonatomic , copy) NSString              * createtime;
@property (nonatomic , copy) NSString              *datadaterange;
@property (nonatomic,copy) NSString *cycletime;

@end

NS_ASSUME_NONNULL_END
