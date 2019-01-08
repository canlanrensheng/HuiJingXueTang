//
//  HJBaseMyCardVoucherViewController.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/9.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseTableViewController.h"
#import "HJMyCardVoucherViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HJBaseMyCardVoucherViewController : BaseTableViewController

@property (nonatomic,strong) HJMyCardVoucherViewModel *viewModel;

- (void)loadData;

@end

NS_ASSUME_NONNULL_END
