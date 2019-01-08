//
//  HJOrderDetailOperationCell.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/8.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "HJMyOrderListModel.h"
#import "HJOrderDetailViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HJOrderDetailOperationCell : BaseTableViewCell

@property (nonatomic,strong) HJMyOrderListModel *model;
@property (nonatomic,strong) HJOrderDetailViewModel *viewModel;

@property (nonatomic,strong) RACSubject *deleteSub;
@property (nonatomic,strong) RACSubject *backSub;

//去评价的操作

@end

NS_ASSUME_NONNULL_END
