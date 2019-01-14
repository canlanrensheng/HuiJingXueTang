//
//  HJConfirmOrderModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/27.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CourselistModel :BaseModel
@property (nonatomic , copy) NSString              * id;
@property (nonatomic , copy) NSString              * hx_productId;
@property (nonatomic , copy) NSString              * userid;
@property (nonatomic , copy) NSString              * zjzx_productId;
@property (nonatomic , copy) NSString              * coursepic;
@property (nonatomic , copy) NSString              * discountrate;
@property (nonatomic , copy) NSString              * coursemoney;
@property (nonatomic , copy) NSString              * secondprice;
@property (nonatomic , copy) NSString              * coursename;
@property (nonatomic , assign) NSInteger              hassecond;
@property (nonatomic , copy) NSString              * courseid;
@property (nonatomic , assign) NSInteger              periods;

//是否能推广的课 1代表能推广联系客户之父 小额 0代表大额，不能直接支付
@property (nonatomic , assign) NSInteger              ispromote;

@end

@interface HJConfirmOrderModel :BaseModel
@property (nonatomic , copy) NSString              * paytime;
@property (nonatomic , copy) NSString              * currentprice;
@property (nonatomic , assign) CGFloat              money;
@property (nonatomic , copy) NSString              * paytype;
@property (nonatomic , copy) NSString              * cashcouponid;
@property (nonatomic , copy) NSString              * createtime;
@property (nonatomic , copy) NSString              * userid;
@property (nonatomic , copy) NSString              * picurl;
@property (nonatomic , copy) NSString              * orderno;
@property (nonatomic , copy) NSString              * source;
@property (nonatomic , copy) NSString              * trannum;
@property (nonatomic , copy) NSString              * cpname;
@property (nonatomic , copy) NSString              * price;
@property (nonatomic , strong) NSArray<CourselistModel *>              * courselist;
@property (nonatomic , copy) NSString              * handler;
@property (nonatomic , copy) NSString              * paystatus;
@property (nonatomic , copy) NSString              * endpaytime;
@property (nonatomic , copy) NSString              * second;

@end

NS_ASSUME_NONNULL_END
