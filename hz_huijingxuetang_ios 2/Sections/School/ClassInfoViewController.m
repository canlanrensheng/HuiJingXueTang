//
//  ClassInfoViewController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/1/30.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "ClassInfoViewController.h"
#import "HACursor.h"
#import "NowTableViewCell.h"
#import "AppraiseTableViewCell.h"
#import "RegistCodeViewController.h"
//#import <ZFPlayer.h>
#import <ZFPlayer/ZFPlayer.h>
#import "GiftView.h"
#import "PayBottonView.h"
#import "YJShareTool.h"
@interface ClassInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) ZFPlayerView *playerView;

@end

@implementation ClassInfoViewController
{
    UIScrollView *scrollview;
    HACursor*cursor;
    UITableView *tableview1;
    UITableView *tableview2;
    UIButton *menbanview;
    NSMutableArray *btnarr;
    UIView *giftview;
    UILabel*label4;
    UIView *cardview;
    NSMutableArray *imgarr;
    NSDictionary *datadic;
    NSArray *classarr;
    NSArray *classappraiseArr;
    NSArray *dataarr;
    NSString *userid;
    NSArray *recommentArr;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    [self.playerView pause];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loaddata) name:@"loaddata" object:nil];

}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"loaddata" object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ALLViewBgColor;
    [self loaddata];

    // Do any additional setup after loading the view.
}

-(void)pageview{
    
    _titleArray=[[NSMutableArray alloc]init];
    [_titleArray addObject:@"课程介绍"];
    [_titleArray addObject:@"课程目录"];
    [_titleArray addObject:@"课程评价"];

    cursor = [[HACursor alloc]init];
    cursor.itemTitleBtnWidth=kW/3;
    cursor.frame = CGRectMake(0, 525*SW, kW, 45);
    cursor.scrollNavBar.linecoler = NavAndBtnColor;
    cursor.titles =_titleArray;
    cursor.pageViews = [self createPageViews];
    cursor.backgroundColor= CWHITE;


    //设置根滚动视图的高度
    
    if (![[datadic objectForKey:@"buy"] isEqualToString:@"y"]) {
        cursor.rootScrollViewHeight =kH-cursor.maxY - 40*SW;
    }else{
        cursor.rootScrollViewHeight =kH-cursor.maxY;

    }
    //    cursor.rootScrollView.backgroundColor=Background_Color;
    //默认值是白色
    cursor.titleNormalColor = TextNoColor;
    //默认值是白色
    cursor.titleSelectedColor = NavAndBtnColor;
    //        cursor.titleSelectedColor = WYColorMain;
    //是否显示排序按钮
    cursor.showSortbutton = NO;
    //    cursor.rootScrollView.rootScrollViewDateSource = self;
    //默认的最小值是5，小于默认值的话按默认值设置
    cursor.minFontSize = 14;
    //默认的最大值是25，小于默认值的话按默认值设置，大于默认值按设置的值处理
    cursor.maxFontSize = 17;
    //cursor.isGraduallyChangFont = NO;
    //在isGraduallyChangFont为NO的时候，isGraduallyChangColor不会有效果
    //cursor.isGraduallyChangColor = NO;
    [self.view addSubview:cursor];
    
}

//- (NSUInteger)numberOfCellInRootScrollView:(HARootScrollView *)rootScrollView{
//    return 2;
//}


- (NSMutableArray *)createPageViews{
    
    NSMutableArray *pageViews = [NSMutableArray array];
    for (NSInteger i = 0; i <_titleArray.count; i++)
    {
        if (i==0) {
            UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kW, self.view.frame.size.height-cursor.maxY+20)];
            view1.backgroundColor = [UIColor whiteColor];
            
            UITextView *textview = [[UITextView alloc]initWithFrame:CGRectMake(0,  20*SW , kW, 220*SW)];
            textview.backgroundColor = [UIColor clearColor];
            textview.textColor = TextColor;
            textview.textAlignment = 1;
            textview.font = TextFont;
            textview.userInteractionEnabled = NO;
            textview.text = @"如果你无法表达你的想\n法，那只说明你还不够了解他\n";
            [view1 addSubview:textview];

            [pageViews addObject:view1];
            
        }else if(i==1){
            tableview1 = [[UITableView alloc]init];
            tableview1.frame = CGRectMake(0, 0, kW, self.view.frame.size.height-cursor.maxY);
            tableview1.delegate = self;
            tableview1.dataSource = self;
            tableview1.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableview1.backgroundColor = ALLViewBgColor;
            [pageViews addObject:tableview1];
            
        }else{
            tableview2 = [[UITableView alloc]init];
            tableview2.frame = CGRectMake(0, 0, kW, self.view.frame.size.height-cursor.maxY);
            tableview2.delegate = self;
            tableview2.dataSource = self;
            tableview2.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableview2.backgroundColor = ALLViewBgColor;
            [pageViews addObject:tableview2];
        }
    }
    return pageViews;
}

-(void)loaddata{
    [YJAPPNetwork ClassInfowithCoureId:_courseId Accesstoken:[APPUserDataIofo AccessToken] success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            datadic = [responseObject objectForKey:@"data"];
            userid = [datadic objectForKey:@"userid"];
            [self getmainview];
            
            if (![[datadic objectForKey:@"buy"] isEqualToString:@"y"]) {
                [self getPayBottonView];
            }else{
                [self playcount:[datadic objectForKey:@"videoid"]];
            }
            [self pageview];
            [self loadClass];
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
        
    }];
    
}


-(void)loadClass{
    [YJAPPNetwork ClasscatalogedwithCoureId:self.courseId Accesstoken:[APPUserDataIofo AccessToken] success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
//            NSDictionary *dic= [responseObject objectForKey:@"data"];
            classarr = [NSArray array];
            classarr = [responseObject objectForKey:@"data"];
            [self loadclassAppraise];
            [tableview1 reloadData];

            SVDismiss;
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
    }];
}

-(void)loadclassAppraise{
    [YJAPPNetwork ClassAppraisewithCoureId:_courseId page:@"" success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            [self loadrecomment];
            classappraiseArr = [NSArray array];
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            classappraiseArr = [dic objectForKey:@"coursecomment"];
            [tableview2 reloadData];
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
    }];
}

-(void)loadrecomment{
    [YJAPPNetwork recommendCourseWithteacherid:userid courseid:_courseId success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            SVDismiss;
            recommentArr = [NSArray array];
            recommentArr = [responseObject objectForKey:@"data"];
            [self freecourse];
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
    }];
}

-(void)getmainview{
    self.view.backgroundColor = ALLViewBgColor;
    
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    
    UIView *liveimgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kW, 200*SW)];
    [self.view addSubview:liveimgview];
    if ([[datadic objectForKey:@"buy"] isEqualToString:@"y"]) {
        self.playerView = [[ZFPlayerView alloc] initWithFrame:liveimgview.bounds];
        [liveimgview addSubview:self.playerView];
        
        // 初始化控制层view(可自定义)
//        ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
//        // 初始化播放模型
//        ZFPlayerModel *playerModel = [[ZFPlayerModel alloc]init];
//        playerModel.fatherView = liveimgview;
//        playerModel.title = @"";
//        playerModel.videoURL = [NSURL URLWithString:[datadic objectForKey:@"videourl"]];
//        [self.playerView playerControlView:controlView playerModel:playerModel];
//        // 设置代理
//        self.playerView.delegate = self;
//        [self.playerView autoPlayTheVideo];
    }else{
        UIImageView *topimgview = [[UIImageView alloc]initWithFrame:liveimgview.bounds];
        NSURL *imgurl = [datadic objectForKey:@"videoppicurl"];
        [topimgview sd_setImageWithURL:imgurl];
        [liveimgview addSubview:topimgview];
        
        UIButton *popbtn = [[UIButton alloc]initWithFrame:CGRectMake(10*SW, 25*SW, 25*SW, 25*SW)];
        [popbtn setImage:[UIImage imageNamed:@"back_n"] forState:UIControlStateNormal];
        [popbtn setImage:[UIImage imageNamed:@"back_p"] forState:UIControlStateHighlighted];
        [popbtn addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
        [liveimgview addSubview:popbtn];
        
        UIButton *sharebtn = [[UIButton alloc]initWithFrame:CGRectMake(kW - 40*SW, 25*SW, 25*SW, 25*SW)];
        [sharebtn setBackgroundImage:[UIImage imageNamed:@"名师的课程_03"] forState:UIControlStateNormal];
        [sharebtn setBackgroundImage:[UIImage imageNamed:@"名师的课程_03"] forState:UIControlStateHighlighted];
        [sharebtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
        [liveimgview addSubview:sharebtn];
    }


    
    UIView *titleview = [[UIView alloc]initWithFrame:CGRectMake(0, liveimgview.maxY, kW, 40*SW)];
    titleview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleview];
    
    UIView *ln = [[UIView alloc]initWithFrame:CGRectMake(0, 40*SW-0.5, kW, 0.5)];
    ln.backgroundColor = LnColor;
    [titleview addSubview:ln];
    
    UILabel *titlelb = [[UILabel alloc]initWithFrame:CGRectMake(15*SW, 10*SW, 45 *SW, 20*SW)];
    titlelb.textColor = NavAndBtnColor;
    titlelb.text = @"讲师：";
    titlelb.font = FONT(14);
    [titleview addSubview:titlelb];
    
    UILabel *namelb = [[UILabel alloc]initWithFrame:CGRectMake(titlelb.maxX, 10*SW, kW/2, 20*SW)];
    namelb.text = [datadic objectForKey:@"username"];
    namelb.font = FONT(14);
    [titleview addSubview:namelb];
    
    
    UIButton *assist = [[UIButton alloc]initWithFrame:CGRectMake(kW - 70*SW, 0, 60*SW, 40*SW)];
    [assist setImage:[UIImage imageNamed:@"63_"] forState:UIControlStateNormal];
    [assist setImage:[UIImage imageNamed:@"33_"] forState:UIControlStateSelected];
    if ([[datadic objectForKey:@"praise"] isEqualToString:@"y"]) {
        assist.selected = YES;
        assist.userInteractionEnabled = NO;
    }
    [assist addTarget:self action:@selector(assistAction:) forControlEvents:UIControlEventTouchUpInside];
    [assist setTitle:[NSString stringWithFormat:@"  %ld",[[datadic objectForKey:@"thumbsupcount"]integerValue]] forState:UIControlStateNormal];
    [assist setTitleColor:TextNoColor forState:UIControlStateNormal];
    assist.titleLabel.font = FONT(15);
    [titleview addSubview:assist];
    
    UIButton *admire = [[UIButton alloc]initWithFrame:CGRectMake(assist.minX - 50*SW, 0, 40*SW, 40*SW)];
    [admire addTarget:self action:@selector(shang) forControlEvents:UIControlEventTouchUpInside];
    [titleview addSubview:admire];
    
    UIImageView *shangimg = [[UIImageView alloc]initWithFrame:CGRectMake(10*SW, 10*SW, 20*SW, 20*SW)];
    shangimg.image = [UIImage imageNamed:@"class_shang07"];
    [admire addSubview:shangimg];
    
    UIView *infoview = [[UIView alloc]initWithFrame:CGRectMake(0, titleview.maxY+10*SW, kW, 75*SW)];
    infoview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:infoview];
    
    
    UIImageView *iconview = [[UIImageView alloc]initWithFrame:CGRectMake(12.5*SW, 7.5*SW, 60*SW, 60*SW)];
    iconview.layer.cornerRadius = 30*SW;
    iconview.layer.masksToBounds = YES;
    NSURL *iconurl = [NSURL URLWithString:[datadic objectForKey:@"iconurl"]];
    [iconview sd_setImageWithURL:iconurl placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [infoview addSubview:iconview];
    
    UILabel *namelb1 = [[UILabel alloc]initWithFrame:CGRectMake(iconview.maxX+22.5*SW, 2.5*SW, 200*SW, 35*SW)];
    namelb1.text = [datadic objectForKey:@"username"];
    namelb1.font = FONT(14);
    [infoview addSubview:namelb1];
    
    
    UILabel *namelb2 = [[UILabel alloc]initWithFrame:CGRectMake(iconview.maxX+22.5*SW, 37.5*SW, 200*SW, 35*SW)];
    namelb2.text = [datadic objectForKey:@"introduction"];
    namelb2.font = FONT(14);
    [infoview addSubview:namelb2];
}

-(void)getPayBottonView{
    PayBottonView *pay  = [[PayBottonView alloc]initWithFrame:CGRectMake(0, kH - SafeAreaBottomHeight - 40*SW, kW, 40*SW)];
    pay.amont = [NSString stringWithFormat:@"￥%ld",[[datadic objectForKey:@"coursemoney"]integerValue]];
    pay.Id = [datadic objectForKey:@"courseid"];
    [self.view insertSubview:pay atIndex:999];
}

- (void)zf_playerBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)assistAction:(UIButton *)sender{
    NSString *accesstoken = [APPUserDataIofo AccessToken];
    [YJAPPNetwork zanwithAccesstoken:accesstoken Id:self.courseId success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            SVDismiss;
            [self loaddata];
            sender.selected = YES;
            sender.userInteractionEnabled = NO;
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
    }];
}

//免费课程
-(void)freecourse{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 315*SW, kW, 200*SW)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UILabel *livelb = [[UILabel alloc]initWithFrame:CGRectMake(10.5*SW, 10,100, 22.5*SW)];
    livelb.font = BOLDFONT(20);
    livelb.text = @"推荐课程";
    [view addSubview:livelb];
    
    UIScrollView *freescv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 42.5*SW, kW, 150*SW)];
    [view addSubview:freescv];
    
    NSInteger count = recommentArr.count;
    for (int i  = 0; i < recommentArr.count; i++) {
        NSDictionary *dic  = recommentArr[i];
        UIButton *freeview = [[UIButton alloc]initWithFrame:CGRectMake(15*SW + (200+30)*SW*i, 0, 200*SW, 150*SW)];
        freeview.tag = 86123+i;
        [freeview addTarget:self action:@selector(freebtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [freescv addSubview:freeview];
        
        UIImageView *showview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, freeview.width, 100*SW)];
        NSURL *url = [NSURL URLWithString:[dic objectForKey:@"coursepic"]];
        [showview sd_setImageWithURL:url];
        [freeview addSubview:showview];
        
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 100*SW, freeview.width, 25*SW)];
        label.text = [dic objectForKey:@"coursename"];
        label.font = FONT(17);
        label.textColor = TextNoColor;
        [freeview addSubview:label];
        
        UIImageView * imgv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 130*SW, 12*SW, 10*SW)];
        imgv.image = [UIImage imageNamed:@"38_"];
        [freeview addSubview:imgv];
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(17*SW, 125*SW, freeview.width/3*2, 20*SW)];
        label1.text = [NSString stringWithFormat:@"已有%ld人学习",[[dic objectForKey:@"study_count"] integerValue]];
        NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"已有%ld人学习",[[dic objectForKey:@"study_count"] integerValue]]];
        //获取要调整颜色的文字位置,调整颜色
        NSRange range1=[[hintString string]rangeOfString:@"已有人学习"];
        [hintString addAttribute:NSForegroundColorAttributeName value:TextNoColor range:range1];
        
        NSRange range2=[[hintString string]rangeOfString:[NSString stringWithFormat:@"%ld",[[dic objectForKey:@"study_count"] integerValue]]];
        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range2];
        
        label1.attributedText=hintString;
        label1.font = FONT(13);
        [freeview addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(freeview.width-110*SW, 125*SW, 100*SW, 20*SW)];
        NSInteger type = [[dic objectForKey:@"type"]integerValue];
        label2.text = type == 1?@"免费":[NSString stringWithFormat:@"￥%.2f",[[dic objectForKey:@"coursemoney"]doubleValue]];
        label2.font = FONT(13);
        label2.textAlignment = 2;
        label2.textColor = [UIColor redColor];
        [freeview addSubview:label2];
        
    }
    freescv.contentSize = CGSizeMake(30*SW*count + 200*SW*count, 0);
    

}

-(void)menbanHide{
    [menbanview removeFromSuperview];
}

- (void)freebtnAction:(UIButton *)sender{
    NSInteger index = sender.tag - 86123;
    NSDictionary *dic  = recommentArr[index];
    self.courseId = [dic objectForKey:@"courseid"];
    [self loaddata];
}

//点击了注册
-(void)registAction{
    RegistCodeViewController*rcvc = [[RegistCodeViewController alloc]init];
    [self.navigationController pushViewController:rcvc animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)shang{
    [YJAPPNetwork GiftTasksuccess:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            dataarr = [NSArray array];
            dataarr = [responseObject objectForKey:@"data"];
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


-(void)playcount:(NSString *)ID{
    [YJAPPNetwork vedioCountWithID:ID success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code != 200) {
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
    }];
    SVDismiss;
}

-(void)shareAction{
    [YJShareTool ToolShareUrlWithUrl:@"http://mp.huijingschool.com/#/share" title:@"慧鲸学堂" content:@"邀请好友" andViewC:self];
}
-(void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)listAction:(UIButton *)sender{
    NSDictionary *dic = classarr[sender.tag - 126521];
    self.courseId = [dic objectForKey:@"courseid"];
    [self loaddata];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == tableview1) {
        return classarr.count;
    }else{
        return classappraiseArr.count;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == tableview1) {
        NowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nowcell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([NowTableViewCell class]) owner:self options:nil]objectAtIndex:0];
        }
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = ALLViewBgColor;
        NSDictionary *dic = classarr[indexPath.section];
        cell.playimg.hidden = NO;
        cell.playnum.hidden = NO;
        cell.btn.layer.cornerRadius = 3;
        cell.btn.layer.masksToBounds = YES;
        cell.playnum.text = [NSString stringWithFormat:@"%ld",[[dic objectForKey:@"hits"]integerValue]];
        cell.classname.text = [dic objectForKey:@"videoname"];
        cell.teachername.text = [NSString stringWithFormat:@"讲师：%@",[datadic objectForKey:@"username"]];
        cell.btnwidth.constant = 80*SW;
        cell.btn.tag = 126521+indexPath.section;
        [cell.btn addTarget:self action:@selector(listAction:) forControlEvents:UIControlEventTouchUpInside];
        if ([[dic objectForKey:@"videoid"]isEqualToString:[datadic objectForKey:@"videoid"]]) {
            [cell.btn setTitle:@"正在播放" forState:UIControlStateNormal];
            [cell.btn setBackgroundColor:NavAndBtnColor];
            cell.btn.userInteractionEnabled = NO;
        }else{
            [cell.btn setTitle:@"立即学习" forState:UIControlStateNormal];
            cell.btn.layer.borderWidth = 1;
            cell.btn.layer.borderColor = [NavAndBtnColor CGColor];
            [cell.btn setTitleColor:NavAndBtnColor forState:UIControlStateNormal];
            cell.btn.userInteractionEnabled = YES;

        }
        return cell;
    }else{
        AppraiseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"appcell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([AppraiseTableViewCell class]) owner:self options:nil]objectAtIndex:0];
        }
        cell.selectionStyle = 0;
        cell.timelb.font = TextsmlFont;
        if (classappraiseArr.count) {
            NSDictionary *dic = classappraiseArr[indexPath.section];
            NSURL *url = [NSURL URLWithString:[dic objectForKey:@"iconurl"]];
            [cell.iconimg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"tuixiang"]];
            cell.namelb.text = [dic objectForKey:@"nickname"];
            cell.namelb.font = FONT(15);

            NSInteger starnum = [[dic objectForKey:@"coursescore"]integerValue];
            
            if (starnum == 1) {
                cell.star1.highlighted = NO;
                cell.star2.highlighted = YES;
                cell.star3.highlighted = YES;
                cell.star4.highlighted = YES;
                cell.star5.highlighted = YES;
            }else if (starnum == 2) {
                cell.star1.highlighted = NO;
                cell.star2.highlighted = NO;
                cell.star3.highlighted = YES;
                cell.star4.highlighted = YES;
                cell.star5.highlighted = YES;
            }else if (starnum == 3) {
                cell.star1.highlighted = NO;
                cell.star2.highlighted = NO;
                cell.star3.highlighted = NO;
                cell.star4.highlighted = YES;
                cell.star5.highlighted = YES;
            }else if (starnum == 4) {
                cell.star1.highlighted = NO;
                cell.star2.highlighted = NO;
                cell.star3.highlighted = NO;
                cell.star4.highlighted = NO;
                cell.star5.highlighted = YES;
            }else if (starnum == 5) {
                cell.star1.highlighted = NO;
                cell.star2.highlighted = NO;
                cell.star3.highlighted = NO;
                cell.star4.highlighted = NO;
                cell.star5.highlighted = NO;
            }
            cell.conlb.text = [dic objectForKey:@"commentcontent"];
            cell.conlb.font = FONT(15);
            cell.timelb.text = [dic objectForKey:@"createtime"];
            cell.namelb.font = FONT(15);
            cell.timelb.textColor = TextNoColor;
            cell.timelaW.constant = 100*SW;
            cell.timelb.lineBreakMode = 0;
            cell.timelb.numberOfLines = 2;
            [cell.timelb sizeToFit];
            
        }

        return cell;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == tableview1) {
        return 60;

    }else{
        NSDictionary *dic = classappraiseArr[indexPath .section];
        NSString *con = [dic objectForKey:@"commentcontent"];
        CGFloat H = [UILabel getHeightByWidth:kW - 95 title:con font:FONT(15)];
        
        return 91+H;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == tableview1) {
        return 10;

    }else{
        return 0;

    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];

    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == tableview1) {
        return 0;
    }else{
        return 1;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    
    
    return view;
}
@end
