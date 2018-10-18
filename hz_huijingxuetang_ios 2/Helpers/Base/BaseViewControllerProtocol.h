//
//  BaseViewControllerProtocol.h
//  BM
//
//  Created by txooo on 17/2/28.
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

- (void)tx_bindViewModel;

- (void)tx_loadData;

- (void)tx_configSubViews;

@end
