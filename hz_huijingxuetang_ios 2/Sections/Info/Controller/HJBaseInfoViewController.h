//
//  HJBaseInfoViewController.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/6.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseViewController.h"
#import "HJInfoItemModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HJBaseInfoViewController : BaseViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) HJInfoItemModel *model;

@end

NS_ASSUME_NONNULL_END
