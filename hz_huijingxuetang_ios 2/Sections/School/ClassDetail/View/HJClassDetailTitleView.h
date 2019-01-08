//
//  HJClassDetailTitleView.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/9.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseView.h"

#import "TimeCountDownView.h"
NS_ASSUME_NONNULL_BEGIN

@interface HJClassDetailTitleView : BaseView

@property (nonatomic,strong) UILabel *titleTextLabel;
@property (nonatomic,strong) TimeCountDownView *timeCountDownView;

@end

NS_ASSUME_NONNULL_END
