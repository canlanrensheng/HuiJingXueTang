//
//  HJShareMakeMoneyViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/23.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJShareMakeMoneyViewController.h"
#import "HJShareMakeMoneyBotttomView.h"
#import "HJShareViewController.h"
#import "HJProfitViewController.h"

#import "HJFindSegmentView.h"
@interface HJShareMakeMoneyViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *controllersClass;
@property (nonatomic,assign) NSInteger  selectIndex;
@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) HJShareViewController *findRecommondVC;
@property (nonatomic,strong) HJProfitViewController *findCareVC;

@property (nonatomic,strong) UIView *guider1View;
@property (nonatomic,strong) UIView *guider2View;

@property (nonatomic,strong) HJShareMakeMoneyBotttomView *bottomView;

@end

@implementation HJShareMakeMoneyViewController

- (UIView *)guider1View {
    if(!_guider1View) {
        _guider1View = [[UIView alloc] init];
        _guider1View.backgroundColor = RGBA(0, 0, 0, 0.6);
        
        //点击按钮
        UIImageView *clickBtnImageView = [[UIImageView alloc] init];
        clickBtnImageView.image = V_IMAGE(@"帮助");
        [_guider1View addSubview:clickBtnImageView];
        
        [clickBtnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_guider1View).offset(-kWidth(10));
            make.top.equalTo(_guider1View).offset(kStatusBarHeight + kHeight(7.0));
            make.size.mas_equalTo(CGSizeMake(kWidth(46), kHeight(30)));
        }];
        
        //分享好友
        UIImageView *shareImageView = [[UIImageView alloc] init];
        shareImageView.image = V_IMAGE(@"分享1箭头");
        [_guider1View addSubview:shareImageView];
        
        [shareImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(clickBtnImageView.mas_left);
            make.top.equalTo(clickBtnImageView.mas_bottom).offset(-kHeight(3.0));
        }];
        
        //下一步的按钮
        UIImageView *nextStepImageView = [[UIImageView alloc] init];
        nextStepImageView.image = V_IMAGE(@"我知道了");
        [_guider1View addSubview:nextStepImageView];
        
        [nextStepImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_guider1View);
            make.bottom.equalTo(_guider1View).offset(-kHeight(80));
        }];
    }
    return _guider1View;
}

- (UIView *)guider2View {
    if(!_guider2View) {
        _guider2View = [[UIView alloc] init];
        _guider2View.backgroundColor = RGBA(0, 0, 0, 0.6);
        
        //点击按钮
        UIImageView *clickBtnImageView = [[UIImageView alloc] init];
        clickBtnImageView.image = V_IMAGE(@"点击按钮");
        [_guider2View addSubview:clickBtnImageView];
        
        [clickBtnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_guider2View).offset(-kWidth(10));
            make.top.equalTo(_guider2View).offset(kHeight(309) + kNavigationBarHeight);
        }];
        
        //分享好友
        UIImageView *shareImageView = [[UIImageView alloc] init];
        shareImageView.image = V_IMAGE(@"分享箭头");
        [_guider2View addSubview:shareImageView];
        
        [shareImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(clickBtnImageView.mas_left).offset(-kWidth(10));
            make.bottom.equalTo(clickBtnImageView.mas_top).offset(kHeight(10));
        }];
        
        //下一步的按钮
        UIImageView *nextStepImageView = [[UIImageView alloc] init];
        nextStepImageView.image = V_IMAGE(@"下一步");
        [_guider2View addSubview:nextStepImageView];
        
        [nextStepImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_guider2View);
            make.bottom.equalTo(_guider2View).offset(-kHeight(80));
        }];
    }
    return _guider2View;
}

//导航条设置
- (void)hj_setNavagation {
    self.title = @"推广赚钱";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"帮助" font:MediumFont(font(15)) action:^(id sender) {
        [DCURLRouter pushURLString:@"route://shareMoneyHelpVC" animated:YES];
    }];
}

//视图创建
- (void)hj_configSubViews {
    //子控制器设置
    self.controllersClass = @[@"HJShareViewController",@"HJProfitViewController"];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - kNavigationBarHeight - kHeight(49) - KHomeIndicatorHeight)];
    [self.view addSubview:scrollView];
    
    //添加滚动效果
    scrollView.contentSize = CGSizeMake(Screen_Width * self.controllersClass.count,  Screen_Height - kNavigationBarHeight - kHeight(49) - KHomeIndicatorHeight);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;

    //将子控制器添加到父控制器
    for (int index = 0; index < self.controllersClass.count; index++) {
        if(index == 0) {
            HJShareViewController *listVC = [[HJShareViewController alloc] init];
            listVC.view.frame = CGRectMake(0, 0, Screen_Width, Screen_Height  - kNavigationBarHeight - kHeight(49) - KHomeIndicatorHeight);
            [self addChildViewController:listVC];
            [scrollView addSubview:listVC.view];
            self.findRecommondVC = listVC;
        }  else if (index == 1){
            HJProfitViewController *listVC = [[HJProfitViewController alloc] init];
            listVC.view.frame = CGRectMake(Screen_Width * 1, 0, Screen_Width, Screen_Height - kNavigationBarHeight - kHeight(49) - KHomeIndicatorHeight);
            [self addChildViewController:listVC];
            [scrollView addSubview:listVC.view];
            self.findCareVC = listVC;
        }
    }

    NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
    NSString *showShareGuider = [defa valueForKey:@"showShareGuider"];
    if([showShareGuider integerValue] != 1) {
        //添加引导试图
        [[UIApplication sharedApplication].keyWindow addSubview:self.guider1View];
        self.guider1View.userInteractionEnabled = YES;
        UITapGestureRecognizer *guide1Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(guide1Tap)];
        [self.guider1View addGestureRecognizer:guide1Tap];
        [self.guider1View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.equalTo([UIApplication sharedApplication].keyWindow);
        }];
    }
    
    __weak typeof(self)weakSelf = self;
    HJShareMakeMoneyBotttomView *bottomView = [[HJShareMakeMoneyBotttomView alloc] initWithFrame:CGRectMake(0, Screen_Height - kHeight(49.0) - kNavigationBarHeight - KHomeIndicatorHeight, Screen_Width, kHeight(49)) titleColor:HEXColor(@"#22476B") selectTitleColor:HEXColor(@"#22476B") imges:@[@"推广未选中",@"收益未选中"] selectImges:@[@"推广选中",@"收益选中"] buttons:@[@"推广",@"收益"] block:^(NSInteger index) {
        [UIView animateWithDuration:0.25 animations:^{
            [weakSelf.scrollView setContentOffset:CGPointMake(index * Screen_Width, 0)];
        }];
    }];
    
    [self addShadowToView:bottomView withColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2]];
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
}

//添加半边圆角
- (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
    theView.layer.shadowColor = theColor.CGColor;
    theView.layer.shadowOffset = CGSizeMake(0,0);
    theView.layer.shadowOpacity = 0.5;
    theView.layer.shadowRadius = 5;
    // 单边阴影 顶边
    float shadowPathWidth = theView.layer.shadowRadius;
    CGRect shadowRect = CGRectMake(0, 0 - shadowPathWidth / 2.0, theView.bounds.size.width, shadowPathWidth);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:shadowRect];
    theView.layer.shadowPath = path.CGPath;
}


//推广赚钱引导页一
- (void)guide1Tap {
    self.guider1View.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:self.guider2View];
    self.guider2View.userInteractionEnabled = YES;
    UITapGestureRecognizer *guide2Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(guide2Tap)];
    [self.guider2View addGestureRecognizer:guide2Tap];
    [self.guider2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo([UIApplication sharedApplication].keyWindow);
    }];
}



//推广赚钱引导页二
- (void)guide2Tap {
    self.guider2View.hidden = YES;
    //写入分享引导页面
    NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
    [defa setValue:@"1" forKey:@"showShareGuider"];
    [defa synchronize];
}

//滚动切换控制器的操作
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = self.view.frame.size.width;
    CGFloat offsetX = scrollView.contentOffset.x;
    //获取索引
    NSInteger scrollIndex = offsetX / width;
    self.bottomView.selectIndex = scrollIndex;
}


@end

