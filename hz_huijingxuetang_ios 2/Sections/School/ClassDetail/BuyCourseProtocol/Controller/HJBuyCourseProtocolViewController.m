//
//  HJBuyCourseProtocolViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/27.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJBuyCourseProtocolViewController.h"
#import "PopSignatureView.h"
#import <WebKit/WebKit.h>
@interface HJBuyCourseProtocolViewController ()<PopSignatureViewDelegate,WKNavigationDelegate,WKUIDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) PopSignatureView *signatureView;
@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,assign) CGFloat webViewHeight;
@property (nonatomic,strong) UIButton *agreeBtn;
@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;


@end

@implementation HJBuyCourseProtocolViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
    self.fd_interactivePopDisabled = YES;
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    self.fd_interactivePopDisabled = NO;
    [self.signatureView hide];

}

- (UIBarButtonItem*)createBackButton{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, kHeight(30), kHeight(30));
    [backButton setImage:[UIImage imageNamed:@"导航返回按钮"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"导航返回按钮"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(popSelf) forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)popSelf {
    [DCURLRouter popViewControllerWithTimes:self.navigationController.viewControllers.count - 2 animated:YES];
}

- (void)hj_setNavagation {
    self.title = @"购课协议";
    self.view.backgroundColor = white_color;
    self.navigationItem.leftBarButtonItem = [self createBackButton];
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.hidesWhenStopped = YES;
        [self.view addSubview:_indicatorView];
        
        [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.center.mas_equalTo(self.view);
        }];
    }
    return _indicatorView;
}

- (WKWebView *)webView {
    if(!_webView) {
        _webView = [[WKWebView alloc] init];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.scrollView.delegate = self;
        //开了支持滑动返回
        _webView.allowsBackForwardNavigationGestures = YES;
        _webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        _webView.scrollView.bounces = NO;
    }
    return _webView;
}

- (void)hj_configSubViews {
    UIView *headerView= [[UIView alloc] init];
    headerView.backgroundColor = HEXColor(@"#EB5050");
    [self.view addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(kHeight(30));
    }];
    UILabel *warnLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"温馨提示：购买课程前请仔细阅读下方协议并签字！",MediumFont(font(11)),white_color);
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [headerView addSubview:warnLabel];
    [warnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView);
        make.left.equalTo(headerView).offset(kWidth(10.0));
    }];
    
    //底部的按钮
    UIButton *agreeBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"我已阅读并同意《慧鲸购课协议》",MediumFont(font(13)),white_color,0);
        button.userInteractionEnabled = NO;
        button.backgroundColor = HEXColor(@"#ec9373");
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            PopSignatureView *signatureView = [[PopSignatureView alloc] init];
            signatureView.delegate = self;
            [signatureView show];
            self.signatureView = signatureView;
        }];
    }];
    [self.view addSubview:agreeBtn];
    self.agreeBtn = agreeBtn;
    [agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-KHomeIndicatorHeight);
        make.height.mas_equalTo(kHeight(49));
    }];
    
    //添加webView
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(warnLabel.mas_bottom).offset(kWidth(10));
        make.left.equalTo(self.view).offset(kWidth(10));
        make.right.equalTo(self.view).offset(-kWidth(10));
        make.bottom.equalTo(self.view).offset(-(kHeight(49) + KHomeIndicatorHeight));
    }];
    NSURLRequest *reuest = [NSURLRequest requestWithURL:URL(@"https://www.huijingschool.com/company/protocol.html")];
    [self.webView loadRequest:reuest];
    
    //加载试图
    [self.activityView startAnimating];
}

#pragma mark - SocialSignatureViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
   if ((NSInteger)(scrollView.contentSize.height - scrollView.contentOffset.y) == (NSInteger)(scrollView.frame.size.height)) {
       self.agreeBtn.backgroundColor = HEXColor(@"#FF4400");
       self.agreeBtn.userInteractionEnabled = YES;
    }
}

//提交的操作
- (void)onSubmitBtn:(UIImage *)signatureImg {
//    UIImageWriteToSavedPhotosAlbum(signatureImg, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    
    NSString *isKillPrice = self.params[@"isKillPrice"];
    NSString *coursepic = self.params[@"coursepic"];
    if([isKillPrice intValue] == 1) {
        //生成砍价的订单
        NSString *courseId = self.params[@"courseId"];
        NSString *base64String = [self UIImageToBase64Str:signatureImg];
        ShowHint(@"");
        [YJAPPNetwork CreateKillPriceOrderWithAccesstoken:[APPUserDataIofo AccessToken] courseId:courseId picData:base64String success:^(NSDictionary *responseObject) {
            NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
            hideHud();
            if (code == 200) {
                NSString *orderid = [responseObject objectForKey:@"data"];
                //分享的操作
                NSString *courceName = @"动动手，快来帮我砍一刀";
                NSString *coursedes = @"慧鲸学堂 全民砍价 乐享好课！在有效时限内砍价到最低价，即可享受最大购课优惠！";
                id shareImg = coursepic;
                if(coursepic.length <= 0) {
                    shareImg = V_IMAGE(@"shareImg");
                }
              
                NSString *shareUrl = [NSString stringWithFormat:@"%@bargain?orderid=%@",API_SHAREURL,orderid];
                if([APPUserDataIofo UserID].length > 0) {
                    shareUrl = [NSString stringWithFormat:@"%@&userid=%@",shareUrl,[APPUserDataIofo UserID]];
                }
                [HJShareTool shareWithTitle:courceName content:coursedes images:@[shareImg] url:shareUrl];
            }else{
                ShowMessage([responseObject valueForKey:@"msg"]);
            }
        } failure:^(NSString *error) {
            hideHud();
            ShowMessage(error);
        }];
    } else {
        //生成普通的订单
        ShowHint(@"");
        NSString *courseId = self.params[@"courseId"];
        NSString *base64String = [self UIImageToBase64Str:signatureImg];
        [YJAPPNetwork WillPayWithAccesstoken:[APPUserDataIofo AccessToken] cids:courseId picData:base64String  success:^(NSDictionary *responseObject) {
            hideHud();
            NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSString *orderid = [responseObject objectForKey:@"data"];
                //确认订单页面
                NSDictionary *para = @{@"orderId" : orderid};
                [DCURLRouter pushURLString:@"route://confirmOrderVC" query:para animated:YES];
            } else {
                ShowMessage([responseObject valueForKey:@"msg"]);
            }
        } failure:^(NSString *error) {
            hideHud();
            ShowMessage(error);
        }];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    DLog(@"保存的状态是:%@",msg);
}

//图片转字符串
- (NSString *)UIImageToBase64Str:(UIImage *)image{
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{//这里修改导航栏的标题，动态改变
    [self.activityView stopAnimating];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    [self.activityView stopAnimating];
}
// 接收到服务器跳转请求之后再执行
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    WKNavigationResponsePolicy actionPolicy = WKNavigationResponsePolicyAllow;
    //这句是必须加上的，不然会异常
    decisionHandler(actionPolicy);
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow;
    if (navigationAction.navigationType==WKNavigationTypeBackForward) {//判断是返回类型

    }
    //这句是必须加上的，不然会异常
    decisionHandler(actionPolicy);
}

@end
