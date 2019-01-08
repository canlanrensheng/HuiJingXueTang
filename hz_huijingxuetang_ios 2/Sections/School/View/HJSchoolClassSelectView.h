//
//  HJSchoolClassSelectView.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/24.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseView.h"
#import "HJSchoolCourseListViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HJSchoolClassSelectView : BaseView

@property (nonatomic,strong) RACSubject *backSubject;

@property (nonatomic,strong) HJSchoolCourseListViewModel *viewModel;

@end

NS_ASSUME_NONNULL_END
