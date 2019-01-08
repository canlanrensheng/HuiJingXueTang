//
//  HJFindRecommondTextCell.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/31.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJFindRecommondTextCell : BaseTableViewCell

@property (nonatomic,strong) RACSubject *backRefreshSubject;

@end

NS_ASSUME_NONNULL_END
