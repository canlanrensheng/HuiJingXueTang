//
//  YAZLNavigationController.m
//  LaiCai
//
//  Created by yacs on 15/10/22.
//  Copyright © 2015年 laicaijie.laicai. All rights reserved.
//

#import "YAZLNavigationController.h"
#import "UUPubLogicHelper.h"
#import "HomePageViewController.h"
#import "LoginViewController.h"
#import "LiveAncientlyViewControllerViewController.h"
#import "LivePageViewController.h"
@interface YAZLNavigationController ()<UINavigationControllerDelegate>

@end

@implementation YAZLNavigationController
{
    
    UIButton *button;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [UIColor whiteColor],NSForegroundColorAttributeName,
                          [UIFont systemFontOfSize:18], NSFontAttributeName,
                          [[NSShadow alloc]init], NSShadowAttributeName,
                          nil];
    self.navigationBar.titleTextAttributes = dict;
    
//    [self.navigationBar setBackgroundImage:[UUPubLogicHelper createImageWithColor:C2BC693 cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationBar setBackgroundImage:[UUPubLogicHelper createImageWithColor:NavigationBar_Color cornerRadius:0] forBarMetrics:UIBarMetricsDefault];

    self.navigationBar.shadowImage = [[UIImage alloc]init];
    
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.delegate = self;
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 1) {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
    else {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{

    if (self.childViewControllers.count > 0&&![viewController isKindOfClass:[LoginViewController class]]) { // 如果push进来的不是第一个控制器
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"back_n"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"back_p"] forState:UIControlStateHighlighted];
        button.frame = CGRectMake(0, 0, 70, 70);
        button.tag = 1600+1;
        // 让按钮内部的所有内容左对齐
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *leftBarButtonItems = [[UIBarButtonItem alloc]initWithCustomView:button];
        //解决按钮不靠左 靠右的问题.
        UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        nagetiveSpacer.width = -10;//这个值可以根据自己需要自己调整

        viewController.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:nagetiveSpacer, leftBarButtonItems, nil];
        
        // 隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
    }

    if ([viewController isKindOfClass:[LoginViewController class]]) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    if ([viewController isKindOfClass:[LiveAncientlyViewControllerViewController class]]) {
        button.tag = 1600 + 2;
    }
    // 这句super的push要放在后面, 让viewController可以覆盖上面设置的leftBarButtonItem
    [super pushViewController:viewController animated:animated];
}

- (void)back:(UIButton *)btn{
    NSLog(@"%ld",btn.tag -1600);
    if (btn.tag - 1600 == 1) {
        [self popViewControllerAnimated:YES];
    }else{

    }
    
}


@end
