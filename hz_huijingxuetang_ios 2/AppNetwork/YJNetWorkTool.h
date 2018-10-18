//
//  YJNetWorkTool.h
//  Beidou
//
//  Created by Junier on 2017/12/4.
//  Copyright © 2017年 陈燕军. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface YJNetWorkTool : AFHTTPSessionManager
/**
 创建网络请求工具类的单例
 */
+ (instancetype)sharedTool;

/**
 创建请求方法
 */
- (void)requestWithURLString: (NSString *)URLString
                  parameters: (NSDictionary *)parameters
                      method: (NSString *)method
                    callBack: (void(^)(id responseObject))callBack
                    fail:(void (^)(id error))erorblock;

/**
 创建上传请求方法
 */
- (void)requestWithURLString: (NSString *)URLString
                  parameters: (NSDictionary *)parameters
                      imgdata: (UIImage *)img
                    callBack: (void(^)(id responseObject))callBack
                        fail:(void (^)(id error))erorblock;
@end
