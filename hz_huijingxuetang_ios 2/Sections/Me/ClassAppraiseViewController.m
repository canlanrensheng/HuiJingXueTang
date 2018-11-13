//
//  ClassAppraiseViewController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/2/6.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "ClassAppraiseViewController.h"
//#import "FSTextView.h"
#import "YJAPPNetwork.h"
@interface ClassAppraiseViewController ()

@end

@implementation ClassAppraiseViewController
{
    NSMutableArray *btnarr;
//    FSTextView *textview;
    NSString *remark;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"课程评价";
    self.view.backgroundColor = ALLViewBgColor;
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(releaseInfo)];
    self.navigationItem.rightBarButtonItem = rightBarItem;

    
    UIImageView *topimg = [[UIImageView alloc]initWithFrame:CGRectMake(15*SW, 15*SW, 165*SW, 82.5*SW)];
    NSURL *url = [NSURL URLWithString:[_datadic objectForKey:@"coursepic"]];
    [topimg sd_setImageWithURL:url];
    [self.view addSubview:topimg];
    
    UILabel *titlabel = [[UILabel alloc]initWithFrame:CGRectMake(topimg.maxX +15*SW,topimg.minY+ 15*SW, 150*SW, 20*SW)];
    titlabel.text = [_datadic objectForKey:@"coursename"];
    titlabel.lineBreakMode = NSLineBreakByWordWrapping;
    titlabel.numberOfLines = 3;
    [titlabel sizeToFit];
    [self.view addSubview:titlabel];
    
    UIView *ln = [[UIView alloc]initWithFrame:CGRectMake(0,topimg.maxY + 15*SW, kW, 0.5*SW)];
    ln.backgroundColor = LnColor;
    [self.view addSubview:ln];
    
    UILabel *titlabel1 = [[UILabel alloc]initWithFrame:CGRectMake(15*SW,ln.maxY+ 15*SW, 150*SW, 20*SW)];
    titlabel1.text = @"打分";
    [self.view addSubview:titlabel1];
    btnarr = [NSMutableArray array];
    for (int i = 1; i < 6; i++) {
        UIButton *starimg = [[UIButton alloc]initWithFrame:CGRectMake(kW - 130*SW +20*SW*i,ln.maxY+ 25*SW-7.5*SW, 15*SW, 15*SW)];
        [starimg setBackgroundImage:[UIImage imageNamed:@"36_"] forState:UIControlStateNormal];
        [starimg setBackgroundImage:[UIImage imageNamed:@"37_"] forState:UIControlStateSelected];

        starimg.tag = 7361+i;
        [starimg addTarget:self action:@selector(starAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:starimg];
        [btnarr addObject:starimg];
    }
//    textview = [[FSTextView alloc]initWithFrame:CGRectMake(15*SW, titlabel1.maxY+15*SW, kW - 30*SW, 300*SW)];
//    textview.backgroundColor= [UIColor whiteColor];
//    textview.placeholder = @"评论描述";
//    textview.maxLength = 100;
//    [textview addTextDidChangeHandler:^(FSTextView *textView) {
//        // 文本改变后的相应操作.
//        remark = textview.text;
//    }];
//    //    textview.text = @"两女生等~";
//    [self.view addSubview:textview];

    
}
-(void)starAction:(UIButton *)sender{
    
    for (UIButton *btn  in btnarr) {
        if (btn.tag<=sender.tag) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
}
-(void)releaseInfo{
    int starcount = 0;
    for (UIButton *btn in btnarr) {
        if (btn.selected == YES) {
            starcount++;
        }
    }
    if (starcount == 0) {
        return SVshowInfo(@"请为该课程打分！");
    }
    if (remark.length == 0) {
        return SVshowInfo(@"请填写评论描述！");
    }
    
    NSString *star = [NSString stringWithFormat:@"%d",starcount];
    [YJAPPNetwork appraiseWithAccesstoken:[APPUserDataIofo AccessToken] Id:[_datadic objectForKey:@"courseid"] content:remark star:star success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            SVShowSuccess(@"提交成功");
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
    }];
    
    
}

@end
