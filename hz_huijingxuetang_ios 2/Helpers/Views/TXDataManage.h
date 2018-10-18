//
//  DataManage.h
//  ZhuanMCH
//
//  Created by txooo on 16/9/7.
//  Copyright © 2016年 张金山. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXDataManage : NSObject
+(TXDataManage*)shareManage;
- (void)writeObject:(id)object withKey:(NSString *)key;
- (void)archiveObject:(id)object withFileName:(NSString *)fileName;
- (id)readObjectForKey:(NSString *)key;
- (id)unarchiveObjectWithFileName:(NSString *)fileName;
- (BOOL)existObjectForKey:(NSString *)key;
- (BOOL)existObjectForFileName:(NSString *)fileName;
- (BOOL)existObject:(id)object withKey:(NSString *)key;
- (BOOL)existObject:(id)object withFileName:(NSString *)fileName;
- (void)removeObjectWithFileName:(NSString *)fileName;
- (void)removeObjectWithKey:(NSString *)key;
@end
