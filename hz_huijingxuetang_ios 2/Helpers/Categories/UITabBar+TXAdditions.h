//
//  UITabBar+TXAdditions.h
//  TXToolbox
//
//  Created by txooo on 17/5/15.
//  Copyright © 2017年 张金山. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (TXAdditions)

- (void)showBadgeValueAtIndex:(int)index value:(NSString *)value;

- (void)hideBadgeValueAtIndex:(int)index;

@end
