//
//  HJRiskEvaluationViewModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/27.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseTableViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJRiskEvaluationViewModel : BaseTableViewModel

//获取风险评估的问题和答案
@property (nonatomic,strong) NSMutableArray *riskEvaluationListArray;
- (void)getRiskEvaluationListWithSuccess:(void (^)(BOOL successFlag))success;

//提交风险评估的数据
- (void)submmitRiskEvaluationDataWithAnserids:(NSString *)answerIds Success:(void (^)(void))success;

@end

NS_ASSUME_NONNULL_END
