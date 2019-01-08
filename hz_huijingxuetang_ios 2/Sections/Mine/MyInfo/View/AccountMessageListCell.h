//
//  MineListCell.h
//  ZhuanMCH
//
//  Created by 张金山 on 16/9/7.
//  Copyright © 2016年 领琾. All rights reserved.
//

#import "BaseTableViewCell.h"

@class AccountModel;

@interface AccountMessageListCell : BaseTableViewCell

@property (nonatomic,strong) AccountModel *model;

@end

@interface MineListTextCell : BaseTableViewCell

//通用模型
- (void)setViewModel:(id)viewModel withIndexPath:(NSIndexPath *)indexPath;

@end
