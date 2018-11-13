//
//  HJSchoolLiveInputView.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/26.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJSchoolLiveInputView : BaseView

@property (nonatomic,strong) UITextField *inputTextField;
@property (nonatomic,strong) UIButton *sendButton;

@property (nonatomic,strong) RACSubject *backSubject;

@end

NS_ASSUME_NONNULL_END