//
//  HJSchoolClassSelectToolView.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/24.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseView.h"
#import "HJSchoolCourseListViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HJSchoolClassSelectToolView : BaseView

@property (nonatomic,strong) UIButton *lastSelectBtn;
@property (nonatomic,strong) UIButton *selectButton;
@property (nonatomic,strong) RACSubject *clickSubject;

@property (nonatomic,strong) HJSchoolCourseListViewModel *viewModel;

@end

NS_ASSUME_NONNULL_END
