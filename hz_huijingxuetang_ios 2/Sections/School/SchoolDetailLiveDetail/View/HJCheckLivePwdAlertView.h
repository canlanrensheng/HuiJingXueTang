//
//  HJCheckLivePwdAlertView.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/30.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^bindBlock)(NSString *pwd);

@interface HJCheckLivePwdAlertView : BaseView

@property (nonatomic,copy)bindBlock bindBlock;

- (HJCheckLivePwdAlertView * )initWithLiveId:(NSString *)liveId teacherId:(NSString *)teacherId BindBlock:(void(^)(NSString *pwd))bindBlock;

- (void)show;
- (void)dismiss;

@end


NS_ASSUME_NONNULL_END
