//
//  HJMineHeaderView.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/7.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJMineHeaderView : BaseView

@property (nonatomic,strong) UIImageView *iconImageV;
@property (nonatomic,strong) UILabel *nameLable;
@property (nonatomic,strong) UIImageView *vipLevelImageV;

//未读的消息的数量
@property (nonatomic,assign) NSInteger unReadMessageCount;

@end

NS_ASSUME_NONNULL_END
