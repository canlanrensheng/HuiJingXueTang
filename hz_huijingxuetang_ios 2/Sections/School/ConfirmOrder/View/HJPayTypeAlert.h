//
//  HJPayTypeAlert.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/24.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,PayType){
    PayTypeAliPay,
    PayTypeWX
};

@interface HJPayTypeAlert : BaseView

- (HJPayTypeAlert*)initWithBlock:(void(^)(PayType payType))block;
- (void)show;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
