//
//  HJSchoolDetailTeacherInfoView.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/26.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseView.h"
#import "HJSchoolLiveDetailViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HJSchoolDetailTeacherInfoView : BaseView

@property (nonatomic,strong) HJSchoolLiveDetailViewModel *viewModel;
//点击关注未关注按钮的回掉的操作
@property (nonatomic,strong) RACSubject *careSubject;
//关注按钮的状态的改变的操作
@property (nonatomic,assign) BOOL careSelected;

@end

NS_ASSUME_NONNULL_END
