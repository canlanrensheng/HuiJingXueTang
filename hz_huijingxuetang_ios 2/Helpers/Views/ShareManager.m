//
//  ShareManager.m
//  ITelematics
//
//  Created by Oma-002 on 2018/9/4.
//  Copyright © 2018年 com.lima. All rights reserved.
//

#import "ShareManager.h"

@implementation ShareManager

+ (instancetype)shareManager{
    static  ShareManager * shareObj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareObj = [[ShareManager alloc] init];
    });
    return shareObj;
}

- (void)shareOperation:(SSDKPlatformType)platformType title:(NSString *)title message:(NSString *)message imgs:(NSArray *)imgs url:(NSString *)url shareSuccessBlock:(ShareSuccessBlock)shareSuccessBlock shareFailureBlock:(ShareFailureBlock)shareFailureBlock{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = imgs;
    [shareParams SSDKSetupShareParamsByText:message
                                         images:imageArray //传入要分享的图片
                                            url:[NSURL URLWithString:url]
                                          title:title
                                           type:SSDKContentTypeAuto];
 
    
    //进行分享
    [ShareSDK share:platformType //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         // 回调处理....
         DLog(@"获取到的失败的原因是:%@ %ld",[error.userInfo objectForKey:@"description"],error.code);
         
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 [MBProgressHUD showMessage:@"分享成功" view:[UIApplication sharedApplication].keyWindow];
                 shareSuccessBlock();
                 break;
             }
             case SSDKResponseStateFail:
             {
                 [MBProgressHUD showMessage:@"分享失败" view:[UIApplication sharedApplication].keyWindow];
                 shareFailureBlock();
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 shareFailureBlock();
                 break;
             }
             default:
                 break;
         }
     }];
}

@end
