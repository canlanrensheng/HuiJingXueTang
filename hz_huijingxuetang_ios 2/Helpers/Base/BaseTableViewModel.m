//
//  BaseTableViewModel.m
//  BM
//
//  Created by txooo on 17/8/16.
//  Copyright © 2017年 张金山. All rights reserved.
//

#import "BaseTableViewModel.h"

@implementation BaseTableViewModel

- (void)loadData:(id)input subscriber:(id<RACSubscriber>)subscriber {
    self.pageNum = 1;
    if ([self respondsToSelector:@selector(requestData:subscriber:)]) {
        [self requestData:input subscriber:subscriber];
    }
}

- (void)loadMoreData:(id)input subscriber:(id<RACSubscriber>)subscriber {
    self.pageNum ++;
    if ([self respondsToSelector:@selector(requestData:subscriber:)]) {
        [self requestData:input subscriber:subscriber];
    }
}

- (RACCommand *)loadMoreDataCommand {
    if (!_loadMoreDataCommand) {
        @weakify(self);
        _loadMoreDataCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                if ([self respondsToSelector:@selector(loadMoreData:subscriber:)]) {
                    [self loadMoreData:input subscriber:subscriber];
                }
                return nil;
            }];
        }];
    }
    return _loadMoreDataCommand;
}

- (RACSubject *)noDataSubject {
    if (!_noDataSubject) {
        _noDataSubject = [RACSubject subject];
    }
    return _noDataSubject;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)tx_initialize{
    self.pages = 1;
}

@end
