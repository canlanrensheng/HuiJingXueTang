//
//  ShareManager.h
//  ITelematics
//
//  Created by Oma-002 on 2018/9/4.
//  Copyright © 2018年 com.lima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>

typedef void (^ShareSuccessBlock)(void);
typedef void (^ShareFailureBlock)(void);

@interface ShareManager : NSObject

+ (instancetype)shareManager;

- (void)shareOperation:(SSDKPlatformType)platformType title:(NSString *)title message:(NSString *)message imgs:(NSArray *)imgs url:(NSString *)url shareSuccessBlock:(ShareSuccessBlock)shareSuccessBlock shareFailureBlock:(ShareFailureBlock)shareFailureBlock;

@end
