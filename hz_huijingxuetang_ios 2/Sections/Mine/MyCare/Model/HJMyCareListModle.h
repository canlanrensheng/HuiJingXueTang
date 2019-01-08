//
//  HJMyCareListModle.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/19.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJMyCareListModle : BaseModel

@property (nonatomic , copy) NSString              * teacprofessional;
@property (nonatomic , copy) NSString              * userid;
@property (nonatomic , copy) NSString              * iconurl;
@property (nonatomic , copy) NSString              * realname;

@end

NS_ASSUME_NONNULL_END
