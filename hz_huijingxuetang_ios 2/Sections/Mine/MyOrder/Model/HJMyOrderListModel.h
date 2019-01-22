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

//合计的价格
@property (nonatomic , assign) CGFloat              currentprice;
//订单日期
@property (nonatomic , copy) NSString              * littiletime;
//课程周期
@property (nonatomic , copy) NSString              * periods;
//有限时特惠时候的原价
@property (nonatomic , assign) CGFloat              purchasemoney;
//课程图片
@property (nonatomic , copy) NSString              * coursepic;
@property (nonatomic , copy) NSString              * courseexpirydate;
//已砍的多少钱
@property (nonatomic , assign) CGFloat              feepromotemoney;
//砍价状态 1砍价结束 0砍价中
@property (nonatomic , copy) NSString              * bargainstatus;
//区分大额还是小额  1小额  0大额
@property (nonatomic , assign) NSInteger              ispromote;
@property (nonatomic , assign) CGFloat              promotemoney;
//课程名称
@property (nonatomic , copy) NSString              * coursename;
@property (nonatomic , copy) NSString              * courseCommentStatus;
//课程ID
@property (nonatomic , copy) NSString              * courseid;
//订单ID
@property (nonatomic , copy) NSString              * orderid;
//是否砍价 1能砍价 0不能砍价
@property (nonatomic , assign) NSInteger              hassecond;
//砍价的价格
@property (nonatomic , assign) CGFloat              secondprice;
//最低可砍到的价格
@property (nonatomic , assign) CGFloat              bargaintoprice;
@property (nonatomic , copy) NSString              * bargintime;
@property (nonatomic , copy) NSString              * lowerpricestatus;
//0 普通订单 1砍价订单
@property (nonatomic,assign) NSInteger canbargainstatus;

@end

@interface HJMyOrderListModel : BaseModel

@property (nonatomic , copy) NSString              * paytime;
@property (nonatomic , assign) CGFloat              money;
@property (nonatomic , strong) NSArray<CourseResponsesModel *>              * courseResponses;
//优惠券的ID
@property (nonatomic , copy) NSString              * cashcouponid;
@property (nonatomic , assign) NSInteger             coursesize;
//老师的ID
@property (nonatomic , copy) NSString              * userid;
@property (nonatomic , copy) NSString              * paytype;
@property (nonatomic , copy) NSString              * ordercreatetime;
//订单ID
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
