//
//  HJMyCardVoucherViewModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/26.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseTableViewModel.h"

typedef NS_ENUM(NSInteger,MyCardVoucherType){
    MyCardVoucherTypeValid = 1, //可用
    MyCardVoucherTypeUsed = 2, //已使用
    MyCardVoucherTypeInvalid = 3 //过期
};

NS_ASSUME_NONNULL_BEGIN

@interface HJMyCardVoucherViewModel : BaseTableViewModel

@property (nonatomic,assign) MyCardVoucherType myCardVoucherType;

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,assign) NSInteger totalpage;
@property (nonatomic,assign) NSInteger currentpage;
@property (nonatomic,assign) NSInteger page;
//可用的优惠券
@property (nonatomic,strong) NSMutableArray *validVoucherArray;
//已使用的优惠券
@property (nonatomic,strong) NSMutableArray *usedVoucherArray;
//已过期的优惠券
@property (nonatomic,strong) NSMutableArray *invalidVoucherArray;
- (void)getMyCardVoucherSuccess:(void (^)(void))success;

@end

NS_ASSUME_NONNULL_END
