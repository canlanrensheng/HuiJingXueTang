//
//  BaseNavigationViewController.m
//  ZhuanMCH
//
//  Created by txooo on 16/9/12.
//  Copyright © 2016年 张金山. All rights reserved.
//

#import "BaseNavigationViewController.h"

@interface BaseNavigationViewController ()

@end

@implementation BaseNavigationViewController

+(void)initialize{
    [self setupTheNav];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+(void)setupTheNav{
    //设置导航条背景
    UINavigationBar *navBar = [UINavigationBar appearance];
    //设置导航栏图片的话
    [navBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                    white_color,
                                    NSForegroundColorAttributeName,
                                    [UIFont boldSystemFontOfSize:font(18)],
                                    NSFontAttributeName ,nil]];
    navBar.tintColor = white_color;
    //[navBar setBarTintColor:NavigationBar_Color];
    [navBar setBackgroundImage:[UIImage imageWithColor:NavigationBar_Color] forBarMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[UIImage new]];
    

}
#pragma mark------重写系统方法
-(BOOL)shouldAutorotate{
    return [self.visibleViewController shouldAutorotate];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.visibleViewController preferredInterfaceOrientationForPresentation];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (![self.visibleViewController isKindOfClass:[UIAlertController class]]) {//iOS9 UIWebRotatingAlertController
        return [self.visibleViewController supportedInterfaceOrientations];
    }else{
        return UIInterfaceOrientationMaskPortrait;
    }
}

-(void)popSelf {
    [self popViewControllerAnimated:YES];
}

-(UIBarButtonItem*)createBackButton{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 26, 40);
    [backButton setImage:[UIImage imageNamed:@"back_n"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"back_p"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(popSelf) forControlEvents:UIControlEventTouchUpInside];
    [backButton addTarget:self action:@selector(highlightClick:) forControlEvents:UIControlEventAllTouchEvents];
    return [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

//去掉返回按钮的点击的高亮的效果
- (void)highlightClick:(UIButton *)button{
    button.highlighted = NO;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count >= 1) {
        viewController.navigationItem.hidesBackButton = YES;
        viewController.navigationItem.leftBarButtonItem = [self createBackButton];
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
    if (viewController.navigationItem.backBarButtonItem == nil && [self.viewControllers count] > 1) {
    viewController.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
