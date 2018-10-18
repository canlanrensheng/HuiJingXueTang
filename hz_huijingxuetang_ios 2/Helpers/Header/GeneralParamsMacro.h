//
//  GeneralParamsMacro.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/18.
//  Copyright © 2018年 Junier. All rights reserved.
//

#ifndef GeneralParamsMacro_h
#define GeneralParamsMacro_h


//蓝色
#define NavigationBar_Color RGBCOLOR(255,154,13)
/**
 *  黑色文字 16 16 16
 */
#define Text_Color [UIColor getColor: @"#101010"]
/**
 *  弱 背景色 248 248 248
 */
#define Background_Color RGBCOLOR(248,248,248)

/**
 *  弱 背景色 242 242 242
 */
#define Section_BackGround_Color RGBCOLOR(242,242,242)
/**
 *  分割线 225 225 225
 */
#define Line_Color [UIColor getColor: @"#e1e1e1"]

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self
#define SS(strongSelf)  __strong __typeof(&*weakSelf)strongSelf = weakSelf
//** 沙盒路径 ***********************************************************************************
#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]


/* ****************************************************************************************************************** */
/** DEBUG LOG **/
#ifdef DEBUG

#define LRString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define DLog(...) printf(" %s 第%d行: %s\n\n", [LRString UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);

//#define DLog( s, ... ) NSLog( @"< %@:(%d) > %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

#else

#define DLog( s, ... )

#endif


/** DEBUG RELEASE **/
#if DEBUG

#define MCRelease(x)            [x release]

#else

#define MCRelease(x)            [x release], x = nil

#endif


/** NIL RELEASE **/
#define NILRelease(x)           [x release], x = nil


/* ****************************************************************************************************************** */
#pragma mark - Frame (宏 x, y, width, height)

// App Frame
#define Application_Frame       [[UIScreen mainScreen] applicationFrame]


// MainScreen Height&Width
#define Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Screen_Width       [[UIScreen mainScreen] bounds].size.width


#define kDelay  1.5
#define delayRun dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDelay * NSEC_PER_SEC)), dispatch_get_main_queue()

#define kDelay01  0.7
#define delayRun05 dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDelay01 * NSEC_PER_SEC)), dispatch_get_main_queue()

#define kFileManager [NSFileManager defaultManager]
#define kUserDefaults   [NSUserDefaults standardUserDefaults]
#define kWindow         [[UIApplication sharedApplication] keyWindow]


// View 坐标(x,y)和宽高(width,height)
#define X(v)                    (v).frame.origin.x
#define Y(v)                    (v).frame.origin.y
#define WIDTH(v)                (v).frame.size.width
#define HEIGHT(v)               (v).frame.size.height

#define MinX(v)                 CGRectGetMinX((v).frame)
#define MinY(v)                 CGRectGetMinY((v).frame)

#define MidX(v)                 CGRectGetMidX((v).frame)
#define MidY(v)                 CGRectGetMidY((v).frame)

#define MaxX(v)                 CGRectGetMaxX((v).frame)
#define MaxY(v)                 CGRectGetMaxY((v).frame)

/// 系统控件默认高度

#define isiphoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define kStatusBarHeight        [[UIApplication sharedApplication] statusBarFrame].size.height
#define kTopBarHeight           (44.f)
#define kNavigationBarHeight    (isiphoneX ? 88 : 64)
#define kBottomBarHeight        (isiphoneX ? 83 : 49)
#define KHomeIndicatorHeight    (isiphoneX ? 34 : 0)

#define kCellDefaultHeight      (44.f)

#define kEnglishKeyboardHeight  (216.f)
#define kChineseKeyboardHeight  (252.f)
/// BM控件默认高度
#define kViewDefaultHeight          (50.f)
#define onePixel    1/[UIScreen mainScreen].scale
/* ****************************************************************************************************************** */
#pragma mark - Funtion Method (宏 方法)

// PNG JPG 图片路径
#define PNGPATH(NAME)           [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:NAME] ofType:@"png"]
#define JPGPATH(NAME)           [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:NAME] ofType:@"jpg"]
#define PATH(NAME, EXT)         [[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]

// 加载图片
#define PNGkImg(NAME)          [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"png"]]
#define JPGkImg(NAME)          [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"jpg"]]
#define kImg(NAME, EXT)        [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]]

#define V_IMAGE(imgName) [UIImage imageNamed:imgName]


#define URL(url) [NSURL URLWithString:url]
#define string(str1,str2) [NSString stringWithFormat:@"%@%@",str1,str2]
#define s_str(str1) [NSString stringWithFormat:@"%@",str1]
#define s_Num(num1) [NSString stringWithFormat:@"%d",num1]
#define s_Integer(num1) [NSString stringWithFormat:@"%tu",num1]

// 字体大小(常规/粗体)
#define BOLDSYSTEMFONT(FONTSIZE)[UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEMFONT(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]
#define FONT(NAME, FONTSIZE)    [UIFont fontWithName:(NAME) size:(FONTSIZE)]

// 微软雅黑
#define YC_YAHEI_FONT(FONTSIZE) [UIFont fontWithName:@"MicrosoftYaHei" size:(FONTSIZE)]
// 英文 和 数字
#define YC_ENGLISH_FONT(FONTSIZE) [UIFont fontWithName:@"Helvetica Light" size:(FONTSIZE)]

// 颜色(RGB)
#define RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
//#define RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define MYColorFromHEX(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue &0xFF))/255.0 alpha:1.0]

#define STARTTIME   NSDate *startTime = [NSDate date]
#define STOPTIME   DLog(@"Time: %f", -[startTime timeIntervalSinceNow])

//number转String
#define IntTranslateStr(int_str) [NSString stringWithFormat:@"%d",int_str];
#define FloatTranslateStr(float_str) [NSString stringWithFormat:@"%.2d",float_str];

// View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

// 当前版本
#define FSystemVersion          ([[[UIDevice currentDevice] systemVersion] floatValue])
#define DSystemVersion          ([[[UIDevice currentDevice] systemVersion] doubleValue])
#define SSystemVersion          ([[UIDevice currentDevice] systemVersion])

// 当前语言
#define CURRENTLANGUAGE         ([[NSLocale preferredLanguages] objectAtIndex:0])

// 是否Retina屏
#define isRetina                ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(640, 960), \
[[UIScreen mainScreen] currentMode].size) : \
NO)

//// 是否iPhone5
//#define isiPhone5               ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
//CGSizeEqualToSize(CGSizeMake(640, 1136), \
//[[UIScreen mainScreen] currentMode].size) : \
//NO)
//// 是否iPhone4
//#define isiPhone4               ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
//CGSizeEqualToSize(CGSizeMake(640, 960), \
//[[UIScreen mainScreen] currentMode].size) : \
//NO)

#define kWidth(R) (R)*(Screen_Width)/375
#define kHeight(R) (R)*(Screen_Width)/375
//(R)*(Screen_Height)/667

#define font(R) (R)*(Screen_Width)/375

//是否iOS10
#define isIOS10 ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)
//是否ios9
#define isIOS9 ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)
//是否ios8
#define isIOS8 ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
// 是否IOS7
#define isIOS7                  ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
// 是否IOS6
#define isIOS6                  ([[[UIDevice currentDevice]systemVersion]floatValue] < 7.0)

// 是否iPad
#define isPad                   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

// UIView - viewWithTag
#define VIEWWITHTAG(_OBJECT, _TAG)\
\
[_OBJECT viewWithTag : _TAG]

// 本地化字符串
/** NSLocalizedString宏做的其实就是在当前bundle中查找资源文件名“Localizable.strings”(参数:键＋注释) */
#define LocalString(x, ...)     NSLocalizedString(x, nil)
/** NSLocalizedStringFromTable宏做的其实就是在当前bundle中查找资源文件名“xxx.strings”(参数:键＋文件名＋注释) */
#define AppLocalString(x, ...)  NSLocalizedStringFromTable(x, @"someName", nil)

// RGB颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

//#if TARGET_OS_IPHONE
///** iPhone Device */
//#endif
//
//#if TARGET_IPHONE_SIMULATOR
///** iPhone Simulator */
//#endif
//
//// ARC
//#if __has_feature(objc_arc)
///** Compiling with ARC */
//#else
///** Compiling without ARC */
//#endif


/* ****************************************************************************************************************** */
//#pragma mark - Log Method (宏 LOG)

// 日志 / 断点
// =============================================================================================================================
// DEBUG模式
//#define ITTDEBUG

// LOG等级
//#define ITTLOGLEVEL_INFO        10
//#define ITTLOGLEVEL_WARNING     3
//#define ITTLOGLEVEL_ERROR       1

// =============================================================================================================================
// LOG最高等级
//#ifndef ITTMAXLOGLEVEL
//
//#ifdef DEBUG
//#define ITTMAXLOGLEVEL ITTLOGLEVEL_INFO
//#else
//#define ITTMAXLOGLEVEL ITTLOGLEVEL_ERROR
//#endif
//
//#endif

// =============================================================================================================================
// LOG PRINT
// The general purpose logger. This ignores logging levels.
//#ifdef ITTDEBUG
//#define ITTDPRINT(xx, ...)      NSLog(@"< %s:(%d) > : " xx , __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
//#else
//#define ITTDPRINT(xx, ...)      ((void)0)
//#endif

// Prints the current method's name.
//#define ITTDPRINTMETHODNAME()   ITTDPRINT(@"%s", __PRETTY_FUNCTION__)

// Log-level based logging macros.
//#if ITTLOGLEVEL_ERROR <= ITTMAXLOGLEVEL
//#define ITTDERROR(xx, ...)      ITTDPRINT(xx, ##__VA_ARGS__)
//#else
//#define ITTDERROR(xx, ...)      ((void)0)
//#endif
//
//#if ITTLOGLEVEL_WARNING <= ITTMAXLOGLEVEL
//#define ITTDWARNING(xx, ...)    ITTDPRINT(xx, ##__VA_ARGS__)
//#else
//#define ITTDWARNING(xx, ...)    ((void)0)
//#endif
//
//#if ITTLOGLEVEL_INFO <= ITTMAXLOGLEVEL
//#define ITTDINFO(xx, ...)       ITTDPRINT(xx, ##__VA_ARGS__)
//#else
//#define ITTDINFO(xx, ...)       ((void)0)
//#endif

// 条件LOG
//#ifdef ITTDEBUG
//#define ITTDCONDITIONLOG(condition, xx, ...)\
//\
//{\
//if ((condition))\
//{\
//ITTDPRINT(xx, ##__VA_ARGS__);\
//}\
//}
//#else
//#define ITTDCONDITIONLOG(condition, xx, ...)\
//\
//((void)0)
//#endif
//
//// 断点Assert
//#define ITTAssert(condition, ...)\
//\
//do {\
//if (!(condition))\
//{\
//[[NSAssertionHandler currentHandler]\
//handleFailureInFunction:[NSString stringWithFormat:@"< %s >", __PRETTY_FUNCTION__]\
//file:[[NSString stringWithUTF8String:__FILE__] lastPathComponent]\
//lineNumber:__LINE__\
//description:__VA_ARGS__];\
//}\
//} while(0)
/* ************************************************************************************************* */

#define MediumFont(FONTSIZE) [UIFont fontWithName:@"PingFangSC-Medium" size:(FONTSIZE)]


///正常字体
#define H30 [UIFont systemFontOfSize:font(30)]
#define H29 [UIFont systemFontOfSize:font(29)]
#define H28 [UIFont systemFontOfSize:font(28)]
#define H27 [UIFont systemFontOfSize:font(27)]
#define H26 [UIFont systemFontOfSize:font(26)]
#define H25 [UIFont systemFontOfSize:font(25)]
#define H24 [UIFont systemFontOfSize:font(24)]
#define H23 [UIFont systemFontOfSize:font(23)]
#define H22 [UIFont systemFontOfSize:font(22)]
#define H20 [UIFont systemFontOfSize:font(20)]
#define H19 [UIFont systemFontOfSize:font(19)]
#define H18 [UIFont systemFontOfSize:font(18)]
#define H17 [UIFont systemFontOfSize:font(17)]
#define H16 [UIFont systemFontOfSize:font(16)]
#define H15 [UIFont systemFontOfSize:font(15)]
#define H14 [UIFont systemFontOfSize:font(14)]
#define H13 [UIFont systemFontOfSize:font(13)]
#define H12 [UIFont systemFontOfSize:font(12)]
#define H11 [UIFont systemFontOfSize:font(11)]
#define H10 [UIFont systemFontOfSize:font(10)]
#define H8 [UIFont systemFontOfSize:font(8)]

///粗体
#define HB20 [UIFont boldSystemFontOfSize:20]
#define HB18 [UIFont boldSystemFontOfSize:18]
#define HB16 [UIFont boldSystemFontOfSize:16]
#define HB14 [UIFont boldSystemFontOfSize:14]
#define HB13 [UIFont boldSystemFontOfSize:13]
#define HB12 [UIFont boldSystemFontOfSize:12]
#define HB11 [UIFont boldSystemFontOfSize:11]
#define HB10 [UIFont boldSystemFontOfSize:10]
#define HB8 [UIFont boldSystemFontOfSize:8]

///常用颜色
#define black_color     [UIColor blackColor]
#define blue_color      [UIColor blueColor]
#define brown_color     [UIColor brownColor]
#define clear_color     [UIColor clearColor]
#define darkGray_color  [UIColor darkGrayColor]
#define darkText_color  [UIColor darkTextColor]
#define white_color     [UIColor whiteColor]
#define yellow_color    [UIColor yellowColor]
#define red_color       [UIColor redColor]
#define orange_color    [UIColor orangeColor]
#define purple_color    [UIColor purpleColor]
#define lightText_color [UIColor lightTextColor]
#define lightGray_color [UIColor lightGrayColor]
#define green_color     [UIColor greenColor]
#define gray_color      [UIColor grayColor]
#define magenta_color   [UIColor magentaColor]

#define kBackColor UIColorFromRGB(0xd81460)

//常用字体
#define RGB183      RGBCOLOR(183, 183, 183)
#define RGB51      RGBCOLOR(51, 51, 51)

/* iOS设备 */
#define kDevice_Is_iPhone4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6PlusBigMode ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen]currentMode].size) : NO)

#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen]currentMode].size) : NO)
//适配参数
#define KsuitParam (kDevice_Is_iPhone6Plus ?1.12:(kDevice_Is_iPhone6?1.0:(iPhone6PlusBigMode ?1.01:(iPhoneX ? 1.0 : 0.85)))) //以6为基准图


/* ************************************************************************************************* */

//系统版本号
#define _DEVICE_SYSTEM_VERSION_  [[[UIDevice currentDevice] systemVersion]floatValue]

///设备的UDID号
//#define UDID [[[UIDevice currentDevice] identifierForVendor] UUIDString]

//屏幕高、宽
//#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
//#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height - 64

///系统版本号
#define VersionLargerThan7  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define VersionLargerThan8  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define Version7  ([[[UIDevice currentDevice] systemVersion] floatValue] == 7.0)
#define Version8  ([[[UIDevice currentDevice] systemVersion] floatValue] == 8.0)


///获取设备
//#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//
//#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
//
//#define iPhone6_Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
//
//#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

//1.iPhone4分辨率320x480，像素640x960，@2x
//2.iPhone5分辨率320x568，像素640x1136，@2x
//3.iPhone6分辨率375x667，像素750x1334，@2x
//4.iPhone6 Plus分辨率414x736，像素1242x2208，@3x

///获取Xcode的版本号
//#define XcodeAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]



/* ****************************************************************************************************************** */
#pragma mark - Constants (宏 常量)




//** textAlignment ***********************************************************************************
# define LINE_BREAK_WORD_WRAP NSLineBreakByWordWrapping
# define TextAlignmentLeft NSTextAlignmentLeft
# define TextAlignmentCenter NSTextAlignmentCenter
# define TextAlignmentRight NSTextAlignmentRight

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


#endif /* GeneralParamsMacro_h */
