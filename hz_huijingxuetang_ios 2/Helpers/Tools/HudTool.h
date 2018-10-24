//
//  HudTool.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/18.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HudTool : NSObject

extern void ShowHudInView(UIView *view, NSString *statues);
extern void ShowHint(NSString *statues);
extern void ShowHudWithEnable(NSString *statues,BOOL userInteractionEnabled);
extern void ShowSuccessInView(UIView *view, NSString *statues);
extern void ShowSuccess(NSString *statues);
extern void ShowErrorInView(UIView *view, NSString *statues);
extern void ShowError(NSString *statues);
extern void ShowMessageInView(UIView *view,NSString *statues);
extern void ShowMessage(NSString *statues);
extern void HideHudInView(UIView *view);
extern void hideHud(void);
extern UIViewController *VisibleViewController(void);
extern UIViewController *getCurrentVC(void);

@end


