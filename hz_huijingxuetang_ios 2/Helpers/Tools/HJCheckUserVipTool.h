//
//  HJCheckUserVipTool.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/13.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HJCheckUserVipTool : NSObject

+ (instancetype)shareInstance;
- (void)checkUserVipWithSuccess:(void (^)(int vipNum))success;

@end

NS_ASSUME_NONNULL_END
