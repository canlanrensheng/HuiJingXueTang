//
//  HJTeacherDetailHeaderView.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/5.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseView.h"
#import "HJTeacherDetailModel.h"
#import "HJTeacherDetailViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HJTeacherDetailHeaderView : BaseView

@property (nonatomic,strong) HJTeacherDetailModel *model;
@property (nonatomic,strong) HJTeacherDetailViewModel *viewModel;

@end

NS_ASSUME_NONNULL_END
