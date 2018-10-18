//
//  AppColorAndSizeConfig.h
//  LaiCai
//
//  Created by yacs on 15/10/22.
//  Copyright © 2015年 laicaijie.laicai. All rights reserved.
//

//字体
#define FS1  FONT(1)
#define FS8  FONT(8)
#define FS10  FONT(10)
#define FS11  FONT(11)
#define FS12  FONT(12)
#define FS13  FONT(13)
#define FS14  FONT(14)
#define FSB14 BOLDFONT(14)
#define FS15  FONT(15)
#define FS16  FONT(16)
#define FS17  FONT(17)
#define FS18  FONT(18)
#define FS20  FONT(20)
#define FS24  FONT(24*KH)
#define FS30  FONT(30)
#define FS32  FONT(32)
#define FS35  FONT(35)
#define FS36  FONT(36)
#define FS40  FONT(40)
#define FS45  FONT(45)

#define FS50  FONT(50)
#define FS55  FONT(55)

//颜色
#define C2BC693  RGBA(43,198,147,1)
#define C2BA97E  RGBA(43,169,126,1)
#define Cffffff  RGBA(255,255,255,1)
#define CBDBDBD  RGBA(189,189,189,1)
#define C757575  RGBA(117,117,117,1)
#define CFD9C12  RGBA(253,156,18,1)
#define CD38326  RGBA(211,131,38,1)
#define C9E9E9E  RGBA(158,158,158,1)
#define CEEEEEE  RGBA(238,238,238,1)
#define CFD374F  RGBA(253,55,79,1)
#define C009E96  RGBA(0,158,150,1)
#define C979797  RGBA(151,151,151,1)
#define CF5A623  RGBA(245,166,35,1)
#define CE0E0E0  RGBA(224,224,224,1)
#define CFFFFFF03 RGBA(255,255,255,0.3)
#define CWHITE [UIColor whiteColor]
#define CBLACK [UIColor blackColor]
#define CYELLOW [UIColor yellowColor]

#define CORANGE [UIColor orangeColor]
//===================================
//===================================
//===================================
#define IMAGE(A) [UIImage imageNamed:A]

//数据解析
#define JsonStr(value) \
                [YAZLMethodHelper toStringWithJsonValue:(value)]

//输入金额最大长度
#define MONEYNUM_LENGTH 8

//手机号码长度
#define PHONENUM_LENGTH 11

//判断手机号
#define  CHECKPHONENUM(number)  [UUPubLogicHelper validateMobile:(number)]

//验证码倒计时
#define CountDownTime 60

//检测输入框有没有输入内容
#define CHECKTEXTFIELDHAVEINPUT(textfield) \
                [UUPubLogicHelper TextFiledHaveInput:(textfield)]
//判断6-16位数字,字母密码
#define CHECKPASSWORDS(textfield)  [UUPubLogicHelper validatePassword:(textfield)]
//判断交易密码
#define CHECKTRADES(text)  [UUPubLogicHelper validateTrades:(text)]
//提示框
#define SVShowStatus(str) \
                [SVProgressHUD showWithStatus:(str) maskType:SVProgressHUDMaskTypeClear]

#define SVShowSuccess(str) \
                [SVProgressHUD showSuccessWithStatus:(str)]

#define SVShowError(str) \
                [SVProgressHUD showErrorWithStatus:(str)]

#define SVShowMessage(str) \
                [SVProgressHUD showImage:nil status:(str)]

#define SVDismiss \
                [SVProgressHUD dismiss]

//字符串格式化
#define  StringStrFormat(str,value) \
                [NSString stringWithFormat:(str),(value)]

//字符串转化为float
#define  StringDoubleValue(str)    \
                [YAZLMethodHelper StringDoubleValue:(str)]

//字符串转化为金额字符串
#define  MoneyStringFromString(str)    \
                [YAZLMethodHelper MoneyStringFromString:(str)]

//float数值转化为金额字符串
#define  MoneyStringFromDouble(value)    \
                [YAZLMethodHelper MoneyStringFromDouble:(value)]

//字符串转化为金额字符串（没有小数点部分）
#define  MoneyShortIntStringFromString(str)    \
                [YAZLMethodHelper MoneyShortIntStringFromString:(str)]

//float数值转化为金额字符串（没有小数点部分）
#define  MoneyShortIntStringFromDouble(value)    \
                [YAZLMethodHelper MoneyShortIntStringFromDouble:(value)]

//string字符串转化为字典
#define JsonStringToObject(string)\
                [UUPubLogicHelper JsonStringToObject:(string)]

//string时间戳转化为时间字符串
#define DateStringFromTimeSp(string)\
                [UUPubLogicHelper DateStringFromTimeSp:(string)]

//时间转为字符串
#define StringFromDate(day)\
                [UUPubLogicHelper stringFromDateLess:[NSDate dateWithTimeIntervalSinceNow:day * 24 * 60 * 60]]

//获取时间是哪一年
#define Year(date)\
                [UUPubLogicHelper stringFromDateYear: date]

//判断身份证是否合法
#define CheckIdCard(str)\
                [UUPubLogicHelper chk18PaperId:str]

//字符串是否为空
#define isEmpty(str)\
                [UUPubLogicHelper isBlankString: str]

//检验身份证的合法性
#define isValidBankCarkNo(num)\
                [UUPubLogicHelper checkCardNo: num]

//获取用户数据
#define  ShareUserInfo      [AppUserDataInfo sharedUserInfo]
//获取用户是否在线
#define  USER_ISLOGIN       [AppUserDataInfo UserIsLogin]
//获取用户token
#define  USER_TOKEN         [AppUserDataInfo UserToken]

//用户刷新token的节点秒数
#define USER_REFRESH_TOKEN_TIME  600
//用户重新登录节点秒数
#define USER_RELOAD_LOGIN_TIME   7000


//app 本地存储数据相关的路径
//列表数据目录
#define LISTDATA_PATH           @"ListData"
//详情数据目录
#define DETAILDATA_PATH         @"DetailData"
//其它数据目录
#define OTHERDATA_PATH          @"OtherData"
//获取密码强度
#define GundgePwd(pwd)   \
[NetClientHandler jundgePwd:(pwd)]

//判断交易密码
#define JudgePayPsd(psd,isRight)\
[AppUserDataInfo CheckPayPsd:psd isCurrent:isRight]
