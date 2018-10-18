//
//  BaseViewModelProtocol.h
//  BM
//
//  Created by txooo on 17/3/3.
//  Copyright © 2017年 张金山. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol BaseViewModelProtocol <NSObject>

@optional

- (instancetype)initWithParams:(NSDictionary *)params;

- (void)tx_initialize;

- (void)loadData:(id)input subscriber:(id<RACSubscriber>)subscriber;

- (void)loadMoreData:(id)input subscriber:(id<RACSubscriber>)subscriber;
//pageIndex=0时上拉下拉可只调用该方法
- (void)requestData:(id)input subscriber:(id<RACSubscriber>)subscriber;

- (void)universalRACCommand:(id)input subscriber:(id<RACSubscriber>)subscriber;

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

- (void)popViewControllerAnimated:(BOOL)animated;

- (void)popToRootViewControllerAnimated:(BOOL)animated;

- (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(dispatch_block_t)completion;

- (void)dismissViewControllerAnimated:(BOOL)animated completion:(dispatch_block_t)completion;

@end
