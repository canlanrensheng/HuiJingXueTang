//
//  HJShareTool.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/5.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJShareTool.h"
#import "ShareManager.h"
#import "ShareLinkAlertView.h"
@implementation HJShareTool

+ (void)shareWithTitle:(NSString *)title content:(NSString *)content images:(NSArray *)images url:(NSString *)url {
    ShareLinkAlertView *alert = [[ShareLinkAlertView alloc] initWithBlock:^(ShareObjectType shareObjectType) {
        switch (shareObjectType) {
            case ShareObjectTypeWXCircle:{
                [[ShareManager shareManager] shareOperation:SSDKPlatformSubTypeWechatTimeline title:title message:content imgs:images url:url shareSuccessBlock:^{
                    
                } shareFailureBlock:^{
                    
                }];
                
            }
                break;
            case ShareObjectTypeWXFriend:{
                [[ShareManager shareManager] shareOperation:SSDKPlatformSubTypeWechatSession title:title message:content imgs:images url:url shareSuccessBlock:^{
                    
                } shareFailureBlock:^{
                    
                }];
            
            }
                break;
            case ShareObjectTypeQQ:{
                [[ShareManager shareManager] shareOperation:SSDKPlatformSubTypeQQFriend title:title message:content imgs:images url:url shareSuccessBlock:^{
                    
                } shareFailureBlock:^{
                    
                }];
            }
                break;
                
            default:{
                [[ShareManager shareManager] shareOperation:SSDKPlatformTypeSinaWeibo title:title message:content imgs:images url:url shareSuccessBlock:^{
                    
                } shareFailureBlock:^{
                    
                }];
            }
                break;
        }
    }];
    [alert show];
}

@end