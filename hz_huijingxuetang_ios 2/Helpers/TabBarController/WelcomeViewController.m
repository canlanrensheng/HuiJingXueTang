//
//  WelcomeViewController.m
//  Zhuan
//
//  Created by txooo on 16/1/11.
//  Copyright © 2016年 领琾. All rights reserved.
//

#import "WelcomeViewController.h"
#import "LoginViewController.h"
#import "BaseNavigationViewController.h"
#import "CustomTabbarController.h"
#import "TXCheckVersion.h"
//static const NSInteger ImageCount  = 2;

@interface WelcomeViewController ()<UIScrollViewDelegate>
{
    UIView *pageView;
}

@property (nonatomic,assign) NSInteger imageCount;

@end

@implementation WelcomeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏状态栏
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageCount = MaJia ? 2 : 3;
    //添加UISrollView
    [self setupScrollView];
}

/**
 *  添加UISrollView
 */
- (void)setupScrollView{
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.frame = self.view.bounds;
    [self.view addSubview:scrollView];
    scrollView.delegate = self;
    
    //2.添加图片
    CGFloat imageW = scrollView.frame.size.width;
    CGFloat imageH = scrollView.frame.size.height;
    for (NSInteger index = 0; index < self.imageCount; index++) {
        if(MaJia) {
            UIImageView *imageView = [[UIImageView alloc] init];
            //设置frame
            CGFloat imageX = index * imageW;
            imageView.frame = CGRectMake(imageX, 0, imageW, imageH);
            [scrollView addSubview:imageView];
            imageView.userInteractionEnabled = YES;
            if(index == 0) {
                //设置图片
                NSString *name = [NSString stringWithFormat:@"引导页%d",1];
                imageView.image = [UIImage imageNamed:name];
            } else {
                //设置图片
                NSString *name = [NSString stringWithFormat:@"引导页%d",3];
                imageView.image = [UIImage imageNamed:name];
            }
            
            //在最后一个图片上面添加按钮
            if (index == self.imageCount-1) {
                [self setupLastImageView:imageView];
            }
        } else{
            UIImageView *imageView = [[UIImageView alloc]init];
            //设置图片
            NSString *name = [NSString stringWithFormat:@"引导页%ld",index+1];
            imageView.image = [UIImage imageNamed:name];
            //设置frame
            CGFloat imageX = index * imageW;
            imageView.frame = CGRectMake(imageX, 0, imageW, imageH);
            [scrollView addSubview:imageView];
            imageView.userInteractionEnabled = YES;
            //在最后一个图片上面添加按钮
            if (index == self.imageCount-1) {
                [self setupLastImageView:imageView];
            }
        }
    }
    //    3.设置滚动内容的尺寸
    scrollView.contentSize = CGSizeMake(imageW * self.imageCount, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    
}

//将内容添加到最后一个图片
- (void)setupLastImageView:(UIImageView *)imageView {
    //    0.imageView默认是不可点击的 将其设置为能跟用户交互
    imageView.userInteractionEnabled=YES;
    //1.添加开始按钮
    UIButton *startButton=[[UIButton alloc] init];
//    [startButton setImage:V_IMAGE(@"立即体验") forState:UIControlStateNormal];
    //2.设置frame
    CGFloat centerX=imageView.frame.size.width*0.5;
    CGFloat centerY=imageView.frame.size.height*0.75;
    startButton.center=CGPointMake(centerX, centerY);
    startButton.frame=CGRectMake(30, Screen_Height - 100, Screen_Width - 100, (Screen_Width - 100)/172*35);
    [startButton addTarget:self action:@selector(startButton:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:startButton];
}

- (void)startButton:(UIButton *)button {
    CustomTabbarController *tabbarVC = [[CustomTabbarController alloc]init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tabbarVC;

    NSString *key = @"CFBundleShortVersionString";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // 获得当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    [defaults setObject:currentVersion forKey:key];
    [defaults synchronize];
}

#pragma mark -scroll代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    1.取出水平方向上滚动的距离
    CGFloat offsetX=scrollView.contentOffset.x;
    //2.求出页码
    double pageDouble=offsetX / scrollView.frame.size.width;
    int pageInt = (int)(pageDouble + 0.5);
    if (pageInt > self.imageCount - 1) {
        pageView.hidden = YES;
    } else {
        pageView.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

