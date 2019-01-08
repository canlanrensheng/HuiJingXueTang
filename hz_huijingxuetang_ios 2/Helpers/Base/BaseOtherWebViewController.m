//
//  BaseOtherWebViewController.m
//  MKnight
//
//  Created by 张金山 on 2018/1/25.
//  Copyright © 2018年 张金山. All rights reserved.
//

#import "BaseOtherWebViewController.h"
#import "WebProgressLayer.h"

@interface BaseOtherWebViewController () <UIWebViewDelegate> {
    WebProgressLayer *_progressLayer; ///< 网页加载进度条
}
@property(nonatomic, strong) UIWebView *webView;
@property(nonatomic, strong) UIBarButtonItem *backBtn;
@property(nonatomic, strong) UIBarButtonItem *canBackBtn;

@end

@implementation BaseOtherWebViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
    self.fd_interactivePopDisabled = YES;
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    self.fd_interactivePopDisabled = NO;
}

- (UIBarButtonItem *)canBackBtn {
    if (!_canBackBtn) {
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"back_n" style:UIBarButtonItemStylePlain target:self action:@selector(closeClick)];
        _canBackBtn = backBtn;
    }
    return _canBackBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_n"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackClicked)];
    self.backBtn = backBtn;
    self.navigationItem.leftBarButtonItems = @[backBtn];
    
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - kNavigationBarHeight)];
    web.delegate = self;
    
    if (!self.url && self.urlStr) {
        self.url = [NSURL URLWithString:self.urlStr];
    }
    
    if (self.htmlString) {
        [web loadHTMLString:self.htmlString baseURL:nil];
        
    } else {
        NSURLRequest *requests = [NSURLRequest requestWithURL:self.url];
        [web loadRequest:requests];
    }
    
    web.allowsInlineMediaPlayback = YES;
    web.mediaPlaybackRequiresUserAction = NO;
    web.scalesPageToFit = YES;
    
    [self.view addSubview:web];
    self.webView = web;
    _progressLayer = [WebProgressLayer new];
    _progressLayer.frame = CGRectMake(0, 42, Screen_Width, 2);
    
    [self.navigationController.navigationBar.layer addSublayer:_progressLayer];
}

- (void)closeClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onBackClicked {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self closeClick];
    }
}

- (void)setUrlStr:(NSString *)urlStr {
    _urlStr = urlStr;
    if (urlStr == nil ||
        [urlStr isEqualToString:@""] ||
        [urlStr isKindOfClass:[NSNull class]] ||
        urlStr == NULL ||
        [[urlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return;
    }
    
    if ([_urlStr rangeOfString:@"http"].location == NSNotFound) {
        _urlStr = [NSString stringWithFormat:@"http://%@", _urlStr];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *strUrl = request.URL.absoluteString;
    if ([strUrl isEqualToString:@"about:blank"]) {
        return NO;
    }
    NSDictionary *infoDic = [self getDicWith:strUrl];
    NSString *action = infoDic[@"action"];
    if ([action isEqualToString:@"share"]) {
        
    } else if ([action isEqualToString:@"goSign"]) {
      
    } else if ([action isEqualToString:@"exchangeSceccess"]) {
       
    }
    
    return YES;
}

- (NSMutableDictionary *)getDicWith:(NSString *)strUrl {
    
    NSURL *url = [NSURL URLWithString:strUrl];
    NSRange range = [strUrl rangeOfString:url.host];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    strUrl = [strUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    if ([strUrl hasPrefix:@"hybx://com.hybx.app?"]) {
        
        strUrl = [strUrl substringFromIndex:20];
        
        NSArray *arr = [strUrl componentsSeparatedByString:@"&"];
        
        for (NSString *str1 in arr) {
            
            NSArray *arr1 = [str1 componentsSeparatedByString:@"="];
            if (arr1.count > 1) {
                
                NSMutableString *strM = [[NSMutableString alloc] init];
                for (int j = 1; j < arr1.count; j++) {
                    [strM appendString:arr1[j]];
                    if (j < arr1.count - 1) {
                        [strM appendString:@"="];
                    }
                }
                
                [dic setValue:strM forKey:arr1[0]];
            }
        }
    } else {
        if (range.location != NSNotFound) {
            NSRange range0 = [strUrl rangeOfString:@"?"];
            if (strUrl.length > (range0.location + range0.length)) {
                
                NSString *strU = [strUrl substringFromIndex:(range0.location + range0.length)];
                
                NSArray *arr = [strU componentsSeparatedByString:@"&"];
                
                for (NSString *str1 in arr) {
                    
                    NSArray *arr1 = [str1 componentsSeparatedByString:@"="];
                    if (arr1.count > 1) {
                        
                        NSMutableString *strM = [[NSMutableString alloc] init];
                        for (int j = 1; j < arr1.count; j++) {
                            [strM appendString:arr1[j]];
                            if (j < arr1.count - 1) {
                                [strM appendString:@"="];
                            }
                        }
                        [dic setValue:strM forKey:arr1[0]];
                    }
                }
                
            }
            
        }
    }
    return dic;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [_progressLayer startLoad];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_progressLayer finishedLoad];
    if (self.webTitle.length > 0) {
        self.title = _webTitle;
    } else {
        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    if (webView.canGoBack) {
        self.navigationItem.leftBarButtonItems = @[self.backBtn, self.canBackBtn];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_progressLayer finishedLoad];
    if (error) {
        if (webView.canGoBack) {
            self.navigationItem.leftBarButtonItems = @[self.backBtn, self.canBackBtn];
            [MBProgressHUD showError:@"加载失败" toView:self.view];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

#pragma mark - UIWebView Delegate Methods

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    if (self.isFromOder) {
//        // 禁用返回手势
//        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//        }
//    }
    
}


- (void)dealloc {
    [_progressLayer closeTimer];
    [_progressLayer removeFromSuperlayer];
    _progressLayer = nil;
    DLog(@"i am dealloc");
}
@end
