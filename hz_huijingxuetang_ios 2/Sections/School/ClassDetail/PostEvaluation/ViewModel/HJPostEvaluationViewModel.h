//
//  HJPostEvaluationViewModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/14.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJPostEvaluationViewModel : BaseViewModel

@property (nonatomic,copy) NSString *courseid;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *star;
- (void)addCommentWithSuccess:(void (^)(void))success;

@end

NS_ASSUME_NONNULL_END
