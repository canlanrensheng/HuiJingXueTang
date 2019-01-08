//
//  NSTimer+addition.m
//  MKnight
//
//  Created by 张金山 on 2018/1/25.
//  Copyright © 2018年 张金山. All rights reserved.
//

#import "NSTimer+addition.h"

@implementation NSTimer (addition)

- (void)pause {
    if (!self.isValid) return;
    [self setFireDate:[NSDate distantFuture]];
}

- (void)resume {
    if (!self.isValid) return;
    [self setFireDate:[NSDate date]];
}

- (void)resumeWithTimeInterval:(NSTimeInterval)time {
    if (!self.isValid) return;
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:time]];
}

@end
