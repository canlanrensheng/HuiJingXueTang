//
//  YJAPPNetwork.h
//  TennisClass
//
//  Created by Junier on 2017/12/7.
//  Copyright © 2017年 陈燕军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YJAPPNetwork : NSObject

//生成电子签名操作
+(void)CreateEleSignatureWithOrderId:(NSString *)orderId picData:(NSString *)picData success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

//上线马甲包控制
+(void)SetOnlineMaJiaBaoWithCheckVersion:(NSString *)checkVersion success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

//检测版本更新
+(void)CheckVersionWithSuccess:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

//保存openId到后台服务器
+(void)SaveOpenIdToServiceWithOpenId:(NSString *)openId success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 首页
 **/
+(void)Cityid:(NSString *)cityid venuename:(NSString *)venuename page:(NSString *)page venueIds:(NSString *)venueIds success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 首页 - 最新动态
 **/
+(void)HomeViewNewsuccess:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;
/**
 首页 - 名师
 **/
+(void)HomeViewTeachersuccess:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;
/**
 首页 - 免费free 付费pay
 **/
+(void)HomeViewFreeAndType:(NSString *)type success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 首页 - 资讯
 **/
+(void)HomeViewNewslistsuccess:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 首页 - 精彩推荐
 **/
+(void)HomeViewlivelogsuccess:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 注册获取验证码
 **/
+(void)GetCodeWithPhonenum:(NSString *)phonenum success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 注册
 **/
+(void)registWithPhonenum:(NSString *)phonenum pwd:(NSString *)pwd code:(NSString *)code incode:(NSString *)incode success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

//判断是否已经组册
+(void)checkReggedWithPhonenum:(NSString *)phonenum success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 登录
 **/
+(void)LoginPwdWithPhonenum:(NSString *)phonenum code:(NSString *)code success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;
/**
 登录获取验证码
 **/
+(void)GetCodeLoginWithPhonenum:(NSString *)phonenum success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;
/**
 忘记获取验证码
 **/
+(void)GetCodeForgetWithPhonenum:(NSString *)phonenum success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;
/**
 重置密码
 **/
+(void)ForgetPWDWithPhonenum:(NSString *)phonenum code:(NSString *)code pwd:(NSString *)pwd rpwd:(NSString *)rpwd  success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;


/**
 课程列表
 **/
+(void)GetClassTaskWithAccesstoken:(NSString *)Accesstoken coursetype:(NSString *)coursetype num:(NSString *)num evaluate:(NSString *)evaluate teacherid:(NSString *)teacherid type:(NSString *)type price:(NSString *)price page:(NSString *)price success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 点赞按钮
 **/
+(void)zanwithAccesstoken:(NSString *)Accesstoken Id:(NSString *)Id success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 进入播放+1
 **/
+(void)PalywithId:(NSString *)Id success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 课程详情
 **/
+(void)ClassInfowithCoureId:(NSString *)Id Accesstoken:(NSString *)accesstoken success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 课程目录
 **/
+(void)ClasscatalogedwithCoureId:(NSString *)Id Accesstoken:(NSString *)accesstoken success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 课程评价
 **/
+(void)ClassAppraisewithCoureId:(NSString *)Id page:(NSString *)page success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 咨询头部列表
 **/
+(void)InformationTopsuccess:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 咨讯列表
 **/
+(void)NewslistwithCoureId:(NSString *)Id page:(NSString *)page success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;


/**
 咨讯详情
 **/
+(void)NewslistInfowithCoureId:(NSString *)Id success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 咨讯评论
 **/
+(void)NewsCommentwithCoureId:(NSString *)Id page:(NSString *)page success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;


/**
 发表咨讯评论
 **/
+(void)CommentwithCoureinfoid:(NSString *)infoid accesstoken:(NSString *)accesstoken commid:(NSString *)commid content:(NSString *)content success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 vip策略列表
 **/
+(void)VIPtacticswithaccesstoken:(NSString *)accesstoken page:(NSString *)page success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;



/**
 vip策略咨讯详情
 **/
+(void)VIPtacticsInfowithaccesstoken:(NSString *)accesstoken infoid:(NSString *)infoid success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 vip策略咨讯评论列表
 **/
+(void)VIPNewsCommentwithinfoid:(NSString *)infoid success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

//----------------------------------

/**
 教师列表
 **/
+(void)TeachTasksuccess:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 教师详情页
 **/
+(void)TeacherTaskInfowithinfoid:(NSString *)infoid success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 教师的课程列表
 **/
+(void)TeacherClassTaskwithinfoid:(NSString *)infoid type:(NSString *)type success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 我的基本信息
 **/
+(void)MyInfowithaccesstoken:(NSString *)accesstoken success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 专家诊股列表
 **/
+(void)SpecialistwithType:(NSString *)type page:(NSString *)page success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 专家诊股提问
 **/
+(void)SpeciaQuestionwithaccesstoken:(NSString *)accesstoken title:(NSString *)title des:(NSString *)des success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 牛人观点列表
 **/
+(void)Geniusviewlistwithpage:(NSString *)page success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 牛人观点详情
 **/
+(void)GeniusviewInfowithId:(NSString *)Id success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 自动登录
 **/
+(void)AutoLoginWithAccesstoken:(NSString *)accesstoken success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 我的课程
 **/
+(void)MyClssWithAccesstoken:(NSString *)accesstoken type:(NSString *)type page:(NSString *)page success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 礼物列表
 **/
+(void)GiftTasksuccess:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 直播页顶部正在直播的课程
 **/
+(void)LivecourselivingWithType:(NSString *)type success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 我的卡券
 **/
+(void)MycardWithAccessToken:(NSString *)Accesstoken type:(NSString*)type success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;


/**
 直播间
 **/
+(void)LiveRoomWithAccessToken:(NSString *)Accesstoken ID:(NSString*)ID success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 直播间内节目单列表
 **/
+(void)LiveCourseProgramWithID:(NSString*)ID success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 直播间内往前节目
 **/
+(void)TeapastLiveCourseListProgramWithID:(NSString*)ID page:(NSString *)page success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 往期节目
 **/
+(void)LiveCourseListProgramWithType:(NSString*)Type page:(NSString *)page success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 创建待支付订单
 **/
+(void)WillPayWithAccesstoken:(NSString*)accesstoken cids:(NSString *)cids picData:(NSString *)picData success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

//生成砍价的订单
+(void)CreateKillPriceOrderWithAccesstoken:(NSString*)accesstoken courseId:(NSString *)courseId picData:(NSString *)picData success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;
/**
 订单详情
 **/
+(void)OrderInfoWithAccesstoken:(NSString*)accesstoken Id:(NSString *)Id success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 立即支付
 **/
+(void)OrderPayAccesstoken:(NSString*)accesstoken orderid:(NSString *)orderid couponid:(NSString *)couponid paytype:(NSString *)paytype mch:(NSString *)mch success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 加入购物车
 **/
+(void)shoppingCartWithAccesstoken:(NSString*)accesstoken courseid:(NSString *)courseid success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 购物车列表
 **/
+(void)MyshoppingCartListWithAccesstoken:(NSString*)accesstoken page:(NSString *)page success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 获取代金券
 **/
+(void)getUserCardWithAccesstoken:(NSString*)accesstoken page:(NSString *)page success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 获取本周节目单
 **/
+(void)getWeakdateWithType:(NSString*)Type date:(NSString *)date success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 获取订单列表
 **/
+(void)getOrderListWithAccesstoken:(NSString*)Accesstoken type:(NSString *)type page:(NSString *)page success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 删除订单
 **/
+(void)DeleteOrderWithAccesstoken:(NSString*)Accesstoken Id:(NSString *)Id  success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 删除购物车订单
 **/
+(void)DeleteCartWithAccesstoken:(NSString*)Accesstoken Id:(NSString *)Id  success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 课程评价
 **/
+(void)appraiseWithAccesstoken:(NSString*)Accesstoken Id:(NSString *)Id content:(NSString *)content star:(NSString *)star  success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 礼物支付
 **/
+(void)GifePayAccesstoken:(NSString*)accesstoken Id:(NSString *)Id count:(NSString *)count remark:(NSString *)remark paytype:(NSString *)paytype success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;
/**
 上传头像。图片
 **/
+(void)upLoadImgWithAccesstoken:(NSString *)accesstoken type:(NSString *)type img:(UIImage *)img success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 用户反馈
 **/
+(void)FeedBackAccesstoken:(NSString*)accesstoken content:(NSString *)content img:(NSString *)img phone:(NSString *)phone success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 修改头像
 **/
+(void)updataIconWithAccesstoken:(NSString*)accesstoken avator:(NSString *)avator success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 课程详情内推荐课程
 **/
+(void)recommendCourseWithteacherid:(NSString*)teacherid courseid:(NSString *)courseid success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 学习进度
 **/
+(void)MycoursestudyWithaccesstoken:(NSString*)accesstoken page:(NSString *)page success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 视频播放量+1
 **/
+(void)vedioCountWithID:(NSString*)ID success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

/**
 直播验证密码
 **/
+(void)getLivePsdWithToken:(NSString *)token ID:(NSString*)ID pwd:(NSString *)pwd success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;



/**
 首页轮播
 **/
+(void)getAdSuccess:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure;

@end
