//
//  HudTool.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/18.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HudTool.h"

@implementation HudTool

extern void ShowHudInView(UIView *view, NSString *statues) {
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
            hud.userInteractionEnabled = NO;
            hud.labelText = statues;
        });
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.userInteractionEnabled = NO;
        hud.labelText = statues;
    }
}

void ShowHint(NSString *statues) {
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *hud = [MBProgressHUD showHUD:VisibleViewController().view];
            hud.labelText = statues;
        });
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUD:VisibleViewController().view];
        hud.labelText = statues;
    }
}

void ShowHudWithEnable(NSString *statues,BOOL userInteractionEnabled) {
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:VisibleViewController().view animated:YES];
            hud.labelText = statues;
            hud.userInteractionEnabled = userInteractionEnabled;
        });
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:VisibleViewController().view animated:YES];
        hud.labelText = statues;
        hud.userInteractionEnabled = userInteractionEnabled;
    }
}

void ShowSuccessInView(UIView *view, NSString *statues) {
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showSuccess:statues toView:view];
        });
    }else{
        [MBProgressHUD showSuccess:statues toView:view];
    }
}

void ShowSuccess(NSString *statues) {
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD showSuccess:statues toView:VisibleViewController().view];
//            [MBProgressHUD showSuccessMessage:statues];
            
            ShowMessage(statues);
        });
    }else{
//        [MBProgressHUD showSuccess:statues toView:VisibleViewController().view];
//        [MBProgressHUD showSuccessMessage:statues];
        ShowMessage(statues);
    }
}

void ShowErrorInView(UIView *view, NSString *statues) {
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showError:statues toView:view];
        });
    }else{
        [MBProgressHUD showError:statues toView:view];
    }
}

void ShowError(NSString *statues) {
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD showError:statues toView:VisibleViewController().view];
//            [MBProgressHUD show:statues];
//            ShowMessage(statues);
            [MBProgressHUD showMessage:statues view:[UIApplication sharedApplication].keyWindow];
        });
    }else{
//        [MBProgressHUD showError:statues toView:VisibleViewController().view];
//        [MBProgressHUD showInfoMessage:statues];
//        ShowMessage(statues);
        [MBProgressHUD showMessage:statues view:[UIApplication sharedApplication].keyWindow];
    }
}

void ShowMessageInView(UIView *view,NSString *statues) {
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showMessage:statues view:view];
        });
    }else{
        [MBProgressHUD showMessage:statues view:view];
    }
}

void ShowMessage(NSString *statues) {
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showMessage:statues view:[UIApplication sharedApplication].keyWindow];
            
        });
    }else{
        [MBProgressHUD showMessage:statues view:[UIApplication sharedApplication].keyWindow];
    }
}

void HideHudInView(UIView *view) {
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *huds = [MBProgressHUD allHUDsForView:view];
            for (MBProgressHUD *hud in huds) {
                if (!hud.detailsLabelText) {
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES];
                }
            }
        });
    }else{
        NSArray *huds = [MBProgressHUD allHUDsForView:view];
        for (MBProgressHUD *hud in huds) {
            if (!hud.detailsLabelText) {
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES];
            }
        }
    }
}

extern void hideHud(void) {
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *huds = [MBProgressHUD allHUDsForView:VisibleViewController().view];
            for (MBProgressHUD *hud in huds) {
                if (!hud.detailsLabelText) {
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES];
                }
            }
        });
    }else{
        NSArray *huds = [MBProgressHUD allHUDsForView:VisibleViewController().view];
        for (MBProgressHUD *hud in huds) {
            if (!hud.detailsLabelText) {
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES];
            }
        }
    }
}

UIViewController *VisibleViewController() {
    UIViewController *rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
    while ([rootVC isKindOfClass:[UINavigationController class]]) {
        rootVC = [(UINavigationController *)rootVC visibleViewController];
    }
    while ([rootVC isKindOfClass:[UITabBarController class]]) {
        rootVC = [(UITabBarController *)rootVC selectedViewController];
        if ([rootVC isKindOfClass:[UINavigationController class]]) {
            rootVC = [(UINavigationController *)rootVC visibleViewController];
        }
    }
    return rootVC;
}

UIViewController *getCurrentVC(){
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) result = nextResponder;
    else result = window.rootViewController;
    return result;
}

@end
