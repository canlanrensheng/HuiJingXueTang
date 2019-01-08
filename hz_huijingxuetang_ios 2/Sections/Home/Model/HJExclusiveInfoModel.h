//
//  HJExclusiveInfoModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/22.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewsList :BaseModel

@property (nonatomic , copy) NSString              * picurl;
@property (nonatomic , copy) NSString              * des;
@property (nonatomic , copy) NSString              * infoId;
@property (nonatomic , copy) NSString              * infomationtitle;
@property (nonatomic , assign) NSInteger              readcounts;
@property (nonatomic , copy) NSString              * informationmodelid;
@property (nonatomic , copy) NSString              * newskindname;
@property (nonatomic , copy) NSString              * createtime;
@property (nonatomic,copy) NSString *teacherid;

@end

@interface HJExclusiveInfoModel : BaseModel

@property (nonatomic , copy) NSString              * newskindname;
@property (nonatomic , copy) NSString              * newskindcode;
@property (nonatomic , copy) NSString              * entkbn;
@property (nonatomic , strong) NSArray<NewsList *>              * newsList;
@property (nonatomic , copy) NSString              * informationid;

@end

NS_ASSUME_NONNULL_END
