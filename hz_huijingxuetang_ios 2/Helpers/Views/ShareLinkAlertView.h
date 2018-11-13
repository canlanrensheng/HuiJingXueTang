//
//  ShareLinkAlertView.h
//  ITelematics
//
//  Created by Oma-002 on 2018/9/12.
//  Copyright © 2018年 com.lima. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,ShareObjectType){
    ShareObjectTypeWXFriend,  //微信好友
    ShareObjectTypeWXCircle,//微信朋友圈
    ShareObjectTypeQQ,  //QQ
    ShareObjectTypeWb
};

@interface ShareLinkAlertView : UIView

- (ShareLinkAlertView*)initWithBlock:(void(^)(ShareObjectType shareObjectType))block;

- (void)show;

@end