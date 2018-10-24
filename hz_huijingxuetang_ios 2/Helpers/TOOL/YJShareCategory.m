//
//  YJShareCategory.m
//  TennisClass
//
//  Created by Junier on 2017/12/14.
//  Copyright © 2017年 陈燕军. All rights reserved.
//

#import "YJShareCategory.h"
#import "LoginViewController.h"

@implementation YJShareCategory

+(void)JumploginWhichVC:(UIViewController *)whichvc{
    //登录界面
    LoginViewController *loginvc = [[LoginViewController alloc]init];
    loginvc.view.frame = CGRectMake(0, 0, kW, kH);
    [loginvc.navigationController setNavigationBarHidden:YES];
    
    [whichvc.navigationController pushViewController:loginvc animated:YES];

}

+(void)JumploginWhichVC:(UIViewController *)whichvc andtype:(NSString *)type{
    SVDismiss;
    //登录界面
    LoginViewController *loginvc = [[LoginViewController alloc]init];
    loginvc.type = type;
    loginvc.view.frame = CGRectMake(0, 0, kW, kH);
//    [loginvc.navigationController setNavigationBarHidden:YES];
    
    [whichvc.navigationController  pushViewController:loginvc animated:YES];
    
}

+ (UIWindow *)lastWindow
{
    NSArray *windows = [UIApplication sharedApplication].windows;
    for(UIWindow *window in [windows reverseObjectEnumerator]) {
        
        if ([window isKindOfClass:[UIWindow class]] &&
            CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds))
            
            return window;
    }
    return [UIApplication sharedApplication].keyWindow;
}

@end
