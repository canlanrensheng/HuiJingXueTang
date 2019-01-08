//
//  BaseViewController.m
//  Zhuan
//
//  Created by hjooo on 16/3/1.
//  Copyright © 2016年 张金山. All rights reserved.
//

#import "BaseViewController.h"
//#import <UMMobClick/MobClick.h>
#import "BaseDoubleTitleView.h"
#import "BaseLoadingTitleView.h"
#import "BaseViewModel.h"

@interface BaseViewController ()

@property (nonatomic,strong) NSDictionary *params;

@property (nonatomic,strong) BaseViewModel *viewModel;

@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatusBarBackgroundColor:clear_color];
}

- (void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    BaseViewController *viewController = [super allocWithZone:zone];
    @weakify(viewController)
    [[viewController rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
        @strongify(viewController)
        [viewController hj_setNavagation];
        [viewController hj_bindViewModel];
        [viewController hj_loadData];
        [viewController hj_configSubViews];
        [viewController setTitleView];
    }];
    return viewController;
}

- (BaseViewController *)initWithViewModel:(id)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}

- (instancetype)initWithParams:(NSDictionary *)params {
    self = [super init];
    if (self) {
        self.params = params;
        self.navigationItem.title = params[@"title"];
//        self.viewModel = [[BMRouter sharedInstance] viewModelForViewController:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = white_color;
    if (@available(ios 11.0,*)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
//    [MobClick endLogPageView:NSStringFromClass([self class])];
//    hideHud();
}

- (void)setTitleView {
    UIView *titleView = self.navigationItem.titleView;
    
    // Double title view
    BaseDoubleTitleView *doubleTitleView = [[BaseDoubleTitleView alloc] init];
    RAC(doubleTitleView.titleLabel, text)    = RACObserve(self.navigationItem, title);
    RAC(doubleTitleView.subtitleLabel, text) = [RACObserve(self.viewModel, subTitle) ignore:nil];
    
    @weakify(self)
    [[self
      rac_signalForSelector:@selector(viewWillTransitionToSize:withTransitionCoordinator:)]
    	subscribeNext:^(id x) {
            @strongify(self)
            doubleTitleView.titleLabel.text    = self.navigationItem.title;
            doubleTitleView.subtitleLabel.text = self.viewModel.subTitle;
        }];
    
    // Loading title view
    BaseLoadingTitleView *loadingTitleView = [[BaseLoadingTitleView alloc] init];
    RAC(loadingTitleView.titleLabel, text) = RACObserve(self.navigationItem, title);

    RAC(self.navigationItem, titleView) = [RACObserve(self.viewModel,titleViewType).distinctUntilChanged map:^(NSNumber *value) {
        BMTitleViewType titleViewType = value.unsignedIntegerValue;
        switch (titleViewType) {
            case BMTitleViewTypeDefault:
                return titleView;
            case BMTitleViewTypeDoubleTitle:
                return (UIView *)doubleTitleView;
            case BMTitleViewTypeLoadingTitle:
                return (UIView *)loadingTitleView;
        }
    }];
    
    [[RACObserve(self.viewModel, showActivityView) skip:1] subscribeNext:^(id x) {
        @strongify(self)
        if ([x boolValue]) {
            [self.activityView startAnimating];
        }else {
            [self.activityView stopAnimating];
        }
    }];
}

- (void)hj_setNavagation {
    
}

- (void)hj_configSubViews {
    
}

- (void)hj_bindViewModel {
    
}

- (void)hj_loadData {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIActivityIndicatorView *)activityView {
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.hidesWhenStopped = YES;
        [self.view addSubview:_activityView];
        
        [_activityView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.center.mas_equalTo(self.view);
        }];
    }
    return _activityView;
}

- (void)startAnimating {
    [self.activityView startAnimating];
}


- (void)stopLoadingView {
    [self.activityView stopAnimating];
    [self.activityView removeFromSuperview];
}

- (RACSubject *)completionSubject{
    if (!_completionSubject) {
        _completionSubject = [RACSubject subject];
    }
    return _completionSubject;
}




@end
