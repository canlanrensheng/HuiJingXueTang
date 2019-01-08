//
//  BaseViewController.h
//  Zhuan
//
//  Created by txooo on 16/3/1.
//  Copyright © 2016年 张金山. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewControllerProtocol.h"


@interface BaseViewController : UIViewController<BaseViewControllerProtocol>
//instead delegate
@property (nonatomic,strong) RACSubject *completionSubject;

@property (nonatomic,strong) UIActivityIndicatorView *activityView;

- (void)startAnimating ;
- (void)stopLoadingView ;



@end
