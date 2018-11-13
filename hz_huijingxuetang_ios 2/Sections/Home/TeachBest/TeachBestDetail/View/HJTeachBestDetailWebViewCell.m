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
    _webView = [[UIWebView alloc]initWithFrame:self.bounds];
    _webView.dataDetectorTypes = UIDataDetectorTypeLink;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _webView.scalesPageToFit = YES;
    [_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    _webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    _webView.scrollView.bounces = NO;
    [self addSubview:_webView];
}

@end
