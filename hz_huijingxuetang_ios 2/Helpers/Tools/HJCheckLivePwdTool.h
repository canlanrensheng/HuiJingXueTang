//
//  HJCheckLivePwd.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/30.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HJCheckLivePwdTool : NSObject

+ (instancetype)shareInstance;
- (void)checkLivePwdWithPwd:(NSString *)pwd courseId:(NSString *)courseId success:(void (^)(BOOL isSetPwd))success error:(void (^)(void))error;

@end

NS_ASSUME_NONNULL_END
