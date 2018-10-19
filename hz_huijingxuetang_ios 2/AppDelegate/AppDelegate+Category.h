//
//  AppDelegate+Category.h
//  MK100
//
//  Created by 张金山 on 2018/1/8.
//  Copyright © 2018年 txooo. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Category)

//设置跟视图控制器
- (void)setRootViewController:(UIApplication *)application;

//设置3D Touch
- (void)setup3DTouch:(UIApplication *)application;

- (void)performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem;

@end
