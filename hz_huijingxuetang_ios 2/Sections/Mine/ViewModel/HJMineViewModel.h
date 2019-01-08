//
//  HJMineViewModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/7.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseTableViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJMineViewModel : BaseTableViewModel

//获取用户信息
- (void)getUserInfoWithSuccess:(void (^)(void))success;


@end

NS_ASSUME_NONNULL_END
