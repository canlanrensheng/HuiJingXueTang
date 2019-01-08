//
//  HJAccountManagerViewModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/4.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseTableViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJAccountManagerViewModel : BaseTableViewModel

@property (nonatomic,strong) NSMutableArray *accountManagerArray;
- (void)getAccountManagerListSuccess:(void (^)(void))success;

//解绑的操作
@property (nonatomic,copy) NSString *accountId;
@property (nonatomic,copy) NSString *type;
- (void)removeaccountWithSuccess:(void (^)(void))success;

//将账户设置为默认的大款的账户
- (void)setDefaultaccountWithSuccess:(void (^)(void))success;


@end

NS_ASSUME_NONNULL_END
