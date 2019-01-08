//
//  HJAccountManagerModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/4.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJAccountManagerModel : BaseModel

@property (nonatomic , assign) NSInteger              bingdingstatus;
@property (nonatomic , copy) NSString              * acccountId;
@property (nonatomic , assign) NSInteger              type;
@property (nonatomic , copy) NSString              * accountname;
@property (nonatomic , assign) NSInteger             defaultstatus;

@end

NS_ASSUME_NONNULL_END
