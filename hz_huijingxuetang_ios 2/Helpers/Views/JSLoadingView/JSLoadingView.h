//
//  JSLoadingView.h
//  ITelematics
//
//  Created by Oma-002 on 2018/6/8.
//  Copyright © 2018年 com.lima. All rights reserved.
//

#import "BaseView.h"

@interface JSLoadingView : BaseView

- (void)startAnimating;
- (void)stopLoadingView;

@property (nonatomic,strong) UIActivityIndicatorView *activityView;

@end
