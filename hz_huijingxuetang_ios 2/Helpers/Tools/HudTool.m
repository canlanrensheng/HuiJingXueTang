//
//  HudTool.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/18.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HudTool.h"

@implementation HudTool

UIViewController *VisibleViewController() {
    UIViewController *rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
    while ([rootVC isKindOfClass:[UINavigationController class]]) {
        rootVC = [(UINavigationController *)rootVC visibleViewController];
    }
    while ([rootVC isKindOfClass:[UITabBarController class]]) {
        rootVC = [(UITabBarController *)rootVC selectedViewController];
        if ([rootVC isKindOfClass:[UINavigationController class]]) {
            rootVC = [(UINavigationController *)rootVC visibleViewController];
        }
    }
    return rootVC;
}

@end
