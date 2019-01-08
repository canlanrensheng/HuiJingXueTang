//
//  BMSingleObject.m
//  BM
//
//  Created by txooo on 17/3/1.
//  Copyright © 2017年 张金山. All rights reserved.
//

#import "UserInfoSingleObject.h"
#import <SystemConfiguration/CaptiveNetwork.h>
//#import <JPush/JPUSHService.h>


@implementation UserInfoSingleObject

+(instancetype)shareInstance{
    static UserInfoSingleObject *object = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object = [[UserInfoSingleObject alloc]init];
    });
    return object;
}

- (instancetype)init{
    if (self = [super init]) {
        [[[RACObserve(self, networkStatus) distinctUntilChanged] skip:2] subscribeNext:^(id x) {
            switch ([x integerValue]) {
                case NotReachable:
//                    ShowMessage(@"网络已失去连接");
                    [MBProgressHUD showMessage:@"网络已失去连接" view:[UIApplication sharedApplication].keyWindow];
//                    [SVProgressHUD showInfoWithStatus:@"网络已失去连接"];
                    break;
                case ReachableViaWiFi:
//                    ShowMessage(string(@"已连接WiFi-",[self getWifiName]));
                    [MBProgressHUD showMessage:@"已连接WiFi" view:[UIApplication sharedApplication].keyWindow];
//                    [SVProgressHUD showInfoWithStatus:string(@"已连接WiFi-",[self getWifiName])];
                    break;
                default:
//                    ShowMessage(@"已开启数据连接");
                    [MBProgressHUD showMessage:@"已开启数据连接" view:[UIApplication sharedApplication].keyWindow];
//                    [SVProgressHUD showInfoWithStatus:@"网络已失去连接"];
                    break;
            }
        }];
    }
    return self;
}

-(void)setUserInfo:(NSDictionary *)userInfo{
    NSUserDefaults *user =[NSUserDefaults standardUserDefaults];
    [user setObject:[self processDictionaryIsNSNull:userInfo] forKey:@"USER_INFO"];
    [user synchronize];
}

- (id) processDictionaryIsNSNull:(id)obj{
    const NSString *blank = @"";
    
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dt = [(NSMutableDictionary*)obj mutableCopy];
        for(NSString *key in [dt allKeys]) {
            id object = [dt objectForKey:key];
            if([object isKindOfClass:[NSNull class]]) {
                [dt setObject:blank
                       forKey:key];
            }
            else if ([object isKindOfClass:[NSString class]]){
                NSString *strobj = (NSString*)object;
                if ([strobj isEqualToString:@"<null>"]) {
                    [dt setObject:blank
                           forKey:key];
                }
            }
            else if ([object isKindOfClass:[NSArray class]]){
                NSArray *da = (NSArray*)object;
                da = [self processDictionaryIsNSNull:da];
                [dt setObject:da
                       forKey:key];
            }
            else if ([object isKindOfClass:[NSDictionary class]]){
                NSDictionary *ddc = (NSDictionary*)object;
                ddc = [self processDictionaryIsNSNull:object];
                [dt setObject:ddc forKey:key];
            }
        }
        return [dt copy];
    }
    else if ([obj isKindOfClass:[NSArray class]]){
        NSMutableArray *da = [(NSMutableArray*)obj mutableCopy];
        for (int i=0; i<[da count]; i++) {
            NSDictionary *dc = [obj objectAtIndex:i];
            dc = [self processDictionaryIsNSNull:dc];
            [da replaceObjectAtIndex:i withObject:dc];
        }
        return [da copy];
    }
    else{
        return obj;
    }
}

- (void)configThirdPartInfo {
    //设置设备别名
//    [JPUSHService setTags:[NSSet setWithObject:userId] completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
//        DLog(@"%tu,%@,%tu",iResCode,iTags,seq);
//    } seq:0];
}

-(NSDictionary *)GetUserInfo{
    NSUserDefaults *user =[NSUserDefaults standardUserDefaults];
    return [user dictionaryForKey:@"USER_INFO"];
}


-(void)clearUserInfo{
    DLog(@"清除用户信息");
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:@"USER_INFO"];
    [user synchronize];
}

- (NSString *)getWifiName {
    NSString *wifiName = nil;
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    if (!wifiInterfaces) {
        return nil;
    }
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            NSLog(@"network info -> %@", networkInfo);
            wifiName = [networkInfo objectForKey:(__bridge NSString*)kCNNetworkInfoKeySSID];
            CFRelease(dictRef);
        }
    }
    CFRelease(wifiInterfaces);
    return wifiName;
}

@end
