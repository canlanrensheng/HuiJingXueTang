//
//  BMSingleObject.h
//  BM
//
//  Created by txooo on 17/3/1.
//  Copyright © 2017年 张金山. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Reachability/Reachability.h>

@interface UserInfoSingleObject : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, assign) NetworkStatus networkStatus;

@property (nonatomic, assign) NSInteger bagdeValue;


- (void)setUserInfo:(NSDictionary *)userInfo;

- (void)configThirdPartInfo;

- (NSDictionary *)GetUserInfo;

- (void)clearUserInfo;

- (NSString *)getWifiName;

@end
