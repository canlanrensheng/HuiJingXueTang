//
//  HJTeachDetailModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/12.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJTeachDetailModel : BaseModel

@property (nonatomic,copy) NSString * articalid;
@property (nonatomic,copy) NSString * userid;
@property (nonatomic,copy) NSString * realname;
@property (nonatomic,copy) NSString * tdays;
@property (nonatomic,copy) NSString * articaltitle;
@property (nonatomic,copy) NSString * picurl;
@property (nonatomic,copy) NSString * content;
@property (nonatomic,copy) NSString * readcount;


@end

NS_ASSUME_NONNULL_END
