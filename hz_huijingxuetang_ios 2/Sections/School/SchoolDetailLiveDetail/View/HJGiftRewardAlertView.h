//
//  HJGiftRewardAlertView.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/20.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJGiftRewardAlertView : BaseView

- (HJGiftRewardAlertView*)initWithDataArray:(NSMutableArray *)dataArray Block:(void(^)(NSDictionary *dict))block;

- (void)show;

@end

NS_ASSUME_NONNULL_END
