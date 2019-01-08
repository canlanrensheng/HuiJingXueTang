//
//  HJAddAccountViewModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/23.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseTableViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJAddAccountViewModel : BaseTableViewModel

//@property (nonatomic,copy) NSString *aliPayAccountName;
@property (nonatomic,copy) NSString *accountname;
@property (nonatomic,copy) NSString *phoneNum;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *type;

- (void)addAccountWithSuccess:(void (^)(void))success;

@end

NS_ASSUME_NONNULL_END
