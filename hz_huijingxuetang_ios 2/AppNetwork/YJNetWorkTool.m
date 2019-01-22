//
//  YJNetWorkTool.m
//  Beidou
//
//  Created by Junier on 2017/12/4.
//  Copyright © 2017年 陈燕军. All rights reserved.
//

#import "YJNetWorkTool.h"
#define RequestTimeoutInterval 20
#define NOTNETMESSAGE @"网络不给力，请稍后再试"

@implementation YJNetWorkTool
+ (instancetype)sharedTool {
    static id instance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithBaseURL:nil];
        
    });
    
    return instance;
}

- (void)requestWithURLString: (NSString *)URLString
                  parameters: (NSDictionary *)parameters
                      method: (NSString *)method
                    callBack: (void (^)(id))callBack
                        fail:(void (^)(id))erorblock{

    self.requestSerializer = [AFJSONRequestSerializer serializer];
    self.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.responseSerializer = [AFCompoundResponseSerializer serializer];
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.requestSerializer.timeoutInterval = 30.0;//设置网络超时
    
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    self.securityPolicy = securityPolicy;
    
    //判断请求方法是GET还是POST
    if ([method isEqualToString:@"GET"]) {
        //调用AFN框架的方法
        [self GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            hideHud();
            NSString  *url = URLString;
            if(parameters) {
                NSUInteger paraCount = parameters.allKeys.count;
                if(paraCount > 0) {
                    if( paraCount == 1) {
                        for (NSString * key in parameters.allKeys){
                            url = [NSString stringWithFormat:@"%@?%@=%@",URLString,key,[parameters objectForKey:key]];
                        }
                    } else {
                        for ( int i = 0;i < paraCount; i++){
                            NSString *key = parameters.allKeys[i];
                            if(i == 0) {
                                url = [NSString stringWithFormat:@"%@?%@=%@",URLString,key,[parameters objectForKey:key]];
                            } else {
                                url = [NSString stringWithFormat:@"%@&%@=%@",url,key,[parameters objectForKey:key]];
                            }
                        }
                    }
                }
            }
            DLog(@"获取到的请求的url是:%@",url);
            if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
                erorblock(NOTNETMESSAGE);
            }
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 10) {
                ShowMessage(@"未登陆或登录已过期，请重新登录");
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if([UserInfoSingleObject shareInstance].isLogined == NO){
                        [APPUserDataIofo writeAccessToken:@""];
                        [UserInfoSingleObject shareInstance].isLogined = YES;
                        [DCURLRouter pushURLString:@"route://loginVC" animated:YES];
                    }
                });
            }
            callBack(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //如果请求失败，控制台打印错误信息
            
            DLog(@"获取到网络错误的链接是:%@",URLString);
            hideHud();
            erorblock(error.localizedDescription);
//            DLog(@"%@",error.localizedDescription);
        }];
    }
    
    //Post请求的底层的封装
    if ([method isEqualToString:@"POST"]) {
        [self POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            hideHud();
            if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
                erorblock(NOTNETMESSAGE);
            }
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"] integerValue];
            if (code == 10) {
                DLog(@"去登陆的请求的url是:%@",URLString);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if([UserInfoSingleObject shareInstance].isLogined == NO){
                        [APPUserDataIofo writeAccessToken:@""];
                        [UserInfoSingleObject shareInstance].isLogined = YES;
                        [DCURLRouter pushURLString:@"route://loginVC" animated:YES];
                    }
                });
            }
            callBack(responseObject);

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            hideHud();
//            DLog(@"获取到网络错误的链接是:%@ %ld %@",error.localizedDescription,error.code,error.userInfo);
            NSData * data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
            NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            DLog(@"获取到网络错误的链接是:%@",str);
            
            erorblock(error.localizedDescription);
            NSLog(@"%@",error);
        }];
    }
}

/**
 创建上传请求方法
 */
- (void)requestWithURLString: (NSString *)URLString
                  parameters: (NSDictionary *)parameters
                     imgdata: (UIImage *)img
                    callBack: (void(^)(id responseObject))callBack
                        fail:(void (^)(id error))erorblock{
    
    self.requestSerializer.timeoutInterval = 30.0;//设置网络超时
    
//    //设置带蒙版
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
//    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
//    [SVProgressHUD setMinimumDismissTimeInterval:2.0];
//    [SVProgressHUD setBackgroundColor:RGBA(206, 206, 206, 0.9)];
//    SVShow;
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                          @"text/html",
                                                          @"image/jpeg",
                                                          @"image/png",
                                                          @"application/octet-stream",
                                                          @"text/json",nil];
    [self POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            NSData *imageData = UIImageJPEGRepresentation(img,1);
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat =@"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            
            //上传的参数(上传图片，以文件流的格式)
            [formData appendPartWithFileData:imageData
                                        name:@"file"
                                    fileName:fileName
                                    mimeType:@"image/jpeg"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            //上传进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //上传成功
            if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
                
                erorblock(NOTNETMESSAGE);
                
                ShowMessage(NOTNETMESSAGE);
                return;
            }
            //如果请求成功，则回调responseObject
            callBack(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //上传失败
            erorblock(error);
            NSLog(@"%@",error);
        }];
}
@end
