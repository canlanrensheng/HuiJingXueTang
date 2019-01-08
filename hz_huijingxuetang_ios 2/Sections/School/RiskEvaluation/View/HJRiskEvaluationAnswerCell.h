//
//  HJRiskEvaluationAnswerCell.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/21.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "HJRiskEvaluationModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HJRiskEvaluationAnswerCell : BaseTableViewCell

@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UILabel *titleTextLabel;

@property (nonatomic,strong) Answer *model;

@end

NS_ASSUME_NONNULL_END
