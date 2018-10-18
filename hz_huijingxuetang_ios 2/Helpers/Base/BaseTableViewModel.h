//
//  BaseTableViewModel.h
//  BM
//
//  Created by txooo on 17/8/16.
//  Copyright © 2017年 张金山. All rights reserved.
//

#import "BaseViewModel.h"

@interface BaseTableViewModel : BaseViewModel

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) RACCommand *didSelectCommand;

@property (nonatomic,strong) RACCommand *loadMoreDataCommand;

@property (nonatomic,strong) RACSubject *noDataSubject;

@property (nonatomic,assign) NSInteger pageNum;

@property (nonatomic,assign) NSInteger pages;

@end
