//
//  BaseView.m
//  ZhuanMCH
//
//  Created by txooo on 16/12/14.
//  Copyright © 2016年 张金山. All rights reserved.
//

#import "BaseView.h"
#import "BaseViewModel.h"

@interface BaseView ()

@property (nonatomic,strong) BaseViewModel *viewModel;

@end

@implementation BaseView

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    BaseView *baseView = [super allocWithZone:zone];
    @weakify(baseView);
    [[baseView rac_signalForSelector:@selector(initWithFrame:)] subscribeNext:^(id x) {
        @strongify(baseView)
        [baseView tx_configSubViews];
        [baseView tx_bindViewModel];
    }];
    return baseView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

    }
    return self;
}

- (instancetype)initWithViewModel:(BaseViewModel *)viewModel {
    self.viewModel = viewModel;
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)tx_configSubViews{};

- (void)tx_bindViewModel{};

@end
