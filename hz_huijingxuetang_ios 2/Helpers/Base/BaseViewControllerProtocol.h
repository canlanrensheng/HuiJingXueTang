//
//  BaseViewControllerProtocol.h
//  BM
//
//  Created by hjooo on 17/2/28.
//  Copyright © 2017年 张金山. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaseViewModel;

@protocol BaseViewControllerProtocol <NSObject>

@optional

//Pass to your own ViewModel
- (instancetype)initWithViewModel:(BaseViewModel *)viewModel;
// init viewModel with params
- (instancetype)initWithParams:(NSDictionary *)params;

- (void)hj_bindViewModel;

- (void)hj_loadData;

- (void)hj_configSubViews;

- (void)hj_setNavagation;

@end
