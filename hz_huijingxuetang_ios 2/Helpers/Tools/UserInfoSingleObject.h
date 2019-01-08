//
//  BMSingleObject.h
//  BM
//
//  Created by txooo on 17/3/1.
//  Copyright © 2017年 张金山. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Reachability/Reachability.h>

typedef NS_ENUM(NSInteger,WxOrAlipayType){
    WxOrAlipayTypeBuy, //购买
    WxOrAlipayTypeReward //打赏
};

@interface UserInfoSingleObject : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, assign) NetworkStatus networkStatus;

@property (nonatomic, assign) NSInteger bagdeValue;


- (void)setUserInfo:(NSDictionary *)userInfo;

- (void)configThirdPartInfo;

- (NSDictionary *)GetUserInfo;

- (void)clearUserInfo;

- (NSString *)getWifiName;

//支付的类型
@property (nonatomic,assign) WxOrAlipayType payType;

@property (nonatomic,assign) NSInteger findType;

//是否展示马甲包
@property (nonatomic,assign) BOOL isShowMaJia;

//是否已经登陆
@property (nonatomic,assign) BOOL isLogined;

//点击的学习小组的效果
@property (nonatomic,assign) NSInteger clickStudentGroupCount;

@end
