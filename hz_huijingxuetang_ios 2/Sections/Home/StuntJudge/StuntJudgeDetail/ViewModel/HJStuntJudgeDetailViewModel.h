//
//  HJStuntJudgeDetailViewModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/8.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseTableViewModel.h"
#import "HJStuntJudgeListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HJStuntJudgeDetailViewModel : BaseTableViewModel

@property (nonatomic,strong) HJStuntJudgeListModel *model;
- (void)getStuntJudgeDetailWithId:(NSString *)stuntId Success:(void (^)(BOOL successFlag))success;

- (void)stockAnsrReadsSettedWithId:(NSString *)stuntId Success:(void (^)(void))success;

@end

NS_ASSUME_NONNULL_END
