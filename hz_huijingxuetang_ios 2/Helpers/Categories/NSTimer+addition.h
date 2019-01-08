//
//  NSTimer+addition.h
//  MKnight
//
//  Created by 张金山 on 2018/1/25.
//  Copyright © 2018年 张金山. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (addition)

- (void)pause;
- (void)resume;
- (void)resumeWithTimeInterval:(NSTimeInterval)time;

@end
