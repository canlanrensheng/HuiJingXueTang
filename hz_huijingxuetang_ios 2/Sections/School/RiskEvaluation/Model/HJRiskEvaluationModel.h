//
//  HJRiskEvaluationModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/27.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface Answer :BaseModel
@property (nonatomic , copy) NSString              * score;
@property (nonatomic , copy) NSString              * answername;
@property (nonatomic , copy) NSString              * answerid;
@property (nonatomic,assign) CGFloat answerCellHeight;

@end

@interface Question :BaseModel
@property (nonatomic , strong) NSArray<Answer *>              * answer;
@property (nonatomic , copy) NSString              * questionid;
@property (nonatomic , copy) NSString              * questionname;
@property (nonatomic , copy) NSString              * classname;
@property (nonatomic,assign) CGFloat questionCellHeight;

@end

@interface HJRiskEvaluationModel :BaseModel
@property (nonatomic , copy) NSString              * classid;
@property (nonatomic , copy) NSString              * classname;
@property (nonatomic , strong) NSArray<Question *>              * question;

@end

NS_ASSUME_NONNULL_END
