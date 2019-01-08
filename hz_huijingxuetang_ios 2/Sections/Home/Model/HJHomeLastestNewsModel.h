//
//  HJHomeLastestNewsModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/22.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJHomeLastestNewsModel : BaseModel

@property (nonatomic , copy) NSString              * courseName;
@property (nonatomic , copy) NSString              * studentName;
@property (nonatomic , copy) NSString              * teacherName;

@property (nonatomic,copy) NSString *topTitle;
@property (nonatomic,copy) NSString *bottomTitle;

@end

NS_ASSUME_NONNULL_END
