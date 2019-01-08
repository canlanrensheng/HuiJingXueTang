//
//  HJMyShareCommunityDetailModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/28.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJMyShareCommunityDetailModel : BaseModel

@property (nonatomic , assign) CGFloat              coursemoney;
@property (nonatomic , copy) NSString              * coursename;
@property (nonatomic , copy) NSString              *paytime;
@property (nonatomic , copy) NSString              * telno;

@end

NS_ASSUME_NONNULL_END
