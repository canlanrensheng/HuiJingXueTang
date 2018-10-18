//
//  DataManage.m
//  ZhuanMCH
//
//  Created by txooo on 16/9/7.
//  Copyright © 2016年 张金山. All rights reserved.
//

#import "TXDataManage.h"

@implementation TXDataManage
+(TXDataManage*)shareManage {
    static  TXDataManage * manage;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manage = [[TXDataManage alloc] init];
    });
    return manage;
}

- (void)writeObject:(id)object withKey:(NSString *)key{
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    [df setObject:object forKey:key];
    [df synchronize];
}

- (void)archiveObject:(id)object withFileName:(NSString *)fileName{
    NSString *localPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName];
    [NSKeyedArchiver archiveRootObject:object toFile:localPath];
}

- (id)readObjectForKey:(NSString *)key{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:key];
}

- (id)unarchiveObjectWithFileName:(NSString *)fileName{
    NSString *localPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:localPath];
}

- (BOOL)existObjectForKey:(NSString *)key{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ([ud objectForKey:key]) {
        return YES;
    }
    return NO;
}

- (BOOL)existObjectForFileName:(NSString *)fileName{
    NSString *localPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName];
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if ([defaultManager fileExistsAtPath:localPath]){
        return YES;
    }
    return NO;
}

- (BOOL)existObject:(id)object withKey:(NSString *)key{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSArray *array = [ud objectForKey:key];
    if ([array containsObject:object]) {
        return YES;
    }
    return NO;
}

- (BOOL)existObject:(id)object withFileName:(NSString *)fileName{
    NSString *localPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName];
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:localPath];
    if ([array containsObject:object]) {
        return YES;
    }
    return NO;
}

- (void)removeObjectWithFileName:(NSString *)fileName{
    NSString *localPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName];
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if ([defaultManager isDeletableFileAtPath:localPath]) {
        [defaultManager removeItemAtPath:localPath error:nil];
    }
}

- (void)removeObjectWithKey:(NSString *)key{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    if ([user objectForKey:key]) {
        [user removeObjectForKey:key];
        [user synchronize];
    }
}

@end
