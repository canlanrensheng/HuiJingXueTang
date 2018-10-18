//
//  HomePageViewController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/1/15.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HomePageViewController.h"
#import "DiagnoseViewController.h"
#import "TeacherViewController.h"
#import "FollowViewController.h"
#import "FreeLiveViewController.h"
#import "PlanViewController.h"
#import "TacticsViewController.h"
#import "LivePageViewController.h"
#import "InfoMationInfoViewController.h"
#import "SeverChatViewController.h"
#import "TeacherInfoViewController.h"
#import "ClassInfoViewController.h"
#import <MJRefresh.h>
#import <GCCycleScrollView.h>
#import "AdJumpViewController.h"
@interface HomePageViewController ()<GCCycleScrollViewDelegate,UIScrollViewDelegate>

@end

@implementation HomePageViewController
{
    UIScrollView *scrollview;
    NSArray *teacherArr;
    NSArray *FreeArr;
    NSArray *payArr;
    NSArray *actcilesArr;
    NSDictionary *datatopdic1;
    NSDictionary *datatopdic2;
    BOOL load[6];
    GCCycleScrollView *cycleScroll;
    NSArray *Adarr;
    NSArray *bestNewArr;
    NSTimer *timer;
    CGFloat rang;
    UIScrollView *newScrollView;
    double TimesCountD;
}

-(void)dealloc{
    [timer invalidate];
    timer = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];

}
- (IBAction)senerbtnAction:(id)sender {
    SeverChatViewController *vc = [[SeverChatViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    [self.navigationController setNavigationBarHidden:NO];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navH.constant = SafeAreaTopHeight;
    //这个的目的是为了使得启动app时，单元格是收缩的
    for (int i=0; i<6; i++) {
        load[i] = NO;
    }
    scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, kW, kH-SafeAreaTopHeight-48)];
    scrollview.backgroundColor = ALLViewBgColor;
    scrollview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadnew)];
    [self.view addSubview:scrollview];
    
    [self loadnew];

    // Do any additional setup after loading the view from its nib.
}

-(void)loaddataFree:(NSString *)type{
    [YJAPPNetwork HomeViewFreeAndType:type success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            load[2] = YES;
            FreeArr = [NSArray array];
            FreeArr = [responseObject objectForKey:@"data"];
            [self freecourse];
            [self loaddataPay:@"pay"];
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];

    }];
}

- (void)loaddataPay:(NSString *)type{
    [YJAPPNetwork HomeViewFreeAndType:type success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            load[3] = YES;
            payArr = [NSArray array];
            payArr = [responseObject objectForKey:@"data"];
            [self chargingcourse];
            [self loadNewsList];
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
        
    }];
}


-(void)loadnew{
    [YJAPPNetwork HomeViewNewsuccess:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            bestNewArr = [NSArray array];
            bestNewArr = responseObject[@"data"];
            load[0] = YES;
            [self getmainview];
            [self loadLivewLogo];
            [self loadadpage];
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
    }];
    
}

- (void)loadadpage {
    [YJAPPNetwork getAdSuccess:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            Adarr = [NSArray array];
            Adarr = responseObject[@"data"];
            NSMutableArray *urlArr = [NSMutableArray array];
            
            for (NSDictionary *dic in Adarr) {
                NSString *url = dic[@"picurl"];
                [urlArr addObject:url];
            }
            cycleScroll.imageUrlGroups = urlArr;
            SVDismiss;
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        SVshowInfo(netError);
    }];
}


- (void)loadTeacher {
    [YJAPPNetwork HomeViewTeachersuccess:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        
        if (code == 200) {
            load[1] = YES;
            teacherArr = [NSArray array];
            teacherArr = [responseObject objectForKey:@"data"];
            [self mastercommend];
            [self loaddataFree:@"free"];

        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];

    }];
}

- (void)loadNewsList {
    [YJAPPNetwork HomeViewNewslistsuccess:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            load[4] = YES;
            actcilesArr = [NSArray array];
            actcilesArr = [responseObject objectForKey:@"data"];
            [self actciles];
            [scrollview.mj_header endRefreshing];
            SVDismiss;
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
    }];
}

-(void)loadtopLive:(NSString *)type{
    [YJAPPNetwork LivecourselivingWithType:type success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            if ([type integerValue]== 1) {
                datatopdic1 = [responseObject objectForKey:@"data"];
                [self loadtopLive:@"2"];
            }else{
                datatopdic2 = [responseObject objectForKey:@"data"];
            }
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
    }];
}

- (void)loadLivewLogo{
    [YJAPPNetwork HomeViewlivelogsuccess:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        
        if (code == 200) {
            datatopdic1 = [responseObject objectForKey:@"data"];
            load[5] = YES;
            [self loadTeacher];
            [self getliveview];
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
    }];
}

- (void)getmainview{
    for (UIView *view in scrollview.subviews) {
        if (view != scrollview.mj_header) {
            [view removeFromSuperview];
        }
    }

    
    UIView *topview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kW, 100*SW)];
    [scrollview addSubview:topview];
    
    cycleScroll = [[GCCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, topview.frame.size.width, topview.frame.size.height)];
    cycleScroll.backgroundColor = ALLViewBgColor;
    cycleScroll.autoScrollTimeInterval = 5;
    cycleScroll.dotColor = [UIColor whiteColor];
    cycleScroll.delegate = self;
    [topview addSubview:cycleScroll];


    NSArray *btnimgarr = @[@"2_",@"11_",@"10_",@"9_"];
    NSArray *btnlbarr = @[@"VIP实战直播",@"跟牛人",@"专家诊股",@"VIP策略"];

    for (int i = 0; i < 4; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(kW/4*i, 100*SW, kW/4, 90*SW)];
        view.backgroundColor = [UIColor whiteColor];
        [scrollview addSubview:view];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(view.width/2 - 25*SW, 10*SW, 45*SW, 45*SW)];
        btn.tag = 1234+i;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:btnimgarr[i]] forState:UIControlStateNormal];
        [view addSubview:btn];
        
        UILabel *btnlb = [[UILabel alloc]initWithFrame:CGRectMake(0, 62*SW, view.width, 18*SW)];
        btnlb.text = btnlbarr[i];
        btnlb.textAlignment = 1;
        btnlb.font = BOLDFONT(15);
        [view addSubview:btnlb];
    }
    UIView *bestnew = [[UIView alloc]initWithFrame:CGRectMake(0, 190*SW, kW, 35*SW)];
    bestnew.backgroundColor = [UIColor colorWithHexString:@"#a5bffb"];
    [scrollview addSubview:bestnew];
    
    UIImageView *bestimg = [[UIImageView alloc]initWithFrame:CGRectMake(16.5*SW, 10*SW, 80*SW, 15*SW)];
    bestimg.image = [UIImage imageNamed:@"8_"];
    [bestnew addSubview:bestimg];
    
    UIView *lnview = [[UIView alloc]initWithFrame:CGRectMake(bestimg.maxX +10*SW, 10*SW, 1*SW, 15*SW)];
    lnview.backgroundColor = CWHITE;
    [bestnew addSubview:lnview];
    
    newScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(lnview.maxX, 0, bestnew.width - 50*SW - lnview.maxX, bestnew.height)];
    newScrollView.delegate = self;
    newScrollView.showsVerticalScrollIndicator = NO;
    [bestnew addSubview:newScrollView];
    
    NSString *newStr = @"";
    for (int i = 0; i < bestNewArr.count; i++) {
        NSDictionary *dic = bestNewArr[i];
        NSString *phoneto =[dic[@"phone"] substringToIndex:3];
        NSString *phoneFrom = [dic[@"phone"] substringFromIndex:7];
        NSString *phone = [NSString stringWithFormat:@"%@****%@",phoneto,phoneFrom];
        NSString *str = [NSString stringWithFormat:@"   %@ 购买了VIP直播课程有效期 %@ 天  ",phone,dic[@"days"]];
        newStr = [NSString stringWithFormat:@" %@%@",newStr,str];
    }
    
    UILabel *label = [[UILabel alloc]init];
    label.text= newStr;
    label.textColor = TextNoColor;
    label.font = FONT(13);
    CGFloat W = [UILabel getWidthWithTitle:newStr font:label.font];
    label.frame = CGRectMake(0, 0, W, bestnew.height);
//
//    for (int t = 0; t < bestNewArr.count; t++) {
//        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:newStr];
//        NSRange range1 = [[str string] rangeOfString:@"购买了VIP直播课程有效期"];
//        [str addAttribute:NSForegroundColorAttributeName value:TextNoColor range:range1];
//        NSRange range2 = [[str string] rangeOfString:@"天"];
//        [str addAttribute:NSForegroundColorAttributeName value:TextNoColor range:range2];
//        label.attributedText = str;
//    }

    [newScrollView addSubview:label];

    
    rang  = W - newScrollView.width;
    NSLog(@"%f",rang);
    newScrollView.contentSize = CGSizeMake(W,0);

    if (rang > 0) {
        TimesCountD = 0;
        timer = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(timerLoop) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    }

    UIButton *arrowimg = [[UIButton alloc]initWithFrame:CGRectMake(kW-50*SW, 0*SW, 40*SW, 35*SW)];
    [arrowimg setImage:[UIImage imageNamed:@"image33_"] forState:UIControlStateNormal];
    [bestnew addSubview:arrowimg];
    
    UIButton * gobtn = [[UIButton alloc]initWithFrame:bestnew.bounds];
    [gobtn addTarget:self action:@selector(arrowAction) forControlEvents:UIControlEventTouchUpInside];
    [bestnew addSubview:gobtn];
}
-(void)arrowAction{
//    InfoMationInfoViewController *vc = [[InfoMationInfoViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//    [self.navigationController setNavigationBarHidden:NO];
}

//直播推荐
-(void)getliveview{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 225*SW, kW, 180*SW)];
    view.backgroundColor = [UIColor whiteColor];
    [scrollview addSubview:view];
    
    UILabel *livelb = [[UILabel alloc]initWithFrame:CGRectMake(10.5*SW, 10,100, 22.5*SW)];
    livelb.font = BOLDFONT(22.5);
    livelb.text = @"直播推荐";
    [view addSubview:livelb];

    
    UIView *liveview1 = [[UIView alloc]initWithFrame:CGRectMake(15*SW, 42.5*SW, kW/2-15-4.5*SW, view.height-42.5*SW)];
    liveview1.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    [view addSubview:liveview1];
    
    UIView *liveview2 = [[UIView alloc]initWithFrame:CGRectMake(kW/2+4.5, 42.5*SW, kW/2-15-4.5*SW, view.height-42.5*SW)];
    liveview2.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    [view addSubview:liveview2];
    
    UIImageView *liveimg1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, liveview1.width, 107.5*SW)];
    NSURL *url = [NSURL URLWithString:[datatopdic1 objectForKey:@"left"]];
    [liveimg1 sd_setImageWithURL:url];
    [liveview1 addSubview:liveimg1];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(liveview1.width/2-30*SW, liveimg1.height/2 - 30*SW, 60*SW, 60*SW)];
    [btn setImage:[UIImage imageNamed:@"首页_38"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(freeAction) forControlEvents:UIControlEventTouchUpInside];
    [liveview1 addSubview:btn];
    
    UIImageView *liveimg2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, liveview1.width, 107.5*SW)];
    NSURL *url1 = [NSURL URLWithString:[datatopdic1 objectForKey:@"right"]];
    [liveimg2 sd_setImageWithURL:url1];
    [liveview2 addSubview:liveimg2];
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(liveview2.width/2-30*SW, liveimg2.height/2 - 30*SW, 60*SW, 60*SW)];
    [btn1 setImage:[UIImage imageNamed:@"首页_38"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(VipAction) forControlEvents:UIControlEventTouchUpInside];

    [liveview2 addSubview:btn1];
    
    UIView *btnview1 = [[UIView alloc]initWithFrame:CGRectMake(20*SW, liveimg1.maxY+5, liveview1.width-40*SW, 20*SW)];
    btnview1.layer.cornerRadius = 2;
    btnview1.layer.masksToBounds = YES;
    btnview1.backgroundColor = NavAndBtnColor;
    [liveview1 addSubview:btnview1];
    
    UILabel *freelabel1 = [[UILabel alloc]initWithFrame:CGRectMake(20*SW, 0, 90*SW, 20*SW)];
    freelabel1.textColor = [UIColor whiteColor];
    freelabel1.text = @"免费直播";
    freelabel1.font = BOLDFONT(16);
    [btnview1 addSubview:freelabel1];
    
    UIImageView *img1 = [[UIImageView alloc]initWithFrame:CGRectMake(95*SW, 5*SW, 30*SW, 10*SW)];
    img1.image = [UIImage imageNamed:@"首页_42"];
    [btnview1 addSubview:img1];
    
    UIView *btnview2 = [[UIView alloc]initWithFrame:CGRectMake(20*SW, liveimg1.maxY+5, liveview1.width-40*SW, 20*SW)];
    btnview2.layer.cornerRadius = 2;
    btnview2.layer.masksToBounds = YES;
    btnview2.backgroundColor = NavAndBtnColor;
    [liveview2 addSubview:btnview2];
    
    UILabel *freelabel2 = [[UILabel alloc]initWithFrame:CGRectMake(10*SW, 0, 100*SW, 20*SW)];
    freelabel2.textColor = [UIColor whiteColor];
    freelabel2.text = @"VIP实战直播";
    freelabel2.font = BOLDFONT(16);
    [btnview2 addSubview:freelabel2];
    
    UIImageView *img2 = [[UIImageView alloc]initWithFrame:CGRectMake(105*SW, 5*SW, 30*SW, 10*SW)];
    img2.image = [UIImage imageNamed:@"首页_42"];
    [btnview2 addSubview:img2];
    
    UIButton *freebtn = [[UIButton alloc]initWithFrame:btnview1.bounds];
    [freebtn addTarget:self action:@selector(freeAction) forControlEvents:UIControlEventTouchUpInside];
    [btnview1 addSubview:freebtn];
    
    UIButton *VIPbtn = [[UIButton alloc]initWithFrame:btnview2.bounds];
    [VIPbtn addTarget:self action:@selector(VipAction) forControlEvents:UIControlEventTouchUpInside];
    [btnview2 addSubview:VIPbtn];
    

}

//名师推荐
-(void)mastercommend{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 405*SW, kW, 152.5*SW)];
    view.backgroundColor = [UIColor whiteColor];
    [scrollview addSubview:view];
    
    UILabel *livelb = [[UILabel alloc]initWithFrame:CGRectMake(10.5*SW, 10,100, 22.5*SW)];
    livelb.font = BOLDFONT(20);
    livelb.text = @"名师推荐";
    [view addSubview:livelb];
    
    UIImageView *arrowimg = [[UIImageView alloc]initWithFrame:CGRectMake(kW-41*SW, 13.5*SW, 8*SW, 15*SW)];
    arrowimg.image = [UIImage imageNamed:@"首页_34"];
    [view addSubview:arrowimg];
    
    UIButton *btnmore = [[UIButton alloc]initWithFrame:CGRectMake(kW-41*SW-50*SW, 0, 50*SW, 42.5*SW)];
    [btnmore setTitle:@"更多" forState:UIControlStateNormal];
    [btnmore setTitleColor:TextNoColor forState:UIControlStateNormal];
    btnmore.titleLabel.font = FONT(15);
    btnmore.titleLabel.textAlignment = 2;
    btnmore.tag = 11111+1;
    [btnmore addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnmore];
    
    UIScrollView *masterscv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 42.5*SW, kW, 100*SW)];
    [view addSubview:masterscv];
    
    NSInteger count = teacherArr.count;
    for (int i  = 0; i < count; i++) {
        NSDictionary *dic = teacherArr[i];
        UIImageView *showview = [[UIImageView alloc]initWithFrame:CGRectMake(15*SW + (250+30)*SW*i, 0, 250*SW, 100*SW)];
        NSString *imgstr = [dic objectForKey:@"teacherurl"];
        NSURL *url = [NSURL URLWithString:imgstr];
        [showview sd_setImageWithURL:url];
        [masterscv addSubview:showview];
        
        UIButton *btn  = [[UIButton alloc]initWithFrame:showview.frame];
        btn.tag = i;
        [btn addTarget:self action:@selector(teacherAction:) forControlEvents:UIControlEventTouchUpInside];
        [masterscv addSubview:btn];
    }
    masterscv.contentSize = CGSizeMake(30*SW*count + 250*SW*count, 0);
}
-(void)teacherAction:(UIButton *)sender{
    NSLog(@"teacher - ,btntag%ld",sender.tag);
    NSDictionary *dic = teacherArr[sender.tag];

    TeacherInfoViewController *vc = [[TeacherInfoViewController alloc]init];
    vc.Id = [dic objectForKey:@"userid"];
    [self.navigationController pushViewController:vc animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


//免费课程
-(void)freecourse{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 567.5*SW, kW, 200*SW)];
    view.backgroundColor = [UIColor whiteColor];
    [scrollview addSubview:view];
    
    UILabel *livelb = [[UILabel alloc]initWithFrame:CGRectMake(10.5*SW, 10,100, 22.5*SW)];
    livelb.font = BOLDFONT(20);
    livelb.text = @"免费课程";
    [view addSubview:livelb];
    
    UIImageView *arrowimg = [[UIImageView alloc]initWithFrame:CGRectMake(kW-41*SW, 13.5*SW, 8*SW, 15*SW)];
    arrowimg.image = [UIImage imageNamed:@"首页_34"];
    [view addSubview:arrowimg];
    
    UIButton *btnmore = [[UIButton alloc]initWithFrame:CGRectMake(kW-41*SW-50*SW, 0, 50*SW, 42.5*SW)];
    btnmore.tag = 11111+2;

    [btnmore addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];

    [btnmore setTitle:@"更多" forState:UIControlStateNormal];
    [btnmore setTitleColor:TextNoColor forState:UIControlStateNormal];
    btnmore.titleLabel.font = FONT(15);
    btnmore.titleLabel.textAlignment = 2;
    [view addSubview:btnmore];
    
    UIScrollView *freescv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 42.5*SW, kW, 150*SW)];
    [view addSubview:freescv];
    
//    NSArray *imgarr = @[@"首页-5",@"首页-6",@"首页-5"];
    NSInteger count = FreeArr.count;
    for (int i  = 0; i < count; i++) {
        UIView *freeview = [[UIView alloc]initWithFrame:CGRectMake(15*SW + (200+30)*SW*i, 0, 200*SW, 150*SW)];
        [freescv addSubview:freeview];
        
        NSDictionary *dic = FreeArr[i];
        
        UIImageView *showview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, freeview.width, 100*SW)];
        NSString *imgstr = [dic objectForKey:@"coursepic"];
        NSURL *url = [NSURL URLWithString:imgstr];
        [showview sd_setImageWithURL:url];
        [freeview addSubview:showview];

        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 100*SW, freeview.width, 25*SW)];
        label.text = [dic objectForKey:@"coursename"];
        label.font = FONT(17);
        label.textColor = TextNoColor;
        [freeview addSubview:label];
        
        UIImageView * imgv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 130*SW, 10*SW, 10*SW)];
        imgv.image = [UIImage imageNamed:@"6_"];
        [freeview addSubview:imgv];
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(20*SW, 125*SW, freeview.width/3*2, 20*SW)];
        label1.font = FONT(13);
        label1.textColor = TextNoColor;
        NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"已有%ld人学习",[[dic objectForKey:@"study_count"] integerValue]]];
        //获取要调整颜色的文字位置,调整颜色
        NSRange range1=[[hintString string]rangeOfString:@"已有人学习"];
        [hintString addAttribute:NSForegroundColorAttributeName value:TextNoColor range:range1];
        
        NSRange range2=[[hintString string]rangeOfString:[NSString stringWithFormat:@"%ld",[[dic objectForKey:@"study_count"]integerValue]]];
        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range2];
        
        label1.attributedText=hintString;
        [freeview addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(freeview.width-40*SW, 125*SW, 40*SW, 20*SW)];
        label2.text = @"免费";
        label2.font = FONT(15);
        label2.textColor = [UIColor redColor];
        [freeview addSubview:label2];
        
        UIButton *btn  = [[UIButton alloc]initWithFrame:showview.frame];
        btn.tag = i;
        [btn addTarget:self action:@selector(FreebtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [freeview addSubview:btn];
    }
    freescv.contentSize = CGSizeMake(30*SW*count + 200*SW*count, 0);
}

-(void)FreebtnAction:(UIButton *)sender{
    NSLog(@"free - ,btntag%ld",sender.tag);
    NSDictionary *dic = FreeArr[sender.tag];

    ClassInfoViewController* civc = [[ClassInfoViewController alloc]init];
    
    civc.courseId = [dic objectForKey:@"courseid"];
    
    [self.navigationController pushViewController:civc animated:YES];
}

//付费课程
-(void)chargingcourse{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 777.5*SW, kW, 170*SW)];
    view.backgroundColor = [UIColor whiteColor];
    [scrollview addSubview:view];
    
    UILabel *livelb = [[UILabel alloc]initWithFrame:CGRectMake(10.5*SW, 10,100, 22.5*SW)];
    livelb.font = BOLDFONT(20);
    livelb.text = @"付费课程";
    [view addSubview:livelb];
    
    UIImageView *arrowimg = [[UIImageView alloc]initWithFrame:CGRectMake(kW-41*SW, 13.5*SW, 8*SW, 15*SW)];
    arrowimg.image = [UIImage imageNamed:@"首页_34"];
    [view addSubview:arrowimg];
    
    UIButton *btnmore = [[UIButton alloc]initWithFrame:CGRectMake(kW-41*SW-50*SW, 0, 50*SW, 42.5*SW)];
    btnmore.tag = 11111+3;
    
    [btnmore addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnmore setTitle:@"更多" forState:UIControlStateNormal];
    [btnmore setTitleColor:TextNoColor forState:UIControlStateNormal];
    btnmore.titleLabel.font = FONT(15);
    btnmore.titleLabel.textAlignment = 2;
    [view addSubview:btnmore];
    
    UIScrollView *coursescv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50*SW, kW, 100*SW)];
    [view addSubview:coursescv];
    
//    NSArray *imgarr = @[@"首页-7",@"首页-8",@"首页-7"];
    NSInteger count = payArr.count;
    for (int i  = 0; i < count; i++) {
        
        NSDictionary *dic = payArr[i];

        UIView *courseview = [[UIView alloc]initWithFrame:CGRectMake(15*SW + (290+30)*SW*i, 0, 300*SW, 100*SW)];
        [coursescv addSubview:courseview];
        
        UIImageView *showview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 160*SW, 100*SW)];
        NSString *imgstr = [dic objectForKey:@"coursepic"];
        NSURL *url = [NSURL URLWithString:imgstr];
        [showview sd_setImageWithURL:url];
        [courseview addSubview:showview];
        
        UIButton *btn  = [[UIButton alloc]initWithFrame:showview.frame];
        btn.tag = i;
        [btn addTarget:self action:@selector(paybtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [courseview addSubview:btn];
        
        UILabel *titlelb = [[UILabel alloc]initWithFrame:CGRectMake(165*SW, 0, courseview.width - 155*SW, 25*SW)];
        titlelb.text = [dic objectForKey:@"coursename"];
        titlelb.textColor = TextNoColor;
        [courseview addSubview:titlelb];
        
        UILabel *titlelb1 = [[UILabel alloc]initWithFrame:CGRectMake(165*SW, 25*SW, courseview.width - 155*SW, 25*SW)];
        titlelb1.text = @"财经学习";
        titlelb1.font = FONT(15);
        titlelb1.textColor = TextNoColor;
        [courseview addSubview:titlelb1];
        
        UIImageView * imgv = [[UIImageView alloc]initWithFrame:CGRectMake(165*SW, 57*SW, 10*SW, 10*SW)];
        imgv.image = [UIImage imageNamed:@"6_"];
        [courseview addSubview:imgv];
        
        UILabel *titlelb2 = [[UILabel alloc]initWithFrame:CGRectMake(180*SW, 50*SW, courseview.width - 155*SW, 25*SW)];
        NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"已有%@人学习",[dic objectForKey:@"study_count"]]];
        //获取要调整颜色的文字位置,调整颜色
        NSRange range1=[[hintString string]rangeOfString:@"已有人学习"];
        [hintString addAttribute:NSForegroundColorAttributeName value:TextNoColor range:range1];
        
        NSRange range2=[[hintString string]rangeOfString:[NSString stringWithFormat:@"%ld",[[dic objectForKey:@"study_count"] integerValue]]];
        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range2];
        
        titlelb2.attributedText=hintString;
        titlelb2.font = FONT(13);
        [courseview addSubview:titlelb2];
        
        UILabel *titlelb3 = [[UILabel alloc]initWithFrame:CGRectMake(165*SW, 75*SW, courseview.width - 155*SW, 25*SW)];
        titlelb3.font = FONT(17);
        if ([ConventionJudge isNotNULL:[dic objectForKey:@"coursemoney"]]) {
            titlelb3.text = [NSString stringWithFormat:@"￥%.1f",[[dic objectForKey:@"coursemoney"]doubleValue]];
        }
        
        titlelb3.textColor = [UIColor redColor];
        [courseview addSubview:titlelb3];
    }
    coursescv.contentSize = CGSizeMake(30*SW*count + 290*SW*count, 0);
}

-(void)paybtnAction:(UIButton *)sender{
    NSLog(@"pay - ,btntag%ld",sender.tag);
    NSDictionary *dic = payArr[sender.tag];

    ClassInfoViewController* civc = [[ClassInfoViewController alloc]init];

    civc.courseId = [dic objectForKey:@"courseid"];
    
    [self.navigationController pushViewController:civc animated:YES];
}
//资讯文章
-(void)actciles{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 957.5*SW, kW, 210*SW)];
    view.backgroundColor = [UIColor whiteColor];
    [scrollview addSubview:view];
    
    UILabel *livelb = [[UILabel alloc]initWithFrame:CGRectMake(10.5*SW, 10,100, 22.5*SW)];
    livelb.font = BOLDFONT(20);
    livelb.text = @"资讯文章";
    [view addSubview:livelb];
    
    UIImageView *arrowimg = [[UIImageView alloc]initWithFrame:CGRectMake(kW-41*SW, 13.5*SW, 8*SW, 15*SW)];
    arrowimg.image = [UIImage imageNamed:@"首页_34"];
    [view addSubview:arrowimg];
    
    UIButton *btnmore = [[UIButton alloc]initWithFrame:CGRectMake(kW-41*SW-50*SW, 0, 50*SW, 42.5*SW)];
    btnmore.tag = 11111+4;
    
    [btnmore addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnmore setTitle:@"更多" forState:UIControlStateNormal];
    [btnmore setTitleColor:TextNoColor forState:UIControlStateNormal];
    btnmore.titleLabel.font = FONT(15);
    btnmore.titleLabel.textAlignment = 2;
    [view addSubview:btnmore];
    
    UIScrollView *freescv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50*SW, kW, 150*SW)];
    [view addSubview:freescv];
    
//    NSArray *imgarr = @[@"首页-9",@"首页-10",@"首页-11"];
    NSInteger count = actcilesArr.count;
    for (int i  = 0; i < count; i++) {
        NSDictionary *dic = actcilesArr[i];
        
        UIView *freeview = [[UIView alloc]initWithFrame:CGRectMake(15*SW + (140+20)*SW*i, 0, 140*SW, 160*SW)];
        [freescv addSubview:freeview];
        
        UIImageView *showview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, freeview.width, 80*SW)];
        NSString *imgstr = [dic objectForKey:@"picurl"];
        NSURL *url = [NSURL URLWithString:imgstr];
        [showview sd_setImageWithURL:url];
        [freeview addSubview:showview];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 80*SW, freeview.width, 45*SW)];
        label.text = [dic objectForKey:@"infomationtitle"];
        label.font = FONT(17);
        label.textColor = TextNoColor;
        //设置多行
        [label setNumberOfLines:0];
        //设置剪切模式
        label.lineBreakMode = NSLineBreakByWordWrapping;
        //使用系统
        UIFont* font = FONT(13);
        //有导入其他字体时可用这个 UIFont *font = [UIFont fontWithName:@"Arial" size:15];
        label.font = font;
        //设置lable的最大尺寸
        CGSize constraint =CGSizeMake(freeview.width,50*SW);
        //该方法iOS7.0以后已更新
        CGSize size = [label.text sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        //其实UILineBreakModeWordWrap和NSLineBreakByWordWrapping是一个意思
        //根据文字重设label的宽高，x y随意
        [label setFrame:CGRectMake(0, 80*SW, size.width, size.height)];
        [freeview addSubview:label];
        
        
        UIImageView * imgv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 130*SW, 15*SW, 10*SW)];
        imgv.image = [UIImage imageNamed:@"首页_50"];
        [freeview addSubview:imgv];
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(20*SW, 125*SW, 50*SW, 20*SW)];
        label1.text = [NSString stringWithFormat:@"%ld",[[dic objectForKey:@"readcounts"]integerValue]];
        label1.font = FONT(13);
        label1.textColor = TextNoColor;
        [freeview addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(freeview.width - 70*SW, 125*SW, 70*SW, 20*SW)];
        label2.text = [dic objectForKey:@"createtime"];
        label2.font = FONT(11);
        [freeview addSubview:label2];
        
        UIButton *btn  = [[UIButton alloc]initWithFrame:freeview.bounds];
        btn.tag =23 + i;
        [btn addTarget:self action:@selector(InfoAction:) forControlEvents:UIControlEventTouchUpInside];
        [freeview addSubview:btn];
        
    }
    freescv.contentSize = CGSizeMake(15*SW+20*SW*count + 140*SW*count, 0);
    scrollview.contentSize = CGSizeMake(0,view.maxY + 5*SW);
    
}

-(void)InfoAction:(UIButton *)sender{
    NSDictionary *dic = actcilesArr[sender.tag - 23];
    InfoMationInfoViewController *vc = [[InfoMationInfoViewController alloc]init];
    vc.Id = [dic objectForKey:@"id"];
    [self.navigationController pushViewController:vc animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


//点击了免费直播按钮
-(void)freeAction{
    NSLog(@"免费直播按钮");
    UINavigationController *temp = (UINavigationController *)[super.tabBarController.viewControllers objectAtIndex:1];
    LivePageViewController *tempShua = (LivePageViewController *)temp.topViewController;        tempShua.type = @"2";
    [self.tabBarController setSelectedIndex:1];
    
}

//点击了VIP实战直播
-(void)VipAction{
    NSLog(@"VIP实战直播按钮");
    UINavigationController *temp = (UINavigationController *)[super.tabBarController.viewControllers objectAtIndex:1];
    LivePageViewController *tempShua = (LivePageViewController *)temp.topViewController;        tempShua.type = @"1";
    [self.tabBarController setSelectedIndex:1];
    
}

- (IBAction)leftbtn:(id)sender {
}

- (IBAction)reighibtn:(id)sender {
    PlanViewController *vc = [[PlanViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    [self.navigationController setNavigationBarHidden:NO];

}


//点击更多
-(void)moreAction:(UIButton *)sender{
    if (sender.tag -11111 == 1) {
        TeacherViewController *vc = [[TeacherViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        [self.navigationController setNavigationBarHidden:NO];
    }else if (sender.tag -11111 == 2) {
        [self.tabBarController setSelectedIndex:2];

    }else if (sender.tag -11111 == 3) {
        [self.tabBarController setSelectedIndex:2];
        
    }else if (sender.tag -11111 == 4) {
        [self.tabBarController setSelectedIndex:3];
        
    }
}

-(void)btnAction:(UIButton *)sender{
    if (sender.tag-1234 == 0) {
        UINavigationController *temp = (UINavigationController *)[super.tabBarController.viewControllers objectAtIndex:1];
        LivePageViewController *tempShua = (LivePageViewController *)temp.topViewController;        tempShua.type = @"1";
        [self.tabBarController setSelectedIndex:1];

        
    }else if(sender.tag - 1234 == 1){
        //专家诊股
        FollowViewController *vc = [[FollowViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        [self.navigationController setNavigationBarHidden:NO];
    }else if(sender.tag - 1234 == 2){
        //专家诊股
        DiagnoseViewController *vc = [[DiagnoseViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        [self.navigationController setNavigationBarHidden:NO];
    }else if(sender.tag - 1234 == 3){
        TacticsViewController *vc = [[TacticsViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        [self.navigationController setNavigationBarHidden:NO];
    }
}

-(UIImage *)getnewimage:(UIImage *)image{
    UIImage *image1 = image;
    UIGraphicsBeginImageContext(CGSizeMake(17, 17));
    [image1 drawInRect:CGRectMake(0.0f, 0.0f, 17, 17)];
    image1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image1;
}

-(void)isAllLoad{
    NSInteger count = 0;
    for (int i=0; i<6; i++) {
        ;
        if (load[i] == YES) {
            count++;
        }
    }
    if (count == 6) {
        SVDismiss;
    }
}

//顶部广告页点击方法
- (void)cycleScrollView:(GCCycleScrollView*)cycleScrollView didSelectItemAtRow:(NSInteger)row{
    NSLog(@"%ld",row);
    NSDictionary *dic = Adarr[row];
    NSInteger link = [dic[@"link"] integerValue];
    if (link == 1) {
        NSString *imgurl = dic[@"content"];
        AdJumpViewController *vc = [[AdJumpViewController alloc] init];
        vc.type = @"1";
        vc.url = imgurl;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSString *imgurl = dic[@"content"];
        AdJumpViewController *vc = [[AdJumpViewController alloc] init];
        vc.type = @"0";
        vc.url = imgurl;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark -- scrollViewDeleget
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == newScrollView) {
        if (scrollView.contentOffset.x >= rang) {
            TimesCountD = 0;
        }
    }
}

-(void)timerLoop{
    TimesCountD += 0.2;
    CGPoint offset = CGPointMake(TimesCountD, 0);
    // 0乘以当前scrollView的contentOffset的x即为第一页
    // 1乘以当前scrollView的contentOffset的x即为第二页
    // ...
    // contentOffset的Y不变
    [newScrollView setContentOffset:offset animated:NO];
}

- (void)changeLabel:(UILabel *)label withTextColor:(UIColor *)color {
    NSString *labelStr = label.text; //初始化string为传入label.text的值
    NSCharacterSet *nonDigits = [[NSCharacterSet decimalDigitCharacterSet]invertedSet];//创建一个字符串过滤参数,decimalDigitCharacterSet为过滤小数,过滤某个关键词,只需改变 decimalDigitCharacterSet类型  在将此方法增加一个 NSString参数即可
    NSInteger remainSeconde = [[labelStr stringByTrimmingCharactersInSet:nonDigits]intValue];//获取过滤出来的数值
    NSString *stringRange = [NSString stringWithFormat:@"%ld",(long)remainSeconde];//将过滤出来的Integer的值转换成String
    NSRange range = [labelStr rangeOfString:stringRange];//获取过滤出来的数值的位置
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:label.text];//创建一个带属性的string
    [attrStr addAttribute:NSForegroundColorAttributeName value:color range:range];//给带属性的string添加属性,attrubute:添加的属性类型（颜色\文字大小\字体等等）,value:改变成的属性参数,range:更改的位置
    label.attributedText = attrStr;//将 attstr 赋值给label带属性的文本框属性
}
@end
