
//
//  LivePageViewController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/1/15.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "LivePageViewController.h"
#import "ForlbViewController.h"
#import "BuyVipViewController.h"
#import "NowTableViewCell.h"
#import "DredgeVipViewController.h"
#import "FreeLiveViewController.h"
#import "HomePageViewController.h"
#import "SeverChatViewController.h"
#import <MJRefresh.h>
#import "ClassCollectionViewCell.h"
#import "ClassInfoViewController.h"
#import "LiveAncientlyViewControllerViewController.h"
@interface LivePageViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(strong,nonatomic)UICollectionView *collectionview;
@property(strong,nonatomic)UICollectionView *collectionview2;

@end

@implementation LivePageViewController
{
    UIView *bottonln;
    UIScrollView *scrollview;
    UIButton *forbtn;
    UIButton *nowbtn;
    UIScrollView *scro2;
    NSMutableArray *btnarr;
    UIButton *_btn2;
    UIButton *severbtn;
    NSDictionary *datatopdic1;
    NSDictionary *datatopdic2;
    NSMutableArray*courseArr;
    NSInteger page1;
    NSInteger totalpage1;
    NSMutableArray*courseArr2;
    NSInteger page2;
    NSInteger totalpage2;
    UITableView *tableview;
    NSMutableArray *datearr;
    NSArray *weakdataarr;
    UIView *menbanview;
    UITextField *psdtextf;
    UIView *affrimview;
    
    NSString *pwd1;
    NSString *pwd2;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    if ([self.type integerValue]==1) {
        UIButton *btn = [[UIButton alloc]init];
        btn.tag = 698 +1;
        [self pageAction:btn];
    }else{
        UIButton *btn = [[UIButton alloc]init];
        btn.tag = 698 +2;
        [self pageAction:btn];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ALLViewBgColor;
    [self getnav];
    pwd1 = @"";
    pwd2 = @"";
    
    // Do any additional setup after loading the view.
}

-(void)loadtopLive:(NSString *)type{
    [YJAPPNetwork LivecourselivingWithType:type success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            if ([type integerValue]== 1) {
                datatopdic1 = [responseObject objectForKey:@"data"];
                [self getleftview];
                [self loadtopLive:@"2"];

            }else{
                datatopdic2 = [responseObject objectForKey:@"data"];
                [self getrightview];
                SVDismiss;
            }
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
    }];
}

-(void)loadTeapastlivecourse{
    page1 = 1;
    NSString *pagestr = [NSString stringWithFormat:@"%ld",page1];
    [YJAPPNetwork LiveCourseListProgramWithType:@"1" page:pagestr success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            courseArr = [NSMutableArray array];
            courseArr = [dic objectForKey:@"courselist"];
            totalpage1 = [[dic objectForKey:@"totalpage"] integerValue];
            if (totalpage1>1) {
                _collectionview.mj_footer.hidden = NO;
            }
            [self.collectionview reloadData];
            SVDismiss;
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
        [_collectionview.mj_header endRefreshing];
        
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
        [_collectionview.mj_header endRefreshing];
        
    }];
}

-(void)loadMoredata1{
    
    if (totalpage1 == 0||page1 == totalpage1) {
        [_collectionview.mj_footer setState:MJRefreshStateNoMoreData];
        return;
    }else{
        page1++;
    }
    NSString *pagestr = [NSString stringWithFormat:@"%ld",page1];
    
    [YJAPPNetwork LiveCourseListProgramWithType:@"1" page:pagestr success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            NSArray *arr = [dic objectForKey:@"courselist"];
            
            [courseArr addObjectsFromArray:arr];
            [_collectionview reloadData];
            SVDismiss;
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
        [_collectionview.mj_footer endRefreshing];
        
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
        [_collectionview.mj_footer endRefreshing];
    }];
}

-(void)loadTeapastlivecourse1{
    page2 = 1;
    NSString *pagestr = [NSString stringWithFormat:@"%ld",page2];
    [YJAPPNetwork LiveCourseListProgramWithType:@"2" page:pagestr success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            courseArr2 = [NSMutableArray array];
            courseArr2 = [dic objectForKey:@"courselist"];
            totalpage2 = [[dic objectForKey:@"totalpage"] integerValue];
            if (totalpage2>1) {
                _collectionview2.mj_footer.hidden = NO;
            }
            [self.collectionview2 reloadData];
            SVDismiss;
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
        [_collectionview2.mj_header endRefreshing];
        
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
        [_collectionview2.mj_header endRefreshing];
        
    }];
}

-(void)loadWeakdataWithdate:(NSString *)date{
    [YJAPPNetwork getWeakdateWithType:@"1" date:date success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            weakdataarr = [NSArray array];
            weakdataarr = [responseObject objectForKey:@"data"];
            [tableview reloadData];
            SVDismiss;
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
        
    }];
}

-(void)loadMoredata2{
    
    if (totalpage2 == 0||page2 == totalpage2) {
        [_collectionview2.mj_footer setState:MJRefreshStateNoMoreData];
        return;
    }else{
        page2++;
    }
    NSString *pagestr = [NSString stringWithFormat:@"%ld",page2];
    
    [YJAPPNetwork LiveCourseListProgramWithType:@"2" page:pagestr success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            NSArray *arr = [dic objectForKey:@"courselist"];
            
            [courseArr2 addObjectsFromArray:arr];
            [_collectionview2 reloadData];
            SVDismiss;
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
        [_collectionview2.mj_footer endRefreshing];
        
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
        [_collectionview2.mj_footer endRefreshing];
    }];
}


-(void)getnav{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kW, SafeAreaTopHeight)];
    view.backgroundColor = NavAndBtnColor;
    [self.view addSubview:view];
    
    NSInteger btny = 25.5+SafeAreaTopHeight - 64;

    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(kW/2-110*SW, btny, 100*SW, 25)];
    [btn1 setTitle:@"免费直播" forState:UIControlStateNormal];
    btn1.titleLabel.font = FONT(15);
    [btn1 setTitleColor:WColor forState:UIControlStateNormal];
    btn1.tag = 400;
    [btn1 addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(kW/2+10*SW, btny, 100*SW, 25)];
    [btn2 setTitle:@"VIP实战直播" forState:UIControlStateNormal];
    btn2.titleLabel.font = FONT(15);
    [btn2 setTitleColor:WColor forState:UIControlStateNormal];
    btn2.tag = 400+1;
    [btn2 addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn2];
    
    severbtn = [[UIButton alloc]initWithFrame:CGRectMake(kW - 45, btny, 25, 32)];
    severbtn.hidden = YES;
    [severbtn addTarget:self action:@selector(severAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:severbtn];
    
    UIImageView *img= [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, severbtn.width, 20)];
    [img setImage:[UIImage imageNamed:@"4_"]];
    [severbtn addSubview:img];
    
    UILabel *label113= [[UILabel alloc]initWithFrame:CGRectMake(0, img.maxY +2, severbtn.width, 10)];
    label113.text = @"客服";
    label113.font = [UIFont systemFontOfSize:11];
    label113.textColor = CWHITE;
    label113.textAlignment = 1;
    [severbtn addSubview:label113];
    
    bottonln = [[UIView alloc]initWithFrame:CGRectMake(btn1.maxX - btn1.width/2 - 75/2, btn1.maxY+6.5, 75, 2.5)];
    bottonln.backgroundColor = WColor;
    [view addSubview:bottonln];

    scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, kW, self.view.height-SafeAreaTopHeight-44)];
    scrollview.contentSize = CGSizeMake(kW*2, 0);
    scrollview.pagingEnabled = YES;
    scrollview.delegate = self;
    [scrollview setShowsHorizontalScrollIndicator:NO];
    scrollview.bounces = NO;
    [self.view addSubview:scrollview];


    
    [self loadtopLive:@"1"];

}
-(void)severAction{
    SeverChatViewController *vc = [[SeverChatViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)pageAction:(UIButton *)btn{
    if (btn.tag - 400 == 1) {
        severbtn.hidden = YES;//暂时隐藏
        [UIView animateWithDuration:0.5 animations:^{
            scrollview.contentOffset = CGPointMake(kW, 0);
            bottonln.transform = CGAffineTransformMakeTranslation(100*SW+20*SW, 0);
        }];
        
    }else{
        severbtn.hidden = YES;
        [UIView animateWithDuration:0.5 animations:^{
            scrollview.contentOffset = CGPointMake(0, 0);
            bottonln.transform = CGAffineTransformIdentity;
        }];
        
    }
    if (btn.tag -698 == 1) {
        severbtn.hidden = YES;//暂时隐藏
        [UIView animateWithDuration:0.5 animations:^{
            scrollview.contentOffset = CGPointMake(kW, 0);
            bottonln.transform = CGAffineTransformMakeTranslation(100*SW+20*SW, 0);
        }];
//        self.type = @"0";
    }else if (btn.tag -698 == 2){
        severbtn.hidden = YES;
        [UIView animateWithDuration:0.5 animations:^{
            scrollview.contentOffset = CGPointMake(0, 0);
            bottonln.transform = CGAffineTransformIdentity;
        }];
    }
}

-(void)changevalue{
    
}

-(void)getleftview{
    UIView *leftview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, scrollview.frame.size.width, scrollview.frame.size.height)];
    leftview.backgroundColor = CWHITE;
    [scrollview addSubview:leftview];
    
    UIImageView *liveimgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kW, 180*SW)];
    NSURL *url = [NSURL URLWithString:[datatopdic1 objectForKey:@"coursepic"]];
    [liveimgview sd_setImageWithURL:url];
    [leftview addSubview:liveimgview];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(liveimgview.width/2-30*SW,liveimgview.height/2 - 30*SW, 60*SW, 60*SW)];
    [btn setImage:[UIImage imageNamed:@"首页_38"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(gobtnAction) forControlEvents:UIControlEventTouchUpInside];
    btn.hidden = YES;
    [leftview addSubview:btn];
    
    UIView *titleview = [[UIView alloc]initWithFrame:CGRectMake(0, liveimgview.maxY, kW, 52*SW)];
    titleview.backgroundColor = [UIColor whiteColor];
    [leftview addSubview:titleview];
    
    UIView *ln = [[UIView alloc]initWithFrame:CGRectMake(0, 52*SW-0.5, kW, 0.5)];
    ln.backgroundColor = LnColor;

    [titleview addSubview:ln];
    
    UILabel *titlelb = [[UILabel alloc]initWithFrame:CGRectMake(15*SW, 8*SW, kW/2, 15*SW)];
    titlelb.font = FONT(13);
    [titleview addSubview:titlelb];
    
    UILabel *titlelb2 = [[UILabel alloc]initWithFrame:CGRectMake(15*SW, 27*SW, kW/2, 15*SW)];
    titlelb2.font = FONT(13);
    [titleview addSubview:titlelb2];
    
    UIButton *gobtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gobtn.frame = CGRectMake(kW-231/2*SW, 11*SW,100*SW, 30*SW);
    gobtn.backgroundColor = NavAndBtnColor;
    gobtn.layer.cornerRadius = 3;
    gobtn.layer.masksToBounds = YES;
    gobtn.titleLabel.font = FONT(15);
    gobtn.hidden = YES;
    [gobtn setTitle:@"进入直播室" forState:UIControlStateNormal];
    [gobtn setTitleColor:WColor forState:UIControlStateNormal];
    [gobtn addTarget:self action:@selector(gobtnAction) forControlEvents:UIControlEventTouchUpInside];
    [titleview addSubview:gobtn];
    
    if ([ConventionJudge isNotNULL:[datatopdic1 objectForKey:@"courseid"]]) {
        titlelb.text =[NSString stringWithFormat:@"%@ - %@ %@",[datatopdic1 objectForKey:@"starttime"],[datatopdic1 objectForKey:@"endtime"],[datatopdic1 objectForKey:@"coursename"]];
        titlelb2.text = [NSString stringWithFormat:@"讲师：%@",[datatopdic1 objectForKey:@"realname"]];
        gobtn.hidden = NO;
        btn.hidden = NO;
    }
    
    forbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forbtn.frame = CGRectMake(kW/2 - 5*SW - 95*SW,titleview.maxY + 12.5*SW,95*SW, 30*SW);
    forbtn.titleLabel.font = FONT(15);
    [forbtn setTitle:@"往期免费直播" forState:UIControlStateNormal];
    [forbtn setTitleColor:TextNoColor forState:UIControlStateNormal];
    [forbtn setTitleColor:NavAndBtnColor forState:UIControlStateSelected];
    forbtn.selected = YES;
    [forbtn addTarget:self action:@selector(forbtnAction) forControlEvents:UIControlEventTouchUpInside];
    [leftview addSubview:forbtn];
    
    nowbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nowbtn.frame = CGRectMake(kW/2 + 5*SW,titleview.maxY + 12.5*SW,80*SW, 30*SW);
    nowbtn.titleLabel.font = FONT(15);
    [nowbtn setTitle:@"本周节目单" forState:UIControlStateNormal];
    [nowbtn setTitleColor:TextNoColor forState:UIControlStateNormal];
    [nowbtn setTitleColor:NavAndBtnColor forState:UIControlStateSelected];
    nowbtn.selected = NO;
    [nowbtn addTarget:self action:@selector(nowbtnAction) forControlEvents:UIControlEventTouchUpInside];
    [leftview addSubview:nowbtn];
    
    scro2 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, forbtn.maxY + 15*SW, kW, leftview.height-15*SW-nowbtn.maxY)];
    scro2.contentSize = CGSizeMake(kW*2, 0);
    scro2.pagingEnabled = YES;
    scro2.delegate = self;
    [scro2 setShowsHorizontalScrollIndicator:NO];
    scro2.bounces = NO;
    [leftview addSubview:scro2];
    
    UIScrollView *scro1 = [[UIScrollView alloc]initWithFrame:scro2.bounds];
    [scro2 addSubview:scro1];
    
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0,0, kW, scrollview.height - 49- forbtn.maxY+30*SW)];
    view1.backgroundColor = WColor;
    [scro1 addSubview:view1];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置collectionView滚动方向
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    //    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    //设置headerView的尺寸大小
    //    layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width,100);
    //该方法也可以设置itemSize
    //    layout.itemSize =CGSizeMake(110, 150);
    
    //2.初始化collectionView
    self.collectionview = [[UICollectionView alloc] initWithFrame:view1.bounds collectionViewLayout:layout];
    [view1 addSubview:self.collectionview];
    //4.设置代理
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    self.collectionview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadTeapastlivecourse)];
    [self.collectionview.mj_header beginRefreshing];
    self.collectionview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoredata1)];
    self.collectionview.backgroundColor = [UIColor clearColor];
    
    //3.注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([ClassCollectionViewCell class]) bundle:[NSBundle mainBundle]];
    [self.collectionview registerNib:nib forCellWithReuseIdentifier:@"classcell"];
    [self leftsubview2];
}


-(void)leftsubview2{
    datearr = [NSMutableArray arrayWithArray:[self getCurrentWeeksWithFirstDiff]];
    [datearr removeObjectAtIndex:6];
    [datearr removeObjectAtIndex:0];
    
    [self loadWeakdataWithdate:datearr[0]];

    UIView *subview2 = [[UIView alloc]initWithFrame:CGRectMake(scro2.frame.size.width, 0, scro2.frame.size.width, scro2.frame.size.height)];
    subview2.backgroundColor = ALLViewBgColor;
    [scro2 addSubview:subview2];
    
    NSArray *weekarr = @[@"周一",@"周二",@"周三",@"周四",@"周五",];
    btnarr = [NSMutableArray array];
    for (int i = 0 ; i < 5; i++) {
        UIButton *weekview = [[UIButton alloc]initWithFrame:CGRectMake(kW/5*i, 0, kW/5, 40*SW)];
        weekview.backgroundColor = WColor;
        weekview.tag = 700+i;
        [weekview addTarget:self action:@selector(weekbenAction:) forControlEvents:UIControlEventTouchUpInside];

        [subview2 addSubview:weekview];
    
        
        UIView *ln1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, weekview.width, 0.5)];
        ln1.backgroundColor = LnColor;
        [weekview addSubview:ln1];
        
        UIView *ln2 = [[UIView alloc]initWithFrame:CGRectMake(0, weekview.maxY-0.5, weekview.width, 0.5)];
        ln2.backgroundColor = LnColor;
        [weekview addSubview:ln2];
        
        UILabel *weeklabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5*SW, weekview.width, 15*SW)];
        weeklabel.text = weekarr[i];
        weeklabel.textAlignment = 1;
        weeklabel.font = TextFont;
        [weekview addSubview:weeklabel];
        
        UILabel *datelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, weeklabel.maxY, weekview.width, 15*SW)];
        datelabel.text = [datearr[i] substringFromIndex:5];
        datelabel.textAlignment = 1;
        datelabel.font = TextsmlFont;
        [weekview addSubview:datelabel];
        
        if (i==0) {
            [weekview setBackgroundColor:[UIColor colorWithHexString:@"#8eb0fe"]];
        }

        [btnarr addObject:weekview];

        
    }
    
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 40*SW, kW, scro2.height-40*SW)];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.backgroundColor = ALLViewBgColor;
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectZero];
    tableview.tableFooterView = footerView;
    [subview2 addSubview:tableview];
}

-(void)weekbenAction:(UIButton *)sender{
    NSInteger index = sender.tag - 700;

    for (UIButton *btn in btnarr){
        if (btn.tag - 700 == index) {
            [btn setBackgroundColor:[UIColor colorWithHexString:@"#8eb0fe"]];
        }else{
            [btn setBackgroundColor:[UIColor whiteColor]];

        }
    }
    NSString *date = datearr[index];
    [self loadWeakdataWithdate:date];

//    [self loaddata];
}
-(void)getrightview{
    UIView *rightview = [[UIView alloc]initWithFrame:CGRectMake(scrollview.frame.size.width, 0, scrollview.frame.size.width, scrollview.frame.size.height)];
    rightview.backgroundColor = [UIColor whiteColor];
    [scrollview addSubview:rightview];
    
    
    UIView *scro1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kW, rightview.height)];
    [rightview addSubview:scro1];
    
    UIImageView *liveimgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kW, 180*SW)];
    NSURL *url = [NSURL URLWithString:[datatopdic2 objectForKey:@"coursepic"]];
    [liveimgview sd_setImageWithURL:url];
    liveimgview.backgroundColor = ALLViewBgColor;
    [scro1 addSubview:liveimgview];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(liveimgview.width/2-30*SW,liveimgview.height/2 - 30*SW, 60*SW, 60*SW)];
    [btn setImage:[UIImage imageNamed:@"首页_38"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    [scro1 addSubview:btn];
    

    
    UIView *titleview = [[UIView alloc]initWithFrame:CGRectMake(0, liveimgview.maxY, kW, 160*SW)];
    titleview.backgroundColor = [UIColor whiteColor];
    [scro1 addSubview:titleview];
    
    UIView *ln = [[UIView alloc]initWithFrame:CGRectMake(0, 160*SW-0.5, kW, 0.5)];
    ln.backgroundColor = LnColor;
    
    [titleview addSubview:ln];
    
    UILabel *titlelb = [[UILabel alloc]initWithFrame:CGRectMake(0*SW, 15*SW, kW, 30*SW)];
    titlelb.text = @"VIP实战直播";
    titlelb.textAlignment = 1;
    titlelb.font = FONT(27);
    [titleview addSubview:titlelb];
    
    UILabel *titlelb2 = [[UILabel alloc]initWithFrame:CGRectMake(0*SW,titlelb.maxY+ 15*SW, kW, 15*SW)];
    titlelb2.text = @"优惠活动简写";
    titlelb2.font = FONT(14);
    titlelb2.textAlignment = 1;

    [titleview addSubview:titlelb2];
    
    UIButton *gobtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gobtn.frame = CGRectMake(42.5*SW,titlelb2.maxY + 25*SW,100*SW, 30*SW);
    gobtn.backgroundColor = NavAndBtnColor;
    gobtn.layer.cornerRadius = 3;
    gobtn.layer.masksToBounds = YES;
    gobtn.titleLabel.font = FONT(15);
    [gobtn setTitle:@"了解详情" forState:UIControlStateNormal];
    [gobtn setTitleColor:WColor forState:UIControlStateNormal];
    [gobtn addTarget:self action:@selector(forlbAction) forControlEvents:UIControlEventTouchUpInside];
    [titleview addSubview:gobtn];
    
    
    UIButton *vipbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    vipbtn.frame = CGRectMake(kW - 42.5*SW - 100*SW, titlelb2.maxY + 25*SW,100*SW, 30*SW);
    vipbtn.backgroundColor = NavAndBtnColor;
    vipbtn.layer.cornerRadius = 3;
    vipbtn.layer.masksToBounds = YES;
    vipbtn.titleLabel.font = FONT(15);
    [vipbtn addTarget:self action:@selector(buyvip) forControlEvents:UIControlEventTouchUpInside];

    [vipbtn setTitle:@"开通VIP服务" forState:UIControlStateNormal];
    [vipbtn setTitleColor:WColor forState:UIControlStateNormal];
    [titleview addSubview:vipbtn];
    
    UILabel *forlb = [[UILabel alloc]init];
    forlb.frame = CGRectMake(0,titleview.maxY + 12.5*SW,kW, 30*SW);
    forlb.font = FONT(15);
    forlb.text =@"往期直播课";
    forlb.textAlignment = 1;
    [scro1 addSubview:forlb];
    
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0,forlb.maxY + 15*SW, kW, scrollview.height - forlb.maxY+30*SW-49*SW)];
    view1.backgroundColor = WColor;
    [scro1 addSubview:view1];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置collectionView滚动方向
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];

    
    //2.初始化collectionView
    self.collectionview2 = [[UICollectionView alloc] initWithFrame:view1.bounds collectionViewLayout:layout];
    [view1 addSubview:self.collectionview2];
    //4.设置代理
    self.collectionview2.delegate = self;
    self.collectionview2.dataSource = self;
    self.collectionview2.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadTeapastlivecourse1)];
    [self.collectionview2.mj_header beginRefreshing];
    self.collectionview2.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoredata2)];
    self.collectionview2.backgroundColor = [UIColor clearColor];
    
    //3.注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([ClassCollectionViewCell class]) bundle:[NSBundle mainBundle]];
    [self.collectionview2 registerNib:nib forCellWithReuseIdentifier:@"classcell"];
}

-(void)rightAction{
    NSString *courseid = [datatopdic2 objectForKey:@"courseid"];
    if (courseid.length) {
        [self commitpwd:@"1" pwd:pwd2];
    }else{
        [SVProgressHUD showInfoWithStatus:@"暂无直播"];
    }

}

-(void)gobtnAction{
    NSString *courseid = [datatopdic1 objectForKey:@"courseid"];
    if (courseid.length) {
        [self commitpwd:@"1" pwd:pwd1];
    }else{
        [SVProgressHUD showInfoWithStatus:@"暂无直播"];
    }

}

-(void)buyvip{
    
    [self.tabBarController setSelectedIndex:2];
//
//    UIStoryboard*storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    // 2.通过标识符找到对应的页面
//    UIViewController*vc=[storyBoard instantiateViewControllerWithIdentifier:@"BuyVipViewController"];
//    // 3.这里以push的方式加载控制器
//    [self.navigationController pushViewController:vc animated:YES];
//    [self.navigationController setNavigationBarHidden:NO];
}

-(void)forlbAction{
    UIStoryboard*storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    // 2.通过标识符找到对应的页面
    UIViewController*vc=[storyBoard instantiateViewControllerWithIdentifier:@"ForlbViewController"];
    // 3.这里以push的方式加载控制器
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)forbtnAction{
    scro2.contentOffset = CGPointMake(0, 0);
    forbtn.selected = YES;
    nowbtn.selected = NO;
}

-(void)nowbtnAction{
    scro2.contentOffset = CGPointMake(kW, 0);
    nowbtn.selected = YES;
    forbtn.selected = NO;
}


-(void)commitpwd:(NSString *)type pwd:(NSString *)pwd{
    NSString *courseid;
    if ([type integerValue] == 1) {
        courseid = datatopdic1[@"courseid"];
    }else{
        courseid = datatopdic2[@"courseid"];
    }
    
    [YJAPPNetwork getLivePsdWithToken:[APPUserDataIofo AccessToken] ID:courseid pwd:pwd success:^(NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        NSInteger data =[[responseObject objectForKey:@"data"]integerValue];
        if (code == 200) {
            if (data == 0) {
                if (![pwd isEqualToString:@""]) {
                    [SVProgressHUD showInfoWithStatus:@"密码错误"];
                }else{
                    SVDismiss;
                }

                [self showPassWordView:type];
            }else{
                [self canBtn];

                FreeLiveViewController *vc = [[FreeLiveViewController alloc]init];
                vc.Id = courseid;
                [self.navigationController pushViewController:vc animated:YES];
                SVDismiss;
            }
        }else{
            [ConventionJudge NetCode:code vc:self type:@"3"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
    }];
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return weakdataarr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nowcell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([NowTableViewCell class]) owner:self options:nil]objectAtIndex:0];
    }
    NSDictionary *dic =weakdataarr[indexPath.section];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = ALLViewBgColor;
    cell.btn.layer.cornerRadius = 3;
    cell.btn.layer.masksToBounds = YES;
    cell.classname.text = [dic objectForKey:@"coursename"];
    cell.teachername.text =[NSString stringWithFormat:@"讲师：%@",[dic objectForKey:@"realname"]] ;
    NSString *livestate = [dic objectForKey:@"liveflag"];
    if ([livestate integerValue] == 2) {
        [cell.btn setTitle:@"往前直播" forState:UIControlStateNormal];
        [cell.btn setBackgroundColor:[UIColor redColor]];
    }else if ([livestate integerValue] == 3){
        [cell.btn setTitle:@"预告直播" forState:UIControlStateNormal];
        [cell.btn setBackgroundColor:[UIColor redColor]];
    }else{
        [cell.btn setTitle:@"正在直播" forState:UIControlStateNormal];
        [cell.btn setBackgroundColor:NavAndBtnColor];
    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSDictionary *dic = weakdataarr[section];
    UIView *view = [[UIView alloc]init];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SW, 40)];
    label.text =[NSString stringWithFormat:@"      %@-%@",[dic objectForKey:@"starttime_fmt"],[dic objectForKey:@"endtime_fmt"]];
    label.textColor = [UIColor redColor];
    label.backgroundColor = ALLViewBgColor;
    [view addSubview:label];
    
    return label;
}
#pragma mark -- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == scrollview) {
        CGFloat pageWith = scrollView.frame.size.width;
        int page = floor((scrollView.contentOffset.x - pageWith/2)/pageWith)+1;
        NSLog(@"%d",page);
        if (page == 1) {
            [UIView animateWithDuration:0.5 animations:^{
                bottonln.transform = CGAffineTransformMakeTranslation(100*SW+20*SW, 0);
            }];
            self.type = @"1";
        }else{
            [UIView animateWithDuration:0.5 animations:^{
                bottonln.transform = CGAffineTransformIdentity;
            }];
            self.type = @"2";
        }
    }else{
        CGFloat pageWith = scrollView.frame.size.width;
        int page = floor((scrollView.contentOffset.x - pageWith/2)/pageWith)+1;
        NSLog(@"%d",page);
        if (page == 0) {
            forbtn.selected = YES;
            nowbtn.selected = NO;
            
        }else{
            forbtn.selected = NO;
            nowbtn.selected = YES;
        }
    }

}

-(void)showPassWordView:(NSString *)type{
    [self canBtn];
    
    //普通订场界面
        menbanview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        menbanview.backgroundColor = UIColorFromRGB(0x000000);
        menbanview.alpha = 0.8;
        [self.view addSubview:menbanview];
    
        affrimview = [[UIView alloc]initWithFrame:CGRectMake(30*SW, self.view.height/2 - 75*SW-100*SW, kW-60*SW, 165*SW)];
        affrimview.layer.cornerRadius = 5*SW;
        affrimview.layer.masksToBounds = YES;
        affrimview.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:affrimview];
    
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 10*SW, affrimview.width, 40*SW)];
        label1.font = BOLDFONT(17);
        label1.textAlignment = 1;
        label1.text = @"请输入房间密码";
        [affrimview addSubview:label1];
    
        psdtextf = [[UITextField alloc]initWithFrame:CGRectMake(15*SW, label1.maxY+10*SW, affrimview.width - 30*SW, 35*SW)];
        psdtextf.keyboardType = UIKeyboardTypeURL;
        psdtextf.secureTextEntry = YES;
        psdtextf.layer.borderColor = [NavAndBtnColor CGColor];
        psdtextf.layer.borderWidth = 0.5;
        psdtextf.textAlignment = 1;
        if ([type integerValue] == 1) {
            psdtextf.tag = 1823+1;
        }else{
            psdtextf.tag = 1823+2;
        }
        [psdtextf addTarget:self action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
        [affrimview addSubview:psdtextf];

        UIButton *cancelbtn = [[UIButton alloc]initWithFrame:CGRectMake(15*SW,psdtextf.maxY+15*SW , affrimview.width/2 - 25*SW, 40*SW)];
        cancelbtn.layer.borderColor = [NavAndBtnColor CGColor];
        cancelbtn.layer.borderWidth = 0.5;
        cancelbtn.layer.cornerRadius = 3*SW;
        cancelbtn.layer.masksToBounds = YES;
        [cancelbtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelbtn setTitleColor:NavAndBtnColor forState:UIControlStateNormal];
        [cancelbtn addTarget:self action:@selector(canBtn) forControlEvents:UIControlEventTouchUpInside];
        [affrimview addSubview:cancelbtn];
    
        UIButton *affbtn  = [[UIButton alloc]initWithFrame:CGRectMake(affrimview.width/2+10*SW,psdtextf.maxY+15*SW , affrimview.width/2 - 25*SW, 40*SW)];
        [affbtn setTitle:@"确定" forState:UIControlStateNormal];
        affbtn.layer.cornerRadius = 3*SW;
        affbtn.layer.masksToBounds = YES;
        affbtn.backgroundColor = NavAndBtnColor;

        [affbtn addTarget:self action:@selector(affbtn:) forControlEvents:UIControlEventTouchUpInside];
        [affrimview addSubview:affbtn];
    
    if ([type integerValue] == 1) {
        affbtn.tag = 91235+1;
    }else{
        affbtn.tag = 91235+2;
    }
    
    [psdtextf becomeFirstResponder];
    
    
}

-(void)valueChanged:(UITextField *)sender{
    
    if (sender.tag - 1823 == 1) {
        pwd1 = sender.text;
    }else{
        pwd2 = sender.text;
    }
}


-(void)canBtn{
    [menbanview removeFromSuperview];
    [affrimview removeFromSuperview];
}

-(void)affbtn:(UIButton *)sender{
    if (sender.tag - 91235 == 1) {
        [self commitpwd:@"1" pwd:pwd1];
    }else{
        [self commitpwd:@"2" pwd:pwd2];

    }
}

#pragma mark --- UICollectionViewDelegate
//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _collectionview) {
        return courseArr.count;

    }else{
        return courseArr2.count;

    }
    //    return 21;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ClassCollectionViewCell *cell = (ClassCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"classcell" forIndexPath:indexPath];
    
    NSDictionary *dic;
    if (collectionView == _collectionview) {
        dic = courseArr[indexPath.row];
    }else{
        dic = courseArr2[indexPath.row];

    }
    cell.titlelb.text = [dic objectForKey:@"coursename"];
    cell.titlelb.font = FONT(17);
    cell.numlb.text = [NSString stringWithFormat:@"%ld",[[dic objectForKey:@"browsingcount"]integerValue]];
    cell.numlb.textColor = [UIColor redColor];
    cell.freelb.hidden = YES;
    NSURL *url = [NSURL URLWithString:[dic objectForKey:@"coursepic"]];
    [cell.img sd_setImageWithURL:url];
    return cell;
}

#pragma mark --- UICollectionViewDelegate
//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kW/2 - 20*SW, 153*SW);
}


//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


////设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10*SW, 10*SW, 10*SW);//分别为上、左、下、右
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic;
    if (collectionView == _collectionview) {
        dic = courseArr[indexPath.row];
    }else{
        dic = courseArr2[indexPath.row];
    }
//    FreeLiveViewController *vc = [[FreeLiveViewController alloc]init];
//    vc.Id = [dic objectForKey:@"courseid"];
//    [self.navigationController pushViewController:vc animated:YES];
    LiveAncientlyViewControllerViewController *vc = [[LiveAncientlyViewControllerViewController alloc]init];
    vc.Id =[dic objectForKey:@"courseid"];
    [self.navigationController pushViewController:vc animated:YES];
}

//获取一周时间 数组
- (NSMutableArray *)getCurrentWeeksWithFirstDiff{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday
                                         fromDate:now];
    // 得到星期几
    // 1(星期天) 2(星期二) 3(星期三) 4(星期四) 5(星期五) 6(星期六) 7(星期天)
    NSInteger weekDay = [comp weekday];
    // 得到几号
    NSInteger day = [comp day];
    
    NSLog(@"weekDay:%ld  day:%ld",weekDay,day);
    
    // 计算当前日期和这周的星期一和星期天差的天数
    long firstDiff,lastDiff;
    if (weekDay == 1) {
        firstDiff = 1;
        lastDiff = 0;
    }else{
        firstDiff = [calendar firstWeekday] - weekDay;
        lastDiff = 7 - weekDay;
    }
    
    NSMutableArray *eightArr = [[NSMutableArray alloc] init];
    for (NSInteger i = firstDiff; i < lastDiff + 1; i ++) {
        //从现在开始的24小时
        NSTimeInterval secondsPerDay = i * 24*60*60;
        NSDate *curDate = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr = [dateFormatter stringFromDate:curDate];//几月几号
        //        NSString *dateStr = @"5月31日";
        NSDateFormatter *weekFormatter = [[NSDateFormatter alloc] init];
        [weekFormatter setDateFormat:@"EEEE"];//星期几 @"HH:mm 'on' EEEE MMMM d"];
        //组合时间
        NSString *strTime = [NSString stringWithFormat:@"%@",dateStr];
        [eightArr addObject:strTime];
    }
    return eightArr;
}
@end
