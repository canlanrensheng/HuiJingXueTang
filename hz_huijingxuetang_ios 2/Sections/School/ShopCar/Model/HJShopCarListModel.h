//
//  HJShopCarListModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/23.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJShopCarListModel : BaseModel

//@property (nonatomic , copy) NSString              * id;
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

@property (nonatomic,assign) BOOL isSelect;

@end

NS_ASSUME_NONNULL_END
