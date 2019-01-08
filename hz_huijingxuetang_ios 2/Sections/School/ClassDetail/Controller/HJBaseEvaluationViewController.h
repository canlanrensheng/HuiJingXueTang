//
//  HJBaseEvaluationViewController.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/25.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseTableViewController.h"
#import "HJClassDetailViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HJBaseEvaluationViewController : BaseTableViewController

@property (nonatomic,strong) HJClassDetailViewModel *viewModel;

//免费领取的操作
@property (nonatomic,strong) RACSubject *evaluationSubject;

@end

NS_ASSUME_NONNULL_END
