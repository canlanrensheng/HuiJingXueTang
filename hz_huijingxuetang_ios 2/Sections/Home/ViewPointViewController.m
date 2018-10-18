//
//  ViewPointViewController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/1/31.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "ViewPointViewController.h"
#import "GiftView.h"
@interface ViewPointViewController ()<UITextFieldDelegate>

@end

@implementation ViewPointViewController
{
    UIButton *menbanview;
    NSMutableArray *btnarr;
    UIView *giftview;
    UIView *cardview;
    UILabel *label4;
    NSMutableArray *imgarr;
    NSDictionary *dic;
    NSArray *dataarr;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"牛人观点";
    self.view.backgroundColor = ALLViewBgColor;
    [self loaddata];

    // Do any additional setup after loading the view.
}

-(void)loaddata{
    [YJAPPNetwork GeniusviewInfowithId:self.Id success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            dic = [responseObject objectForKey:@"data"];
            [self getmainview];
            SVDismiss;
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
    }];
}


-(void)getmainview{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 25*SW, kW, 50*SW)];
    label.text = [dic objectForKey:@"infomationtitle"];
    label.font = BOLDFONT(30);
    label.textAlignment = 1;
    label.textColor = [UIColor colorWithHexString:@"#f5d836"];
    //阴影颜色
    label.shadowColor = [UIColor colorWithHexString:@"#82700c"];
    //阴影偏移  x，y为正表示向右下偏移
    label.shadowOffset = CGSizeMake(2, 2);
    [self.view addSubview:label];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(15*SW,label.maxY + 25*SW, kW, 30*SW)];
    label1.text = [dic objectForKey:@"createtime"];
    label1.font=FONT(17);
    [self.view addSubview:label1];
//
//    UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(15*SW, label1.maxY+15*SW, kW-30*SW, 190*SW)];
//    imgview.image = [UIImage imageNamed:@"牛人观点_03"];
//    [self.view addSubview:imgview];
    
    NSString * infoString =[NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]];
    UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectMake(15*SW, label1.maxY+15*SW, kW-30*SW, 190*SW)];
    webView.delegate=self;
    [self.view addSubview:webView];
    
    [webView loadHTMLString:infoString baseURL:nil];
    
//    UITextView *textview = [[UITextView alloc]initWithFrame:CGRectMake(0, webView.maxY + 30 , kW, 100*SW)];
//    textview.backgroundColor = [UIColor clearColor];
//    textview.textColor = TextColor;
//    textview.textAlignment = 1;
//    textview.font = TextFont;
//    textview.text = [dic objectForKey:@"content"];
//    [self.view addSubview:textview];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(kW/2-60*SW, webView.maxY+130*SW, 120*SW, 120*SW)];
    [btn setBackgroundImage:[UIImage imageNamed:@"200x200"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(shang) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}


-(void)shang{
    [YJAPPNetwork GiftTasksuccess:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            dataarr = [NSArray array];
            dataarr = [responseObject objectForKey:@"data"];
//            [self admireActon];
            [self getGiftviewWithArr:dataarr];
            SVDismiss;
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
    }];
}


-(void)getGiftviewWithArr:(NSArray *)Arr{
    GiftView *Gview = [[GiftView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    Gview.GiftArr = Arr;
    [self.navigationController.view addSubview:Gview];
}


@end
