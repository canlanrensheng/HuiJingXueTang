//
//  CheckVersion.h
//  Zhuan
//
//  Created by txooo on 16/6/27.
//  Copyright © 2016年 张金山. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXCheckVersion : NSObject
/**
 *  default if No, set Yes to print the info in Debug arae
 */
@property (nonatomic, assign) BOOL debugEnable;
/**
 *  open APPStore inside your APP, default is No.
 */
@property (nonatomic, assign) BOOL openAPPStoreInsideAPP;
//  if you can't get the update info of your APP. Set countryAbbreviation of the sale area. like `countryAbbreviation = @"cn"`,`countryAbbreviation = @"us"`.General, you don't need to set this property.
@property (nonatomic, copy) NSString *countryAbbreviation;

//是否强制更新
@property (nonatomic,assign) BOOL isForceUpdate;
/**
 *  get a singleton of the Check Manager
 */
+ (instancetype)sharedCheckManager;
/**
 *  start check version with default param.
 */
- (void)checkVersion;
/**
 *  start check version with AlertTitle,NextTimeTitle,ConfimTitle.
 */
- (void)checkVersionWithAlertTitle:(NSString *)alertTitle nextTimeTitle:(NSString *)nextTimeTitle confimTitle:(NSString *)confimTitle;
/**
 *  start check version with AlertTitle,NextTimeTitle,ConfimTitle,skipVersionTitle.
 */
- (void)checkVersionWithAlertTitle:(NSString *)alertTitle nextTimeTitle:(NSString *)nextTimeTitle confimTitle:(NSString *)confimTitle skipVersionTitle:(NSString *)skipVersionTitle;
@end

@interface UpdateAlertViewController : UIViewController
@property (nonatomic,copy) NSString *alertTitle;
@property (nonatomic,copy) NSString *message;
@property (nonatomic,copy) NSString *updateUrl;
- (void)setAlertView;
@end
