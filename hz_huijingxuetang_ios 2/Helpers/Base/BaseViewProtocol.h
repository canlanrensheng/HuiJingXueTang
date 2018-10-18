//
//  BaseViewProtocol.h
//  ZhuanMCH
//
//  Created by txooo on 16/12/14.
//  Copyright © 2016年 张金山. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaseViewModel;

@protocol BaseViewProtocol <NSObject>

@optional

- (instancetype)initWithViewModel:(BaseViewModel *)viewModel;

- (void)tx_bindViewModel;

- (void)tx_configSubViews;

@end
