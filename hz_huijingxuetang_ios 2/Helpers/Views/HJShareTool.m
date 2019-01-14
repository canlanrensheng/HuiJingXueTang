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
            //微信朋友圈
            case ShareObjectTypeWXCircle:{
                [[ShareManager shareManager] shareOperation:SSDKPlatformSubTypeWechatTimeline title:title message:content imgs:images url:url shareSuccessBlock:^{
                    
                } shareFailureBlock:^{
                    
                }];
                
            }
                break;
                //微信好友
            case ShareObjectTypeWXFriend:{
                [[ShareManager shareManager] shareOperation:SSDKPlatformSubTypeWechatSession title:title message:content imgs:images url:url shareSuccessBlock:^{
                    
                } shareFailureBlock:^{
                    
                }];
            
            }
                break;
                //QQ好友
            case ShareObjectTypeQQ:{
                [[ShareManager shareManager] shareOperation:SSDKPlatformSubTypeQQFriend title:title message:content imgs:images url:url shareSuccessBlock:^{
                    
                } shareFailureBlock:^{
                    
                }];
            }
                break;
                //QQ空间
            case ShareObjectTypeQZone:{
                [[ShareManager shareManager] shareOperation:SSDKPlatformSubTypeQZone title:title message:content imgs:images url:url shareSuccessBlock:^{
                    
                } shareFailureBlock:^{
                    
                }];
            }
                break;
                //新浪微博
            case ShareObjectTypeWb:{
                [[ShareManager shareManager] shareOperation:SSDKPlatformTypeSinaWeibo title:title message:content imgs:images url:url shareSuccessBlock:^{
                    
                } shareFailureBlock:^{
                    
                }];
            }
                break;
                
//             //腾讯微博
//            case ShareObjectTypeTencentWeibo:{
//                [[ShareManager shareManager] shareOperation:SSDKPlatformTypeTencentWeibo title:title message:content imgs:images url:url shareSuccessBlock:^{
//
//                } shareFailureBlock:^{
//
//                }];
//            }
//                break;
//                //领英
//            case ShareObjectTypeLinkedIn:{
//                [[ShareManager shareManager] shareOperation:SSDKPlatformTypeLinkedIn title:title message:content imgs:images url:url shareSuccessBlock:^{
//
//                } shareFailureBlock:^{
//
//                }];
//            }
//                break;
                
           case ShareObjectTypeCopyLink:{
                //复制链接
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = url;
                ShowMessage(@"链接复制成功");
            }
                break;
            default:
                break;
        }
    }];
    [alert show];
}

@end
