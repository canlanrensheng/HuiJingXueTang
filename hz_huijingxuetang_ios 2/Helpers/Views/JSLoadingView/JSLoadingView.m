//
//  JSLoadingView.m
//  ITelematics
//
//  Created by Oma-002 on 2018/6/8.
//  Copyright © 2018年 com.lima. All rights reserved.
//

#import "JSLoadingView.h"

@interface JSLoadingView ()


@end

@implementation JSLoadingView



- (UIActivityIndicatorView *)activityView {
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.hidesWhenStopped = YES;
    }
    return _activityView;
}

- (void)hj_configSubViews{
    self.backgroundColor = white_color;
    [self addSubview:self.activityView];
    [self.activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.center.mas_equalTo(self);
    }];
}

- (void)startAnimating{
    [self.activityView startAnimating];
}


- (void)stopLoadingView{
    [self.activityView stopAnimating];
    [self.activityView removeFromSuperview];
    [self removeFromSuperview];
}

@end
