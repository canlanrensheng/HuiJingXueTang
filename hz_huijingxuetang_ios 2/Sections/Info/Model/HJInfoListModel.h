//
//  HJInfoListModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/10.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJInfoListModel : BaseModel

@property (nonatomic , copy) NSString              * itemId;
@property (nonatomic , copy) NSString              * entkbn;
@property (nonatomic , copy) NSString              * createtime;
@property (nonatomic , copy) NSString              * picurl;
@property (nonatomic , copy) NSString              * userid;
@property (nonatomic , copy) NSString              * realname;
@property (nonatomic , copy) NSString              * singname;
@property (nonatomic , copy) NSString              * thumbsupcounts;
@property (nonatomic , copy) NSString              * createid;
@property (nonatomic , copy) NSString              * tag;
@property (nonatomic , copy) NSString              * descrption;
@property (nonatomic , copy) NSString              * newskindname;
@property (nonatomic , copy) NSString              * updateid;
@property (nonatomic , copy) NSString              * infomationtitle;
@property (nonatomic , copy) NSString              * informationmodelid;
@property (nonatomic , assign) NSInteger              readcounts;
@property (nonatomic,assign) NSInteger readingquantity;
@property (nonatomic , copy) NSString              * content;

@end

NS_ASSUME_NONNULL_END
