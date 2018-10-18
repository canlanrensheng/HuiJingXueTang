//
//  DiscoverInfoViewController.m
//  TennisClass
//
//  Created by Junier on 2018/2/23.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "DiscoverInfoViewController.h"

@interface DiscoverInfoViewController ()<UIWebViewDelegate>
@property(strong,nonatomic)UIProgressView *progressView;

@end

@implementation DiscoverInfoViewController
{
//    UIImageView *imgview;
    UIWebView *webView;

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [imgview removeFromSuperview];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _name;
    [self getmainview];
//    self.view.backgroundColor = [UIColor whiteColor];
//    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"dis21"] style:UIBarButtonItemStylePlain target:self action:@selector(rightClickedbtn)];
//    self.navigationItem.rightBarButtonItem = rightBarItem;
    // Do any additional setup after loading the view.
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
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 3, kW, self.view.height - SafeAreaTopHeight-3)];
    webView.delegate = self;
    webView.backgroundColor = ALLViewBgColor;
    NSString *urlstr = @"http://www.huijingschool.com/company/protocol.html";
    NSURL *url= [NSURL URLWithString:urlstr];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.view addSubview: webView];
    [webView loadRequest:request];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.progressView setProgress:1 animated:YES];
    self.progressView.hidden = YES;
    CGRect frame = webView.frame;
    frame.origin.y = 0;
    frame.size.height = self.view.height;
    webView.frame = frame;
    
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];//获取当前页面的title
    self.navigationItem.title = title;
}


-(void)rightClickedbtn{
}
@end
