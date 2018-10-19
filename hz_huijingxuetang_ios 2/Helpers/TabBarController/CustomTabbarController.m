//
//  CustomTabbarController.m
//  Zhuan
//
//  Created by txooo on 15/12/21.
//  Copyright © 2015年 张金山. All rights reserved.
//

#import "CustomTabbarController.h"
#import "YAZLNavigationController.h"
#import "HomePageViewController.h"
#import "InformationPageViewController.h"
#import "MePageViewController.h"
#import "LivePageViewController.h"
#import "SchoolPageViewController.h"

#import "BaseNavigationViewController.h"

@interface CustomTabbarController ()<UITabBarControllerDelegate>
@property (strong, nonatomic) NSMutableArray *controllers;

@end

@implementation CustomTabbarController


- (NSMutableArray *)controllers{
    if (!_controllers) {
        
//        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        // 2.通过标识符找到对应的页面
        HomePageViewController *vc = [[HomePageViewController alloc] init];
        //    HomePageViewController *vc1 = [[HomePageViewController alloc]init];
        YAZLNavigationController *nvc1 = [[YAZLNavigationController alloc]initWithRootViewController:vc];
        nvc1.tabBarItem.title=@"首页";
        vc.view.backgroundColor=ALLViewBgColor;
        nvc1.tabBarItem.image = [UIImage imageNamed:@"image1"];
        nvc1.tabBarItem.selectedImage = [UIImage imageNamed:@"image2"];
        [vc.navigationController setNavigationBarHidden:YES];
        
        LivePageViewController *vc2 = [[LivePageViewController alloc]init];
        YAZLNavigationController *nvc2 = [[YAZLNavigationController alloc]initWithRootViewController:vc2];
        vc2.view.backgroundColor=ALLViewBgColor;
        nvc2.tabBarItem.title = @"直播";
        nvc2.tabBarItem.image = [UIImage imageNamed:@"image3"];
        nvc2.tabBarItem.selectedImage = [UIImage imageNamed:@"image4"];
        
        [vc2.navigationController setNavigationBarHidden:YES];
        
        
        
        SchoolPageViewController *vc3 = [[SchoolPageViewController alloc]init];
        YAZLNavigationController *nvc3 = [[YAZLNavigationController alloc]initWithRootViewController:vc3];
        vc3.view.backgroundColor=ALLViewBgColor;
        nvc3.tabBarItem.title=@"学堂";
        nvc3.tabBarItem.image = [UIImage imageNamed:@"image5"];
        nvc3.tabBarItem.selectedImage = [UIImage imageNamed:@"image6"];
        [vc3.navigationController setNavigationBarHidden:YES];
        
        // 2.通过标识符找到对应的页面
        UIViewController *vc4 = [[InformationPageViewController alloc] init];
        YAZLNavigationController *nvc4 = [[YAZLNavigationController alloc]initWithRootViewController:vc4];
        vc4.view.backgroundColor=ALLViewBgColor;
        nvc4.tabBarItem.title=@"资讯";
        nvc4.tabBarItem.image = [UIImage imageNamed:@"image7"];
        nvc4.tabBarItem.selectedImage = [UIImage imageNamed:@"image8"];
        [vc4.navigationController setNavigationBarHidden:YES];
        
        
        MePageViewController *vc5 = [[MePageViewController alloc]init];
        YAZLNavigationController *nvc5 = [[YAZLNavigationController alloc]initWithRootViewController:vc5];
        nvc5.tabBarItem.title=@"我的";
        nvc5.tabBarItem.selectedImage = [UIImage imageNamed:@"image10"];
        nvc5.tabBarItem.image = [UIImage imageNamed:@"image9"];
        vc5.navigationItem.title = @"个人中心";
        vc5.view.backgroundColor = ALLViewBgColor;
        
        _controllers = [NSMutableArray arrayWithArray:@[nvc1,nvc2,nvc3,nvc4,nvc5]];
    }
    return _controllers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.fd_prefersNavigationBarHidden = YES;
    self.tabBar.tintColor = NavAndBtnColor;
    
    self.viewControllers = self.controllers;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    self.tabBar.hidden = NO;
    
}

- (UITabBarItem *)setTabbarItemWithTitle:(NSString *)title withImage:(NSString *)image withSelectImage:(NSString *)selectImage{
    UITabBarItem *tabbarItem = [[UITabBarItem alloc]initWithTitle:title image:[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]selectedImage:[[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    return tabbarItem;
}


@end
