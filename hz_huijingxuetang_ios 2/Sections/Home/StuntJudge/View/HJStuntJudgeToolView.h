//
//  HJStuntJudgeToolView.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/27.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJStuntJudgeToolView : BaseView

@property (nonatomic,strong) UIButton *lastSelectButton;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) RACSubject *clickSubject;
@property (nonatomic,strong) UILabel *repleyedRedLabel;
@property (nonatomic,strong) UIButton *evaluationButton;
@property (nonatomic,strong) UIButton *liveButton;

@end

NS_ASSUME_NONNULL_END
