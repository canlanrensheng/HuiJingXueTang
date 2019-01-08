//
//  HJMyOrderListModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/7.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseModel.h"

typedef NS_ENUM(NSUInteger, PayCellType) {
    PayCellTypeCommon = 1, //普通的订单
    PayCellTypeKillPrice = 2 //砍价的订单
};

NS_ASSUME_NONNULL_BEGIN

@interface CourseResponsesModel :NSObject

@property (nonatomic,assign) NSInteger canbargain;
@property (nonatomic , assign) CGFloat              currentprice;
@property (nonatomic , copy) NSString              * littiletime;
@property (nonatomic , copy) NSString              * periods;
@property (nonatomic , assign) CGFloat              purchasemoney;
@property (nonatomic , copy) NSString              * coursepic;
@property (nonatomic , copy) NSString              * courseexpirydate;
@property (nonatomic , assign) CGFloat              feepromotemoney;
@property (nonatomic , copy) NSString              * bargainstatus;
@property (nonatomic , assign) NSInteger              ispromote;
@property (nonatomic , assign) CGFloat              promotemoney;
@property (nonatomic , copy) NSString              * coursename;
@property (nonatomic , copy) NSString              * courseCommentStatus;
@property (nonatomic , copy) NSString              * courseid;
@property (nonatomic , copy) NSString              * orderid;
@property (nonatomic , assign) NSInteger              hassecond;
@property (nonatomic , assign) CGFloat              secondprice;
@property (nonatomic , assign) CGFloat              bargaintoprice;
@property (nonatomic , copy) NSString              * bargintime;
@property (nonatomic , copy) NSString              * lowerpricestatus;

//0 砍价 1不砍价
@property (nonatomic,assign) NSInteger canbargainstatus;

@end

@interface HJMyOrderListModel : BaseModel

@property (nonatomic , copy) NSString              * paytime;
@property (nonatomic , assign) CGFloat              money;
@property (nonatomic , strong) NSArray<CourseResponsesModel *>              * courseResponses;
@property (nonatomic , copy) NSString              * cashcouponid;
@property (nonatomic , assign) NSInteger             coursesize;
@property (nonatomic , copy) NSString              * userid;
@property (nonatomic , copy) NSString              * paytype;
@property (nonatomic , copy) NSString              * ordercreatetime;
@property (nonatomic , copy) NSString              * orderno;
@property (nonatomic , assign) NSInteger             hascashcoup;
@property (nonatomic , copy) NSString              * price;
@property (nonatomic , assign) CGFloat              origintotalmoney;
@property (nonatomic , assign) NSInteger            paystatus;
@property (nonatomic , copy) NSString              * endPayTime;

//cell的高度
@property (nonatomic,assign) CGFloat cellHeight;
//cell的类型 1：普通的订单 2:砍价的订单
@property (nonatomic,assign) PayCellType cellType;

@end

NS_ASSUME_NONNULL_END
