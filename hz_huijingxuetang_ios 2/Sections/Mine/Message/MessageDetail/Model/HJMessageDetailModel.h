//
//  HJMessageDetailModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/7.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJMessageDetailModel : BaseModel

@property (nonatomic , copy) NSString              * userid;
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , assign) NSInteger              status;
@property (nonatomic , copy) NSString              * messCount;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , assign) NSInteger              type;
@property (nonatomic , copy) NSString              * contentid;
@property (nonatomic , copy) NSString              * createtime;
@property (nonatomic,copy) NSString *senduserid;

@end

NS_ASSUME_NONNULL_END
