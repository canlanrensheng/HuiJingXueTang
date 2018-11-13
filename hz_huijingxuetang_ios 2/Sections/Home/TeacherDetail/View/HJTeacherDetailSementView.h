//
//  HJTeacherDetailSementView.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/5.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJTeacherDetailSementView : BaseView

@property (nonatomic,strong) UIButton *lastSelectButton;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) RACSubject *clickSubject;


@end

NS_ASSUME_NONNULL_END
