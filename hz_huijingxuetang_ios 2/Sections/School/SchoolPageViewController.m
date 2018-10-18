

//
//  SchoolPageViewController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/1/15.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "SchoolPageViewController.h"
#import "SchoolTableViewCell.h"
#import "ClassInfoViewController.h"
#import "ScreenViewController.h"
#import "shoppingCartViewController.h"
#import <MJRefresh.h>
@interface SchoolPageViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@end

@implementation SchoolPageViewController
{
    UIView *bottonln;
    UIScrollView *scrollview;
    UITableView *tableview1;
    UITableView *tableview2;
    NSMutableArray *selarr;
    NSMutableArray *selarr1;
    NSMutableArray *dataarr1;
    NSMutableArray *dataarr2;
    NSString * _page;
    NSString *peopleunm;
    NSString *evaluate;
    NSString *type;
    NSString *teacherid;
    NSString *price;
    NSString *coursetype;
    NSInteger page1;
    NSInteger totalpage1;
    NSInteger page2;
    NSInteger totalpage2;
    NSInteger nowpage1;
    NSMutableDictionary *listdic;

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];


}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loaddatawithCourseType:@"3" num:peopleunm evaluate:evaluate teacherid:teacherid type:type price:price];
    [self loaddatawithCourseType:@"4" num:@"" evaluate:@"" teacherid:@"" type:@"" price:@""];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    selarr1 = [ NSMutableArray array];
    peopleunm =@"";
    evaluate = @"";
    _page = @"3";
    teacherid = @"";
    price = @"";
    type = @"";
    nowpage1 = 1;
    [self getnav];
    // Do any additional setup after loading the view.
}

-(void)loaddatawithCourseType:(NSString *)Coursetype num:(NSString *)num evaluate:(NSString *)evaluate teacherid:(NSString *)teacherid type:(NSString*)type price:(NSString *)price{
    NSString *pagestr;

    if ([Coursetype integerValue] == 3) {
        [tableview1.mj_footer setState:1];

        page1 = 1;
        pagestr = [NSString stringWithFormat:@"%ld",page1];
    }else{
        [tableview2.mj_footer setState:1];

        page2 = 1;
        pagestr = [NSString stringWithFormat:@"%ld",page2];
    }

    [YJAPPNetwork GetClassTaskWithAccesstoken:[APPUserDataIofo AccessToken] coursetype:Coursetype num:num evaluate:evaluate teacherid:teacherid type:type price:price page:pagestr success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];

        if (code == 200) {
            SVDismiss;
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            if ([Coursetype integerValue] == 3) {
                totalpage1 = [[dic objectForKey:@"totalpage"] integerValue];
                if (totalpage1<2) {
                    tableview1.mj_footer.hidden = YES;
                }
            }else{
                totalpage2 = [[dic objectForKey:@"totalpage"] integerValue];
                if (totalpage2<2) {
                    tableview2.mj_footer.hidden = YES;
                }
            }
 
            listdic = [NSMutableDictionary dictionary];
            [listdic setObject:[dic objectForKey:@"teacherlist"] forKey:@"teacherlist"];
//            [listdic setObject:[dic objectForKey:@"type"] forKey:@"type"];
//            [listdic setObject:[dic objectForKey:@"price"] forKey:@"price"];

            if ([Coursetype isEqualToString:@"3"]) {
                coursetype = @"3";
//                NSArray *arr= [dic objectForKey:@"courselist"];
                dataarr1 = [NSMutableArray array];
                dataarr1 = [dic objectForKey:@"courselist"];
                [tableview1 reloadData];
                [tableview1.mj_header endRefreshing];

            }else{
                coursetype = @"4";
                dataarr2 = [NSMutableArray array];
                dataarr2 = [dic objectForKey:@"courselist"];
                [tableview2 reloadData];
                [tableview2.mj_header endRefreshing];
            }

        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
            [tableview1.mj_header endRefreshing];
            [tableview2.mj_header endRefreshing];


        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
        [tableview1.mj_header endRefreshing];
        [tableview2.mj_header endRefreshing];
    }];

}

-(void)loadMoredata1{
    NSString *pagestr;
    if ([coursetype isEqualToString:@"3"]) {
        if (totalpage1 == 0||page1 == totalpage1) {
            [tableview1.mj_footer setState:MJRefreshStateNoMoreData];
            return;
        }else{
            page1++;
        }
        pagestr = [NSString stringWithFormat:@"%ld",page1];

    }else{
        if (totalpage2 == 0||page2 == totalpage2) {
            [tableview2.mj_footer setState:MJRefreshStateNoMoreData];
            return;
        }else{
            page2++;
        }
        pagestr = [NSString stringWithFormat:@"%ld",page2];
    }

    [YJAPPNetwork GetClassTaskWithAccesstoken:[APPUserDataIofo AccessToken] coursetype:coursetype num:peopleunm evaluate:evaluate teacherid:teacherid type:type price:price page:pagestr success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            NSArray *arr = [NSArray array];
            arr = [NSArray arrayWithArray:[dic objectForKey:@"courselist"]];
            if ([coursetype integerValue]==3) {
                nowpage1 = [[dic objectForKey:@"totalpage"] integerValue];
                [dataarr1 addObjectsFromArray:arr];
                [tableview1 reloadData];
                [tableview1.mj_footer endRefreshing];
            }else{
                [dataarr2 addObjectsFromArray:arr];
                [tableview2 reloadData];
                [tableview2.mj_footer endRefreshing];
            }
            SVDismiss;
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }

    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
        [tableview1.mj_footer endRefreshing];
        [tableview2.mj_footer endRefreshing];

    }];
}

-(void)getnav{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kW, SafeAreaTopHeight)];
    view.backgroundColor = NavAndBtnColor;
    [self.view addSubview:view];
    
    NSInteger btny = 25.5+SafeAreaTopHeight - 64;
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(kW/2-100*SW, btny, 90*SW, 25)];
    [btn1 setTitle:@"精品课程" forState:UIControlStateNormal];
    btn1.titleLabel.font = FONT(15);
    [btn1 setTitleColor:WColor forState:UIControlStateNormal];
    btn1.tag = 400;
    [btn1 addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(kW/2+10*SW, btny, 90*SW, 25)];
    [btn2 setTitle:@"私教课" forState:UIControlStateNormal];
    btn2.titleLabel.font = FONT(15);
    [btn2 setTitleColor:WColor forState:UIControlStateNormal];
    btn2.tag = 400+1;
    [btn2 addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn2];
    
    bottonln = [[UIView alloc]initWithFrame:CGRectMake(btn1.maxX - btn1.width/2 - 75/2, btn1.maxY+6.5, 75, 2.5)];
    bottonln.backgroundColor = WColor;
    [view addSubview:bottonln];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(kW - 35, 25.5, 25, 25)];
    [btn setImage:[UIImage imageNamed:@"cart"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cartAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, kW, self.view.height-64-44)];
    
    scrollview.contentSize = CGSizeMake(kW*2, 0);
    scrollview.pagingEnabled = YES;
    scrollview.delegate = self;
    [scrollview setShowsHorizontalScrollIndicator:NO];
    scrollview.bounces = NO;
    [self.view addSubview:scrollview];
    
    [self getleftview];
    [self getrightview];
}


-(void)getleftview{
    UIView *leftview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, scrollview.frame.size.width, scrollview.frame.size.height)];
    leftview.backgroundColor = ALLViewBgColor;
    [scrollview addSubview:leftview];
    selarr = [NSMutableArray array];
    NSArray *bentitarr = @[@"购买人数",@"课程好评",@"  筛选"];
    for (int i = 0 ; i < 3; i++) {
        UIButton *topbtnview = [[UIButton alloc]initWithFrame:CGRectMake(0+kW/3*i, 0, kW/3, 50*SW)];
        topbtnview.backgroundColor = WColor;
        [topbtnview setTitle:bentitarr[i] forState:UIControlStateNormal];
        [topbtnview setTitleColor:TextNoColor forState:UIControlStateNormal];
        topbtnview.tag = 1923+i;
        [topbtnview addTarget:self action:@selector(topAction:) forControlEvents:UIControlEventTouchUpInside];
        [leftview addSubview:topbtnview];

        if (i==2) {
            [topbtnview setImage:[UIImage imageNamed:@"50_"] forState:UIControlStateNormal];
        }else{
            UIImageView *btnimg = [[UIImageView alloc]initWithFrame:CGRectMake(topbtnview.width - 15*SW, topbtnview.height/2 - 3*SW, 10*SW, 6*SW)];
            btnimg.image = [UIImage imageNamed:@"49_"];
            btnimg.highlightedImage = [UIImage imageNamed:@"image100_"];
            [topbtnview addSubview:btnimg];
            btnimg.tag = 18310 +i;
            [selarr addObject:btnimg];
        }
    }
    
    tableview1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 50*SW, kW, scrollview.height - 50*SW)];
    tableview1.dataSource = self;
    tableview1.delegate = self;
    tableview1.backgroundColor = ALLViewBgColor;
    tableview1.separatorStyle = 0;
    __weak typeof(self) seakself = self;
    tableview1.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [seakself loaddatawithCourseType:@"3" num:peopleunm evaluate:evaluate teacherid:teacherid type:type price:price];
    }];
    tableview1.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoredata1)];
    [leftview addSubview:tableview1];
    
}
-(void)topAction:(UIButton *)sender{
    if (sender.tag - 1923 == 2) {
        ScreenViewController *vc = [[ScreenViewController alloc]init];
        vc.datadic = listdic;
        vc.teacherid = teacherid;
        vc.price  = price;
        vc.type = type;

        vc.Block = ^(NSString *type1, NSString *Id) {
            if (![type1 isEqualToString:@""]) {
                if ([type1 isEqualToString:@"teacher"]) {
                    teacherid = Id;
                    type = @"";
                    price = @"";
                }else if([type1 isEqualToString:@"type"]){
                    teacherid = @"";
                    type = Id;
                    price = @"";
                }else if([type1 isEqualToString:@"price"]){
                    teacherid = @"";
                    type = @"";
                    price = Id;
                }
            }else{
                teacherid = @"";
                type = @"";
                price = @"";
            }
            [self loaddatawithCourseType:_page num:peopleunm evaluate:evaluate teacherid:teacherid type:type price:price];
        };
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    }else{
        BOOL isHl = NO;
        for (UIImageView *img  in selarr) {
            if (sender.tag - 1923 == img.tag - 18310) {
                if (img.highlighted == YES) {
                    isHl = YES;
                    img.image = [UIImage imageNamed:@"image101_"];
                    img.highlighted = NO;

                }else{
                    img.highlightedImage = [UIImage imageNamed:@"image100_"];
                    img.highlighted = YES;
                    isHl = NO;
                }
            }else{
                img.highlighted = NO;
                img.image = [UIImage imageNamed:@"49_"];

            }
        }
        if (sender.tag - 1923 == 0) {
            if (isHl) {
                peopleunm = @"asc";
            }else{
                peopleunm = @"desc";
            }
            evaluate = @"";
        }else{
            if (isHl) {
                evaluate = @"asc";
            }else{
                evaluate = @"desc";
            }
            peopleunm = @"";
        }

        [self loaddatawithCourseType:_page num:peopleunm evaluate:evaluate teacherid:teacherid type:type price:price];
    }
}

-(void)getrightview{
    UIView *rightview = [[UIView alloc]initWithFrame:CGRectMake(scrollview.frame.size.width, 0, scrollview.frame.size.width, scrollview.frame.size.height)];
    rightview.backgroundColor = [UIColor redColor];
    [scrollview addSubview:rightview];
    
    tableview2 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kW, scrollview.height)];
    tableview2.dataSource = self;
    tableview2.delegate = self;
    tableview2.backgroundColor = ALLViewBgColor;
    tableview2.separatorStyle = 0;
    __weak typeof(self) seakself = self;
    tableview2.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [seakself loaddatawithCourseType:@"4" num:@"" evaluate:@"" teacherid:@"" type:@"" price:@""];
    }];
    tableview2.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoredata1)];
    [rightview addSubview:tableview2];
}


-(void)cartAction{
    shoppingCartViewController *vc = [[shoppingCartViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)pageAction:(UIButton *)btn{
    if (btn.tag - 400 == 1) {
        _page = @"4";
        [UIView animateWithDuration:0.5 animations:^{
            scrollview.contentOffset = CGPointMake(kW, 0);
            bottonln.transform = CGAffineTransformMakeTranslation(90*SW+20*SW, 0);
        }];
    }else{
        _page = @"3";
        [UIView animateWithDuration:0.5 animations:^{
            scrollview.contentOffset = CGPointMake(0, 0);
            bottonln.transform = CGAffineTransformIdentity;
        }];
    }
}
-(void)selAction:(UIButton *)sender{
    NSDictionary *dic = dataarr1[sender.tag - 1237];
    NSString *accesstoken = [APPUserDataIofo AccessToken];
    NSString *ID = [dic objectForKey:@"courseid"];
    if ([accesstoken isEqualToString:@""]) {
        SVshowInfo(@"请前往登录");
    }
    [YJAPPNetwork zanwithAccesstoken:accesstoken Id:ID success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            SVDismiss;
            [self loaddatawithCourseType:_page num:peopleunm evaluate:evaluate teacherid:@"" type:@"" price:@""];
        }else{
            [ConventionJudge NetCode:code vc:self type:@"3"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
    }];

}
-(void)sel2Action:(UIButton *)sender{
    NSDictionary *dic = dataarr2[sender.tag - 1238];
    NSString *accesstoken = [APPUserDataIofo AccessToken];
    NSString *ID = [dic objectForKey:@"courseid"];

    [YJAPPNetwork zanwithAccesstoken:accesstoken Id:ID success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            SVDismiss;
            [self loaddatawithCourseType:_page num:peopleunm evaluate:evaluate teacherid:teacherid type:type price:price];
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
    }];
    
}

-(void)shopcart1Action:(UIButton *)sender{
    NSInteger index = sender.tag - 61238;
    NSDictionary *dic  = dataarr1[index];
    [self addshopcart:[dic objectForKey:@"courseid"]];
}

-(void)shopcart2Action:(UIButton *)sender{
    NSInteger index = sender.tag - 61239;
    NSDictionary *dic  = dataarr2[index];
    [self addshopcart:[dic objectForKey:@"courseid"]];
}
-(void)addshopcart:(NSString *)Id{
    [YJAPPNetwork shoppingCartWithAccesstoken:[APPUserDataIofo AccessToken] courseid:Id success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            [SVProgressHUD showSuccessWithStatus:@"已加入购物车"];
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
    }];
}
#pragma mark -- UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == tableview1) {
        return dataarr1.count;
    }else{
        return dataarr2.count;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SchoolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"schoolcell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([SchoolTableViewCell class]) owner:self options:nil]objectAtIndex:0];
    }
    cell.pricelb.font = FONT(15);
    cell.pricelb.textColor = NavAndBtnColor;
    if (tableView == tableview1) {
        NSDictionary *dic = dataarr1[indexPath.section];
        NSURL *imgurl =[NSURL URLWithString:[dic objectForKey:@"coursepic"]] ;
        [cell.imgview sd_setImageWithURL:imgurl];
        cell.num.text = [NSString stringWithFormat:@"%ld",[[dic objectForKey:@"browsingcount"]integerValue]];
        if ([[dic objectForKey:@"courselimit"]integerValue] == 1) {
            cell.isfreelb.hidden = NO;
            cell.shopcartbtn.hidden = YES;
            cell.pricelb.hidden = YES;
        }else{
            cell.isfreelb.hidden = YES;
            cell.shopcartbtn.hidden = NO;
            cell.pricelb.hidden = NO;
        }
        cell.pricelb.text = [NSString stringWithFormat:@"￥%.1f",[[dic objectForKey:@"coursemoney"]doubleValue]];
        cell.shopcartbtn.tag = 61238+indexPath.section;
        [cell.shopcartbtn addTarget:self action:@selector(shopcart1Action:) forControlEvents:UIControlEventTouchUpInside];
        cell.coursename.text = [dic objectForKey:@"coursename"];
        [cell.zanbtn setTitle:[NSString stringWithFormat:@"  %ld",[[dic objectForKey:@"thumbsupcount"]integerValue]] forState:UIControlStateNormal];
        [cell.zanbtn setTitle:[NSString stringWithFormat:@"  %ld",[[dic objectForKey:@"thumbsupcount"]integerValue]] forState:UIControlStateSelected];
        [cell.zanbtn setTitleColor:TextNoColor forState:UIControlStateNormal];
        [cell.zanbtn setTitleColor:TextNoColor forState:UIControlStateSelected];
        cell.zanbtn.titleLabel.font = FONT(13);
        if ([[dic objectForKey:@"praise"] isEqualToString:@"n"]) {
            cell.zanbtn.selected = NO;
            cell.zanbtn.userInteractionEnabled = YES;
        }else{
            cell.zanbtn.selected = YES;
            cell.zanbtn.userInteractionEnabled = NO;
        }
        cell.zanbtn.tag = 1237+indexPath.section;
        [cell.zanbtn addTarget:self action:@selector(selAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;

    }else{
        NSDictionary *dic = dataarr2[indexPath.section];
        NSURL *imgurl =[NSURL URLWithString:[dic objectForKey:@"coursepic"]] ;
        [cell.imgview sd_setImageWithURL:imgurl];
        cell.num.text = [NSString stringWithFormat:@"%ld",[[dic objectForKey:@"browsingcount"]integerValue]];
        if ([[dic objectForKey:@"courselimit"]integerValue] == 1) {
            cell.isfreelb.hidden = NO;
            cell.shopcartbtn.hidden = YES;
            cell.pricelb.hidden = YES;

        }else{
            cell.isfreelb.hidden = YES;
            cell.shopcartbtn.hidden = NO;
            cell.pricelb.hidden = NO;
        }
        cell.pricelb.text = [NSString stringWithFormat:@"￥%.1f",[[dic objectForKey:@"coursemoney"]doubleValue]];

        cell.shopcartbtn.tag = 61239+indexPath.section;
        [cell.shopcartbtn addTarget:self action:@selector(shopcart2Action:) forControlEvents:UIControlEventTouchUpInside];
        cell.coursename.text = [dic objectForKey:@"coursename"];
        [cell.zanbtn setTitleColor:TextNoColor forState:UIControlStateNormal];
        [cell.zanbtn setTitleColor:TextNoColor forState:UIControlStateSelected];

        cell.zanbtn.titleLabel.font = FONT(13);
        [cell.zanbtn setTitle:[NSString stringWithFormat:@"  %ld",[[dic objectForKey:@"thumbsupcount"]integerValue]] forState:UIControlStateNormal];
        [cell.zanbtn setTitle:[NSString stringWithFormat:@"  %ld",[[dic objectForKey:@"thumbsupcount"]integerValue]] forState:UIControlStateSelected];
        if ([[dic objectForKey:@"praise"] isEqualToString:@"n"]) {
            cell.zanbtn.selected = NO;
            cell.zanbtn.userInteractionEnabled = YES;
        }else{
            cell.zanbtn.selected = YES;
            cell.zanbtn.userInteractionEnabled = NO;
        }
        cell.zanbtn.tag = 1238+indexPath.section;
        [cell.zanbtn addTarget:self action:@selector(sel2Action:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 250*SW;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ClassInfoViewController* civc = [[ClassInfoViewController alloc]init];
    NSDictionary *dic;
    if (tableView == tableview1) {
        dic = dataarr1[indexPath.section];
    }else{
        dic = dataarr2[indexPath.section];
    }
    civc.courseId = [dic objectForKey:@"courseid"];

    [self.navigationController pushViewController:civc animated:YES];

}
#pragma mark -- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == scrollview) {
        CGFloat pageWith = scrollView.frame.size.width;
        int page = floor((scrollView.contentOffset.x - pageWith/2)/pageWith)+1;
        if (page == 1) {
            _page = @"4";
            [UIView animateWithDuration:0.5 animations:^{
                bottonln.transform = CGAffineTransformMakeTranslation(90*SW+20*SW, 0);
            }];
        }else{
            _page = @"3";
            [UIView animateWithDuration:0.5 animations:^{
                bottonln.transform = CGAffineTransformIdentity;
            }];
        }
    }
}

@end
