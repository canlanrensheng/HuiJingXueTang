//
//  HJHomeStuntJudgeStockModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/24.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJHomeStuntJudgeStockModel : BaseModel

@property (nonatomic , copy) NSString              * stuntId;
@property (nonatomic , copy) NSString              * questiontitle;
@property (nonatomic , copy) NSString              * updateiconurl;
@property (nonatomic , copy) NSString              * createtime;
@property (nonatomic , copy) NSString              * updatename;
@property (nonatomic , copy) NSString              * answer;
@property (nonatomic , copy) NSString              * createid;
@property (nonatomic , assign) NSInteger              flag;
@property (nonatomic , copy) NSString              * updateid;
@property (nonatomic , copy) NSString              * questiondes;
@property (nonatomic , copy) NSString              * createname;
@property (nonatomic , copy) NSString              * createiconurl;
@property (nonatomic , copy) NSString              * answertime;

@end

NS_ASSUME_NONNULL_END
