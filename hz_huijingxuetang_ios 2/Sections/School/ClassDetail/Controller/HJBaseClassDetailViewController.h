//
//  HJBaseClassDetailViewController.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/25.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseTableViewController.h"
#import "HJClassDetailViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HJBaseClassDetailViewController : BaseTableViewController

@property (nonatomic,strong) HJClassDetailViewModel *viewModel;
@property (nonatomic,strong) RACSubject *courseMessageSubject;

@end

NS_ASSUME_NONNULL_END
