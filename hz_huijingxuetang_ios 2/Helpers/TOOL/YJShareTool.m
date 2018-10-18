//
//  YJShareTool.m
//  TennisClass
//
//  Created by 陈燕军 on 2018/5/31.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "YJShareTool.h"
#import <UShareUI/UShareUI.h>

@implementation YJShareTool

+(void)ToolShareUrlWithUrl:(NSString *)url title:(NSString *)title content:(NSString *)content andViewC:(UIViewController *)vc{
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_WechatSession)]]; // 设置需要分享的平台
    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.isShow = NO;//标题的名字
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType=UMSocialSharePageGroupViewPositionType_Bottom;//屏幕位置显示
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType=UMSocialPlatformItemViewBackgroudType_None;//圆形icon
    [UMSocialShareUIConfig shareInstance].shareCancelControlConfig.isShow=NO;//圆形icon
    
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageMaxColumnCountForPortraitAndBottom=2;
    
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        NSLog(@"回调");
        NSLog(@"%ld",(long)platformType);
        NSLog(@"%@",userInfo);
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建网页内容对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:content thumImage:[UIImage imageNamed:@"fenxiangtubiao"]];
        //设置网页地址
        shareObject.webpageUrl = url;
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:vc completion:^(id data, NSError *error) {
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
            }else{
                NSLog(@"response data is %@",data);
            }
        }];
    }];
}

@end
