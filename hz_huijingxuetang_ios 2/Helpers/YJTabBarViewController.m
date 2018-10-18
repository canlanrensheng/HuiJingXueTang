//
//  YJTabBarViewController.m
//  HuiJingSchool
//
//  Created by 陈燕军 on 2018/6/14.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "YJTabBarViewController.h"
#import "HomePageViewController.h"
#import "YAZLNavigationController.h"
@interface YJTabBarViewController ()<UITabBarDelegate>

@end

@implementation YJTabBarViewController
{
    NSInteger currentIndex;
    int i;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    i = 0;
    // Do any additional setup after loading the view.
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    i++;
    UIViewController *tbSelectedController = tabBarController.selectedViewController;
    if ([tbSelectedController isEqual:viewController]) {
        if (currentIndex == 1 && tabBarController.selectedIndex == 1 && i % 2 != 0) {
            YAZLNavigationController *nav = self.viewControllers[1];
            HomePageViewController *VC = nav.viewControllers[0];
            [VC loadnew];
        }
        currentIndex = tabBarController.selectedIndex;
        return NO;
    }
    i = 1;
    return YES;
}

@end
