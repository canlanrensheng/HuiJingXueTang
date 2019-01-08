//
//  HJMessageModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/7.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJMessageModel : BaseModel

@property (nonatomic , copy) NSString              * content;
@property (nonatomic , assign) NSInteger              type;
@property (nonatomic , assign) NSInteger              messCount;


@end

NS_ASSUME_NONNULL_END
