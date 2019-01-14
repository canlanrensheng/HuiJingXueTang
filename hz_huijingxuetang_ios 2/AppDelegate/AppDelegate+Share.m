//
//  AppDelegate+Share.m
//  ITelematics
//
//  Created by Oma-002 on 2018/9/3.
//  Copyright © 2018年 com.lima. All rights reserved.
//

#import "AppDelegate+Share.h"

#import <ShareSDK/ShareSDK.h>

//#import <UMShare/UMShare.h>

@implementation AppDelegate (Share)
    
- (void)registerSharePlatforms{
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        
        //QQ
        [platformsRegister setupQQWithAppId:@"101530205" appkey:@"03efbd0783bb9bf8746ab227fbe34c0d"];
        
        //微信
        [platformsRegister setupWeChatWithAppId:@"wx9da5846d2c469754" appSecret:@"461c1efa58d8ac25fc2172afdc7c6f4b"];
        
        //新浪
        [platformsRegister setupSinaWeiboWithAppkey:@"3896694739" appSecret:@"a83f38e4fd0b64639a2b1faf84590727" redirectUrl:@"http://www.sharesdk.cn"];

    }];
    
}

@end
