//
//  HJClassDetailBottomView.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/25.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseView.h"
#import "HJTextAndPicButoton.h"
NS_ASSUME_NONNULL_BEGIN

@interface HJClassDetailBottomView : BaseView

@property (nonatomic,strong) RACSubject *backSubject;

//购物车按钮
@property (nonatomic,strong) HJTextAndPicButoton *carBtn;
//邀请好友砍价
@property (nonatomic,strong) UIButton *killPriceBtn;
//立即购买
@property (nonatomic,strong) UIButton *buyBtn;
//免费领取按钮
@property (nonatomic,strong) UIButton *freeGetBtn;

//邀请好友砍价的价格
@property (nonatomic,strong) UILabel *killPriceLabel;
//没有限时特惠的时候立即购买的价格
@property (nonatomic,strong) UILabel *noKillPriceLabel;
//有限时特惠的原价的价格
@property (nonatomic,strong) UILabel *originPriceLabel;
//原价的分割线
@property (nonatomic,strong) UIView *originLineView;
//有限时秒杀的秒杀之后的价格
@property (nonatomic,strong) UILabel *afterSecondKillPriceLabel;

@end

NS_ASSUME_NONNULL_END
