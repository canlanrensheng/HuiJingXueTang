//
//  AdJumpViewController.m
//  TennisClass
//
//  Created by Junier on 2018/3/8.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "AdJumpViewController.h"
@interface AdJumpViewController ()<UIWebViewDelegate>
@property(strong,nonatomic)UIProgressView *progressView;

@end

@implementation AdJumpViewController
{
    UIWebView *webView;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //    [imgview removeFromSuperview];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getmainview];
    self.navigationItem.title = self.title;
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)getmainview{
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];//这里是设定progressView的模式为默认模式
    self.progressView.frame = CGRectMake(0,  0, kW, 3);
    self.progressView.progressTintColor=[UIColor greenColor];//设定progressView的显示颜色
//        CGAffineTransform transform = CGAffineTransformMakeScale(1.0, 2.0f);
//        self.progressView.transform = transform;//设定宽高
    self.progressView.trackImage = [UIImage imageNamed:@"2jindutiao"];
    self.progressView.contentMode = UIViewContentModeScaleAspectFill;
    [self.progressView setProgress:0.8 animated:YES];
    [self.view insertSubview:self.progressView atIndex:999];

    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 3, kW, kH- SafeAreaTopHeight + SafeAreaBottomHeight)];
    webView.delegate = self;
    webView.backgroundColor = ALLViewBgColor;
    [self.view addSubview: webView];
    NSString *urlstr = [NSString stringWithFormat:@"%@",self.url];

    if ([self.type integerValue] == 0) {
        [webView loadHTMLString:urlstr baseURL:nil];

    }else{
        NSURL *url= [NSURL URLWithString:urlstr];
        NSURLRequest *request =[NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    [self.progressView setProgress:1 animated:YES];
    self.progressView.hidden = YES;
    CGRect frame = webView.frame;
    frame.origin.y = 0;
    frame.size.height = self.view.height;
    webView.frame = frame;

//    [UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];//获取当前页面的title
    self.navigationItem.title = title;

}


@end
