//
//  HJWithDrawRacordModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/4.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJWithDrawRacordModel : BaseModel

@property (nonatomic , assign) CGFloat              money;
@property (nonatomic , copy) NSString              * userid;
@property (nonatomic , assign) NSInteger              withdrawtype;
@property (nonatomic , copy) NSString              * withdrawtime;
@property (nonatomic,copy) NSString *accountname;


@end

NS_ASSUME_NONNULL_END
