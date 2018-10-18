
//
//  TeacherInfoViewController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/1/31.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "TeacherInfoViewController.h"
#import "HACursor.h"
#import "ClassInfoViewController.h"
#import "LiveAncientlyViewControllerViewController.h"
@interface TeacherInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *titleArray;


@end

@implementation TeacherInfoViewController
{
    UIScrollView *scrollview;
    HACursor*cursor;
    UITableView *tableview1;
    UITableView *tableview2;
    UIButton *menbanview;
    NSDictionary *dic;
    NSArray *classarr1;
    NSArray *classarr2;
    NSArray *classarr3;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ALLViewBgColor;

    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"13_"] style:UIBarButtonItemStylePlain target:self action:@selector(releaseInfo)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    [self loaddata];
}

-(void)loaddata{
    [YJAPPNetwork TeacherTaskInfowithinfoid:_Id success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            dic = [responseObject objectForKey:@"data"];
            [self getmainview];
            [self loadclass:@"1"];
            SVDismiss;
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
    }];
}

-(void)loadclass:(NSString *)type{
    [YJAPPNetwork TeacherClassTaskwithinfoid:_Id type:type success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            if ([type integerValue] == 1) {
                classarr1 = [NSArray array];
                classarr1 = [responseObject objectForKey:@"data"];
                [self loadclass:@"2"];
            }else if ([type integerValue]==2){
                classarr2 = [NSArray array];
                classarr2 = [responseObject objectForKey:@"data"];
                [self loadclass:@"3"];
            }else{
                classarr3 = [NSArray array];
                classarr3 = [responseObject objectForKey:@"data"];
                [self pageview];
                SVDismiss;
            }
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
    }];
}

-(void)pageview{
    _titleArray=[[NSMutableArray alloc]init];
    [_titleArray addObject:@"课程"];
    [_titleArray addObject:@"私教课"];
    [_titleArray addObject:@"往期直播课程"];
    
    cursor = [[HACursor alloc]init];
    cursor.itemTitleBtnWidth=kW/3;
    cursor.frame = CGRectMake(0, 265*SW, kW, 45);
    cursor.scrollNavBar.linecoler = NavAndBtnColor;
    cursor.titles =_titleArray;
    cursor.pageViews = [self createPageViews];
    cursor.backgroundColor= CWHITE;
    //设置根滚动视图的高度
    cursor.rootScrollViewHeight =self.view.frame.size.height-cursor.maxY;
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
    [scrollview addSubview:cursor];
    
    scrollview.contentSize = CGSizeMake(0, cursor.maxY+20);
}

- (NSMutableArray *)createPageViews{
    
    NSMutableArray *pageViews = [NSMutableArray array];
    for (NSInteger i = 0; i <_titleArray.count; i++)
    {
        if (i==0) {
            UIScrollView *view1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kW, self.view.frame.size.height-cursor.maxY)];
            view1.backgroundColor = [UIColor whiteColor];
            
            for (int i = 0; i<classarr1.count; i++) {
                NSDictionary *dic = classarr1[i];
                NSInteger lin = i/2;
                NSInteger row = i%2;
                
                UIButton *courseview = [[UIButton alloc]initWithFrame:CGRectMake(15*SW +(15*SW + kW/2-22.5*SW)*row,10+163*SW*lin, kW/2-22.5*SW, 153*SW)];
                courseview.backgroundColor = ALLViewBgColor;
                courseview.tag = 62913+i;
                [courseview addTarget:self action:@selector(courseAction:) forControlEvents:UIControlEventTouchUpInside];
                [view1 addSubview:courseview];
                
                UIImageView *showview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, courseview.width, 100*SW)];
                NSURL *url = [NSURL URLWithString:[dic objectForKey:@"coursepic"]];
                [showview sd_setImageWithURL:url];
                [courseview addSubview:showview];
                
                UILabel *titlelb = [[UILabel alloc]initWithFrame:CGRectMake(5*SW, showview.maxY+10*SW, showview.width, 18*SW)];
                titlelb.text = [dic objectForKey:@"coursename"];
                titlelb.font = FONT(15);
                titlelb.textColor = TextNoColor;
                [courseview addSubview:titlelb];
                
                UIImageView * imgv = [[UIImageView alloc]initWithFrame:CGRectMake(5*SW, titlelb.maxY+5*SW, 10*SW, 10*SW)];
                imgv.image = [UIImage imageNamed:@"6_"];
                [courseview addSubview:imgv];
                
                UILabel *titlelb2 = [[UILabel alloc]initWithFrame:CGRectMake(20*SW, titlelb.maxY+2.5*SW, titlelb.width/3*2, 15*SW)];
                titlelb2.text =[NSString stringWithFormat:@"已有%ld人学习",[[dic objectForKey:@"study_count"]integerValue]] ;
                titlelb2.textColor = TextNoColor;
                titlelb2.font = FONT(13);
                [courseview addSubview:titlelb2];
                
                UILabel *titlelb3 = [[UILabel alloc]initWithFrame:CGRectMake(titlelb.maxX - 50*SW, titlelb.maxY, 40*SW, 15*SW)];
                titlelb3.textColor = [UIColor redColor];
                titlelb3.font = FONT(14);
                [courseview addSubview:titlelb3];
                if ([[dic objectForKey:@"type"]integerValue] == 1) {
                    titlelb3.text = @"免费";
                }else if([[dic objectForKey:@"type"]integerValue] == 2){
                    titlelb3.text = [NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"coursemoney"]doubleValue]];
                }

                if (i == classarr1.count - 1) {
                    view1.contentSize = CGSizeMake(0, courseview.maxY);
                }
            }
            [pageViews addObject:view1];
            
        }else if(i==1){
            UIScrollView *view1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kW, self.view.frame.size.height-cursor.maxY)];
            view1.backgroundColor = [UIColor whiteColor];
            

            for (int i = 0; i<classarr2.count; i++) {
                NSInteger lin = i/2;
                NSInteger row = i%2;
                
                NSDictionary *dic = classarr2[i];
                UIButton *courseview = [[UIButton alloc]initWithFrame:CGRectMake(15*SW +(15*SW + kW/2-22.5*SW)*row,10+163*SW*lin, kW/2-22.5*SW, 153*SW)];
                courseview.backgroundColor = ALLViewBgColor;
                courseview.tag = 62914+i;
                [courseview addTarget:self action:@selector(course1Action:) forControlEvents:UIControlEventTouchUpInside];
                [view1 addSubview:courseview];
                
                UIImageView *showview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, courseview.width, 100*SW)];
                NSURL *url = [NSURL URLWithString:[dic objectForKey:@"coursepic"]];
                [showview sd_setImageWithURL:url];
                [courseview addSubview:showview];
                
                UILabel *titlelb = [[UILabel alloc]initWithFrame:CGRectMake(5*SW, showview.maxY+10*SW, showview.width, 18*SW)];
                titlelb.text = [dic objectForKey:@"coursename"];
                titlelb.font = FONT(15);
                titlelb.textColor = TextNoColor;
                [courseview addSubview:titlelb];
                
                UIImageView * imgv = [[UIImageView alloc]initWithFrame:CGRectMake(5*SW, titlelb.maxY+5*SW, 10*SW, 10*SW)];
                imgv.image = [UIImage imageNamed:@"6_"];
                [courseview addSubview:imgv];
                
                UILabel *titlelb2 = [[UILabel alloc]initWithFrame:CGRectMake(20*SW, titlelb.maxY+2.5*SW, titlelb.width/3*2, 15*SW)];
                titlelb2.text = [NSString stringWithFormat:@"已有%ld人学习",[[dic objectForKey:@"study_count"]integerValue]] ;
                titlelb2.textColor = TextNoColor;
                titlelb2.font = FONT(13);
                [courseview addSubview:titlelb2];
                
                UILabel *titlelb3 = [[UILabel alloc]initWithFrame:CGRectMake(titlelb.maxX - 50*SW, titlelb.maxY, 40*SW, 15*SW)];
                titlelb3.textColor = [UIColor redColor];
                titlelb3.font = FONT(14);
                [courseview addSubview:titlelb3];
                if ([[dic objectForKey:@"type"]integerValue] == 1) {
                    titlelb3.text = @"免费";
                }else if([[dic objectForKey:@"type"]integerValue] == 2){
                    titlelb3.text = [NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"coursemoney"]doubleValue]];
                }
                if (i == classarr1.count - 1) {
                    view1.contentSize = CGSizeMake(0, courseview.maxY);
                }
            }
            [pageViews addObject:view1];
            
        }else{
            UIScrollView *view1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kW, self.view.frame.size.height-cursor.maxY)];
            view1.backgroundColor = [UIColor whiteColor];
            
            for (int i = 0; i<classarr3.count; i++) {
                NSInteger lin = i/2;
                NSInteger row = i%2;
                NSDictionary *dic = classarr3[i];
                UIButton *courseview = [[UIButton alloc]initWithFrame:CGRectMake(15*SW +(15*SW + kW/2-22.5*SW)*row,10+163*SW*lin, kW/2-22.5*SW, 153*SW)];
                courseview.backgroundColor = ALLViewBgColor;
                courseview.tag = 62915+i;
                [courseview addTarget:self action:@selector(course2Action:) forControlEvents:UIControlEventTouchUpInside];
                [view1 addSubview:courseview];
                
                UIImageView *showview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, courseview.width, 100*SW)];
                NSURL *url = [NSURL URLWithString:[dic objectForKey:@"coursepic"]];
                [showview sd_setImageWithURL:url];
                [courseview addSubview:showview];
                
                UILabel *titlelb = [[UILabel alloc]initWithFrame:CGRectMake(5*SW, showview.maxY+10*SW, showview.width, 18*SW)];
                titlelb.text = [dic objectForKey:@"coursename"];
                titlelb.font = FONT(15);
                titlelb.textColor = TextNoColor;
                [courseview addSubview:titlelb];
                
                UIImageView * imgv = [[UIImageView alloc]initWithFrame:CGRectMake(5*SW, titlelb.maxY+5*SW, 10*SW, 10*SW)];
                imgv.image = [UIImage imageNamed:@"6_"];
                [courseview addSubview:imgv];
                
                UILabel *titlelb2 = [[UILabel alloc]initWithFrame:CGRectMake(20*SW, titlelb.maxY+2.5*SW, titlelb.width/3*2, 15*SW)];
                titlelb2.text = [NSString stringWithFormat:@"已有%ld人学习",[[dic objectForKey:@"study_count"]integerValue]] ;
                titlelb2.textColor = TextNoColor;
                titlelb2.font = FONT(13);
                [courseview addSubview:titlelb2];
                
                UILabel *titlelb3 = [[UILabel alloc]initWithFrame:CGRectMake(titlelb.maxX - 50*SW, titlelb.maxY, 40*SW, 15*SW)];
                titlelb3.textColor = [UIColor redColor];
                titlelb3.font = FONT(14);
                [courseview addSubview:titlelb3];
                if ([[dic objectForKey:@"type"]integerValue] == 1) {
                    titlelb3.text = @"免费";
                }else if([[dic objectForKey:@"type"]integerValue] == 2){
                    titlelb3.text = [NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"coursemoney"]doubleValue]];
                }
                if (i == classarr1.count - 1) {
                    view1.contentSize = CGSizeMake(0, courseview.maxY);
                }
            }
            [pageViews addObject:view1];
            
        }
    }
    return pageViews;
}
-(void)courseAction:(UIButton *)sender{
    NSInteger i = sender.tag - 62913;
    NSDictionary *dic = classarr1[i];
    LiveAncientlyViewControllerViewController *vc = [[LiveAncientlyViewControllerViewController alloc]init];
    vc.Id =[dic objectForKey:@"courseid"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)course1Action:(UIButton *)sender{
    NSInteger i = sender.tag - 62914;
    NSDictionary *dic = classarr2[i];
    LiveAncientlyViewControllerViewController *vc = [[LiveAncientlyViewControllerViewController alloc]init];
    vc.Id =[dic objectForKey:@"courseid"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)course2Action:(UIButton *)sender{
    NSInteger i = sender.tag - 62915;
    NSDictionary *dic = classarr3[i];
    LiveAncientlyViewControllerViewController *vc = [[LiveAncientlyViewControllerViewController alloc]init];
    vc.Id =[dic objectForKey:@"courseid"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)getmainview{
    self.navigationItem.title = [NSString stringWithFormat:@"%@的直播间",[dic objectForKey:@"realname"]];
    
    scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -20, kW, self.view.height+20)];
    scrollview.backgroundColor = ALLViewBgColor;
    [self.view addSubview:scrollview];
    
    UIImageView *liveimgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kW, 180*SW)];
    NSURL *url = [NSURL URLWithString:[dic objectForKey:@"teacherurl"]];
    [liveimgview sd_setImageWithURL:url];
    [scrollview addSubview:liveimgview];

    
    
    UIView *infoview = [[UIView alloc]initWithFrame:CGRectMake(0, liveimgview.maxY, kW, 75*SW)];
    infoview.backgroundColor = [UIColor whiteColor];
    [scrollview addSubview:infoview];
    
    
    UIImageView *iconview = [[UIImageView alloc]initWithFrame:CGRectMake(12.5*SW, 7.5*SW, 60*SW, 60*SW)];
    iconview.layer.cornerRadius = 30*SW;
    iconview.layer.masksToBounds = YES;
    NSURL *url1 = [NSURL URLWithString:[dic objectForKey:@"iconurl"]];
    [iconview sd_setImageWithURL:url1];
    [infoview addSubview:iconview];
    
    UILabel *namelb1 = [[UILabel alloc]initWithFrame:CGRectMake(iconview.maxX+22.5*SW, 2.5*SW, 100*SW, 35*SW)];
    namelb1.text = [dic objectForKey:@"realname"];
    namelb1.font = FONT(14);
    [infoview addSubview:namelb1];
    
    
    UILabel *namelb2 = [[UILabel alloc]initWithFrame:CGRectMake(iconview.maxX+22.5*SW, 37.5*SW, 100*SW, 35*SW)];
    namelb2.text = [dic objectForKey:@"introduction"];
    namelb2.font = FONT(14);
    [infoview addSubview:namelb2];
    
    UIButton *admire = [[UIButton alloc]initWithFrame:CGRectMake(kW - 50*SW, 12.5*SW, 50*SW, 50*SW)];
    [admire setImage:[UIImage imageNamed:@"29_"] forState:UIControlStateNormal];
    [admire addTarget:self action:@selector(admireActon) forControlEvents:UIControlEventTouchUpInside];
    [infoview addSubview:admire];
}


-(void)menbanHide{
    [menbanview removeFromSuperview];
}
//点击了注册
-(void)registAction{

}
//点击了箭头
-(void)admireActon{

}

//点击了导航右边按钮
-(void)releaseInfo{
    
}
-(void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
