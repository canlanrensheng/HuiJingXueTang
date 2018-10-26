//
//  LiveAncientlyViewControllerViewController.m
//  HuiJingSchool
//
//  Created by 陈燕军 on 2018/6/18.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "LiveAncientlyViewControllerViewController.h"

#import "HACursor.h"
#import "NowTableViewCell.h"
#import "AppraiseTableViewCell.h"
#import "RegistCodeViewController.h"
#import <ZFPlayer/ZFPlayer.h>
#import "GiftView.h"
#import "PayBottonView.h"
#import "ClassCollectionViewCell.h"
#import <MJRefresh.h>
#import "TeacherInfoViewController.h"

#define topiewH SafeAreaTopHeight - 64
@interface LiveAncientlyViewControllerViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) ZFPlayerView *playerView;
@property (nonatomic, strong) UICollectionView *collectionview2;

@end

@implementation LiveAncientlyViewControllerViewController
{
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
    NSDictionary *roomdic;
    NSDictionary *coursedic;
    NSDictionary *chatdic;
    UIImageView *iconview;
    UILabel *namelb1;
    UILabel *namelb2;
    UIScrollView *scrollview;
    NSMutableArray*courseArr;
    NSInteger page1;
    NSInteger totalpage1;
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
    [self loaddata];

}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"loaddata" object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ALLViewBgColor;
    
    // Do any additional setup after loading the view.
}

-(void)loadTeacher{
    [YJAPPNetwork TeacherTaskInfowithinfoid:userid success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            datadic = [responseObject objectForKey:@"data"];
            [self getmainview];
            NSURL *iconurl = [NSURL URLWithString:[datadic objectForKey:@"iconurl"]];
            [iconview sd_setImageWithURL:iconurl placeholderImage:[UIImage imageNamed:@"placeholder"]];
            namelb1.text = [datadic objectForKey:@"realname"];
            namelb2.text = [datadic objectForKey:@"introduction"];
            [self loadrecomment];

        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];

    }];
}
-(void)loaddata{
    if ([[APPUserDataIofo AccessToken] isEqualToString:@""]) {
        [YJShareCategory JumploginWhichVC:self andtype:@"1"];
        return;
    }
    [YJAPPNetwork LiveRoomWithAccessToken:[APPUserDataIofo AccessToken] ID:_Id success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {

            datadic = [responseObject objectForKey:@"data"];
            coursedic = [datadic objectForKey:@"course"];
            userid = [coursedic objectForKey:@"userid"];
            [self getmainview];
            [self loadTeacher];
        }else{
            if (code == 29) {
                [SVProgressHUD showInfoWithStatus:[responseObject objectForKey:@"msg"]];
                [self.navigationController popViewControllerAnimated:YES];
            }
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
    }];
}
-(void)loadrecomment{
    [YJAPPNetwork recommendCourseWithteacherid:userid courseid:_Id success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            SVDismiss;
            recommentArr = [NSArray array];
            recommentArr = [responseObject objectForKey:@"data"];
            [self loadTeapastlivecourse];
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

    UIView*topview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kW, topiewH)];
    topview.backgroundColor = [UIColor blackColor];
    [self.view addSubview:topview];
    
    UIView *liveimgview = [[UIView alloc]initWithFrame:CGRectMake(0, topview.maxY, kW, 200*SW)];
    [self.view addSubview:liveimgview];
    if (![[coursedic objectForKey:@"videourl"] isEqualToString:@""]) {
        self.playerView = [[ZFPlayerView alloc] initWithFrame:liveimgview.bounds];
        [liveimgview addSubview:self.playerView];
        
        // 初始化控制层view(可自定义)
//        ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
//        // 初始化播放模型
//        ZFPlayerModel *playerModel = [[ZFPlayerModel alloc]init];
//        playerModel.fatherView = liveimgview;
//        playerModel.title = @"";
//        playerModel.videoURL = [NSURL URLWithString:[coursedic objectForKey:@"videourl"]];
//        [self.playerView playerControlView:controlView playerModel:playerModel];
//        // 设置代理
//        self.playerView.delegate = self;
    }else{
//        [self.playerView resetPlayer];

        UIImageView *topimgview = [[UIImageView alloc]initWithFrame:liveimgview.bounds];
        NSURL *imgurl = [coursedic objectForKey:@"coursepic"];
        [topimgview sd_setImageWithURL:imgurl];
        [liveimgview addSubview:topimgview];
        
        UIButton *popbtn = [[UIButton alloc]initWithFrame:CGRectMake(10*SW, 25*SW, 25*SW, 25*SW)];
        [popbtn setImage:[UIImage imageNamed:@"back_n"] forState:UIControlStateNormal];
        [popbtn setImage:[UIImage imageNamed:@"back_p"] forState:UIControlStateHighlighted];
        [popbtn addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
        [liveimgview addSubview:popbtn];
    }
    
    
    
    UIView *titleview = [[UIView alloc]initWithFrame:CGRectMake(0, liveimgview.maxY, kW, 40*SW)];
    titleview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleview];
    
    UIView *ln = [[UIView alloc]initWithFrame:CGRectMake(0, 40*SW-0.5, kW, 0.5)];
    ln.backgroundColor = LnColor;
    [titleview addSubview:ln];
    
    UILabel *titlelb = [[UILabel alloc]initWithFrame:CGRectMake(15*SW, 10*SW, 75*SW, 20*SW)];
    titlelb.textColor = NavAndBtnColor;
    titlelb.text = @"正在播放：";
    titlelb.font = FONT(14);
    [titleview addSubview:titlelb];
    
    UILabel *namelb = [[UILabel alloc]initWithFrame:CGRectMake(titlelb.maxX, 10*SW, kW/2, 20*SW)];
    namelb.text = [coursedic objectForKey:@"coursename"];
    namelb.font = FONT(14);
    [titleview addSubview:namelb];
    
    
    scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, titleview.maxY+10*SW, kW, kH - titleview.maxY)];
    [self.view addSubview:scrollview];
    
    
    UIView *infoview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kW, 75*SW)];
    infoview.backgroundColor = [UIColor whiteColor];
    [scrollview addSubview:infoview];
    
    iconview = [[UIImageView alloc]initWithFrame:CGRectMake(12.5*SW, 7.5*SW, 60*SW, 60*SW)];
    iconview.layer.cornerRadius = 30*SW;
    iconview.layer.masksToBounds = YES;
    [infoview addSubview:iconview];
    
    namelb1 = [[UILabel alloc]initWithFrame:CGRectMake(iconview.maxX+22.5*SW, 2.5*SW, 200*SW+topiewH, 35*SW)];
    namelb1.font = FONT(14);
    [infoview addSubview:namelb1];
    
    namelb2 = [[UILabel alloc]initWithFrame:CGRectMake(iconview.maxX+22.5*SW, 37.5*SW, 200*SW+topiewH, 35*SW)];
    namelb2.text = [datadic objectForKey:@"introduction"];
    namelb2.font = FONT(14);
    [infoview addSubview:namelb2];
    
    UIButton *admire = [[UIButton alloc]initWithFrame:CGRectMake(kW - 50*SW, 12.5*SW, 50*SW, 50*SW)];
    [admire setImage:[UIImage imageNamed:@"29_"] forState:UIControlStateNormal];
    [admire addTarget:self action:@selector(admireActon) forControlEvents:UIControlEventTouchUpInside];
    [infoview addSubview:admire];
}

-(void)admireActon{
    TeacherInfoViewController *vc = [[TeacherInfoViewController alloc]init];
    vc.Id = userid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)zf_playerBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}


//免费课程
-(void)freecourse{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 85*SW, kW, 200*SW+topiewH)];
    view.backgroundColor = [UIColor whiteColor];
    [scrollview addSubview:view];
    
    UILabel *livelb = [[UILabel alloc]initWithFrame:CGRectMake(10.5*SW, 10,100, 22.5*SW)];
    livelb.font = BOLDFONT(20);
    livelb.text = @"推荐课程";
    [view addSubview:livelb];
    
    UIScrollView *freescv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 42.5*SW, kW, 150*SW)];
    [view addSubview:freescv];
    
    NSInteger count = recommentArr.count;
    for (int i  = 0; i < recommentArr.count; i++) {
        NSDictionary *dic  = recommentArr[i];
        UIButton *freeview = [[UIButton alloc]initWithFrame:CGRectMake(15*SW + (200+30)*SW*i, 0, 200*SW+topiewH, 150*SW)];
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
    freescv.contentSize = CGSizeMake(30*SW*count + 200*SW+topiewH*count, 0);
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, view.maxY +10*SW, kW, 20*SW)];
    label.textColor = TextColor;
    label.textAlignment = 1;
    label.font = FONT(14);
    label.text = @"往期免费直播";
    [scrollview addSubview:label];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, label.maxY+10*SW, kW, 400*SW)];
    [scrollview addSubview:view1];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置collectionView滚动方向
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    //2.初始化collectionView
    self.collectionview2 = [[UICollectionView alloc] initWithFrame:view1.bounds collectionViewLayout:layout];
    [view1 addSubview:self.collectionview2];
    //4.设置代理
    self.collectionview2.delegate = self;
    self.collectionview2.dataSource = self;
    self.collectionview2.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadTeapastlivecourse)];
    self.collectionview2.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoredata1)];
    self.collectionview2.backgroundColor = [UIColor clearColor];
    
    //3.注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([ClassCollectionViewCell class]) bundle:[NSBundle mainBundle]];
    [self.collectionview2 registerNib:nib forCellWithReuseIdentifier:@"classcell"];
    
    scrollview.contentSize = CGSizeMake(0, view1.maxY);
    
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

-(void)loadMoredata1{
    
    if (totalpage1 == 0||page1 == totalpage1) {
        [_collectionview2.mj_footer setState:MJRefreshStateNoMoreData];
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

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
        return courseArr.count;
    //    return 21;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ClassCollectionViewCell *cell = (ClassCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"classcell" forIndexPath:indexPath];
    
    NSDictionary *dic;
    dic = courseArr[indexPath.row];

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
    dic = courseArr[indexPath.row];

    //    FreeLiveViewController *vc = [[FreeLiveViewController alloc]init];
    //    vc.Id = [dic objectForKey:@"courseid"];
    //    [self.navigationController pushViewController:vc animated:YES];
    self.Id =[dic objectForKey:@"courseid"];
    [self loaddata];
}

-(void)menbanHide{
    [menbanview removeFromSuperview];
}

-(void)freebtnAction:(UIButton *)sender{
    NSInteger index = sender.tag - 86123;
    NSDictionary *dic  = recommentArr[index];
    self.Id = [dic objectForKey:@"courseid"];
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


-(void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)listAction:(UIButton *)sender{
    NSDictionary *dic = classarr[sender.tag - 126521];
    self.Id = [dic objectForKey:@"courseid"];
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
            [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"]];
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
            cell.timelb.text = [dic objectForKey:@"createtime"];
            
        }
        
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == tableview1) {
        return 60;
        
    }else{
        return 110;
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
