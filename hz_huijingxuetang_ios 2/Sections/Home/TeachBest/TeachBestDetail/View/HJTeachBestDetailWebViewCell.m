//
//  HJTeachBestDetailWebViewCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/12.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJTeachBestDetailWebViewCell.h"

@implementation HJTeachBestDetailWebViewCell

- (void)hj_configSubViews {
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(kWidth(10), kHeight(10.0), self.bounds.size.width - kWidth(20), self.bounds.size.height )];
    _webView.backgroundColor = white_color;
    //开了支持滑动返回
    _webView.allowsBackForwardNavigationGestures = YES;
    _webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    _webView.scrollView.bounces = NO;
    _webView.scrollView.scrollEnabled = NO;

    [self addSubview:_webView];
}

@end
