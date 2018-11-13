//
//  CustomTabbarController.m
//  Zhuan
//
//  Created by txooo on 15/12/21.
//  Copyright © 2015年 张金山. All rights reserved.
//

#import "CustomTabbarController.h"
#import "HomePageViewController.h"

#import "HJMineViewController.h"
#import "HJSchoolViewController.h"
#import "HJFindViewController.h"
#import "HJInfoViewController.h"
#import "BaseNavigationViewController.h"

@interface CustomTabbarController ()<UITabBarControllerDelegate>
@property (strong, nonatomic) NSMutableArray *controllers;

@end

@implementation CustomTabbarController


- (NSMutableArray *)controllers{
    if (!_controllers) {
        //首页
        HomePageViewController *vc = [[HomePageViewController alloc] init];
        BaseNavigationViewController *nvc1 = [[BaseNavigationViewController alloc]initWithRootViewController:vc];
        nvc1.tabBarItem = [self setTabbarItemWithTitle:@"首页" withImage:@"首页未选中" withSelectImage:@"首页选中"];
        [vc.navigationController setNavigationBarHidden:YES];
        
        //学堂
        HJSchoolViewController *vc2 = [[HJSchoolViewController alloc]init];
        BaseNavigationViewController *nvc2 = [[BaseNavigationViewController alloc]initWithRootViewController:vc2];
        nvc2.tabBarItem = [self setTabbarItemWithTitle:@"学堂" withImage:@"学堂未选中" withSelectImage:@"学堂选中"];
        [vc2.navigationController setNavigationBarHidden:YES];
        
        //发现
        HJFindViewController *vc3 = [[HJFindViewController alloc]init];
        BaseNavigationViewController *nvc3 = [[BaseNavigationViewController alloc]initWithRootViewController:vc3];
        nvc3.tabBarItem = [self setTabbarItemWithTitle:@"发现" withImage:@"发现未选中" withSelectImage:@"发现选中"];
        [vc3.navigationController setNavigationBarHidden:YES];
        
        //资讯
        HJInfoViewController *vc4 = [[HJInfoViewController alloc] init];
        BaseNavigationViewController *nvc4 = [[BaseNavigationViewController alloc]initWithRootViewController:vc4];
        nvc4.tabBarItem = [self setTabbarItemWithTitle:@"资讯" withImage:@"资讯下未选中" withSelectImage:@"资讯选中"];
        [vc4.navigationController setNavigationBarHidden:YES];
        
        //我的
        HJMineViewController *vc5 = [[HJMineViewController alloc]init];
        BaseNavigationViewController *nvc5 = [[BaseNavigationViewController alloc]initWithRootViewController:vc5];
        nvc5.tabBarItem = [self setTabbarItemWithTitle:@"我的" withImage:@"我的未选中" withSelectImage:@"我的选中"];
        vc5.view.backgroundColor = ALLViewBgColor;
        
       
        _controllers = [NSMutableArray arrayWithArray:@[nvc1,nvc2,nvc3,nvc4,nvc5]];
    }
    return _controllers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.fd_prefersNavigationBarHidden = YES;
    self.tabBar.tintColor = NavigationBar_Color;
    
    self.viewControllers = self.controllers;
    
    [self.tabBar showBadgeValueAtIndex:4 value:@""];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    self.tabBar.hidden = NO;
    
//    if(self.selectedIndex == 4){
//        if([APPUserDataIofo AccessToken].length <= 0) {
//            ShowMessage(@"您还未登录");
//            [DCURLRouter pushURLString:@"route://loginVC" animated:YES];
//            return;
//        }
//    }
}

- (UITabBarItem *)setTabbarItemWithTitle:(NSString *)title withImage:(NSString *)image withSelectImage:(NSString *)selectImage{
    UITabBarItem *tabbarItem = [[UITabBarItem alloc]initWithTitle:title image:[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]selectedImage:[[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    return tabbarItem;
}


@end
