//
//  HJGiftPayAlertView.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/21.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseView.h"
#import "HJPayTypeAlert.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJGiftPayAlertView : BaseView

- (HJGiftPayAlertView*)initWithPrice:(NSString *)price Block:(void(^)(PayType payType))block;

- (void)show;

@end

NS_ASSUME_NONNULL_END
