//
//  HJInfoCheckPwdAlertView.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/12.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^bindBlock)(BOOL success);

@interface HJInfoCheckPwdAlertView : BaseView

@property (nonatomic,copy)bindBlock bindBlock;

- (HJInfoCheckPwdAlertView * )initWithBindBlock:(void(^)(BOOL success))bindBlock;

- (void)show;

@end



NS_ASSUME_NONNULL_END
