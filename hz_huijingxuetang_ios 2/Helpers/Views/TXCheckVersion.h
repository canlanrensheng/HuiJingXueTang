//
//  CheckVersion.h
//  Zhuan
//
//  Created by txooo on 16/6/27.
//  Copyright © 2016年 张金山. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXCheckVersion : NSObject

+ (instancetype)sharedCheckManager;
- (void)checkVersion;

@end
