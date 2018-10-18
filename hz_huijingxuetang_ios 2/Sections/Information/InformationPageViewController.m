//
//  InformationPageViewController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/1/15.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "InformationPageViewController.h"
#import "HACursor.h"
#import "InfoMationTableViewCell.h"
#import "InfoMationInfoViewController.h"
#import "SeverChatViewController.h"
#import <MJRefresh.h>
@interface InformationPageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) UITableView *tableview1;
@property (nonatomic, strong) UITableView *tableview2;
@property (nonatomic, strong) UITableView *tableview3;
@property (nonatomic, strong) UITableView *tableview4;
@property (nonatomic, strong) UITableView *tableview5;

@end

@implementation InformationPageViewController
{
    HACursor*cursor;
    NSArray *toparr;
    NSArray *dataarr1;
    NSArray *dataarr2;
    NSArray *dataarr3;
    NSArray *dataarr4;
    NSArray *dataarr5;


}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navH.constant = SafeAreaTopHeight;
    _navview.backgroundColor = NavAndBtnColor;
    [self loadTopInfo];
    
}

-(void)loadTopInfo{
    [YJAPPNetwork InformationTopsuccess:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            toparr = [NSArray array];
            toparr = [responseObject objectForKey:@"data"];
            [self pageview];
            SVDismiss;
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
        
    }];
}

-(void)pageview{
    
    _titleArray=[[NSMutableArray alloc]init];
    NSInteger k = 0;
    for (NSDictionary *dic in toparr) {
        k++;
        [_titleArray addObject:[dic objectForKey:@"name"]];
        [self loadNewwithid:[dic objectForKey:@"id"] index:k];
    }
    
    
//    [_titleArray addObject:@"要闻"];
//    [_titleArray addObject:@"滚动"];
//    [_titleArray addObject:@"机会"];
//    [_titleArray addObject:@"公司"];
//    [_titleArray addObject:@"更多"];
    
    cursor = [[HACursor alloc]init];
    cursor.itemTitleBtnWidth=kW/toparr.count;
    cursor.frame = CGRectMake(0, SafeAreaTopHeight, kW, 40);
    cursor.scrollNavBar.linecoler = NavAndBtnColor;
    cursor.titles =_titleArray;
    cursor.pageViews = [self createPageViews];
    cursor.backgroundColor= ALLViewBgColor;
    //设置根滚动视图的高度
    cursor.rootScrollViewHeight = kH -45-SafeAreaTopHeight-44;
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

-(void)loadNewwithid:(NSString *)Id index:(NSInteger )index{
    [YJAPPNetwork NewslistwithCoureId:Id page:@"" success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            if (index == 1) {
                dataarr1 = [NSArray array];
                dataarr1 = [dic objectForKey:@"newslist"];
                [_tableview1.mj_header endRefreshing];
                [_tableview1 reloadData];
            }else if (index == 2){
                dataarr2 = [NSArray array];
                dataarr2 = [dic objectForKey:@"newslist"];
                [_tableview2.mj_header endRefreshing];
                [_tableview2 reloadData];

            }else if (index == 3){
                dataarr3 = [NSArray array];
                dataarr3 = [dic objectForKey:@"newslist"];
                [_tableview3.mj_header endRefreshing];

                [_tableview3 reloadData];

            }else if (index == 4){
                dataarr4 = [NSArray array];
                dataarr4 = [dic objectForKey:@"newslist"];
                [_tableview4.mj_header endRefreshing];

                [_tableview4 reloadData];

            }else if (index == 5){
                dataarr5 = [NSArray array];
                dataarr5 = [dic objectForKey:@"newslist"];
                [_tableview5.mj_header endRefreshing];
                [_tableview5 reloadData];
            }
            SVDismiss;
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
        
    }];
}


- (NSMutableArray *)createPageViews{
    
    NSMutableArray *pageViews = [NSMutableArray array];
    for (NSInteger i = 0; i <_titleArray.count; i++)
    {
        NSDictionary *dic = toparr[i];
        __weak typeof(self) weakself = self;

        if (i==0) {
            UIView*view1 = [[UIView alloc]init];
            view1.backgroundColor = ALLViewBgColor;
            _tableview1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kW,self.view.height -SafeAreaTopHeight-40-44)];
            _tableview1.dataSource = self;
            _tableview1.delegate = self;
            _tableview1.backgroundColor = ALLViewBgColor;
            _tableview1.separatorStyle = 0;
            _tableview1.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [weakself loadNewwithid:[dic objectForKey:@"id"] index:i+1];
            }];
            [view1 addSubview:_tableview1];
            [pageViews addObject:view1];
            
        }else if(i==1){
            UIView *view2 = [[UIView alloc]init];
            view2.backgroundColor = ALLViewBgColor;
            _tableview2 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kW,self.view.height -SafeAreaTopHeight-40-44)];
            _tableview2.dataSource = self;
            _tableview2.delegate = self;
            _tableview2.backgroundColor = ALLViewBgColor;
            _tableview2.separatorStyle = 0;
            _tableview2.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [weakself loadNewwithid:[dic objectForKey:@"id"] index:i+1];
            }];
            [view2 addSubview:_tableview2];
            [pageViews addObject:view2];
        }else if(i==2){
            UIView *view3 = [[UIView alloc]init];
            view3.backgroundColor = ALLViewBgColor;
            _tableview3 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kW,self.view.height -SafeAreaTopHeight-40-44)];
            _tableview3.dataSource = self;
            _tableview3.delegate = self;
            _tableview3.backgroundColor = ALLViewBgColor;
            _tableview3.separatorStyle = 0;
            _tableview3.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [weakself loadNewwithid:[dic objectForKey:@"id"] index:i+1];
            }];
            [view3 addSubview:_tableview3];
            [pageViews addObject:view3];
        }else if(i==3){
            UIView *view4 = [[UIView alloc]init];
            view4.backgroundColor = ALLViewBgColor;
            _tableview4 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kW,self.view.height -SafeAreaTopHeight-40-44)];
            _tableview4.dataSource = self;
            _tableview4.delegate = self;
            _tableview4.backgroundColor = ALLViewBgColor;
            _tableview4.separatorStyle = 0;
            _tableview4.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [weakself loadNewwithid:[dic objectForKey:@"id"] index:i+1];
            }];
            [view4 addSubview:_tableview4];
            [pageViews addObject:view4];
        }else if(i==4){
            UIView *view5 = [[UIView alloc]init];
            view5.backgroundColor = ALLViewBgColor;
            _tableview5 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kW,self.view.height -SafeAreaTopHeight-40-44)];
            _tableview5.dataSource = self;
            _tableview5.delegate = self;
            _tableview5.backgroundColor = ALLViewBgColor;
            _tableview5.separatorStyle = 0;
            _tableview5.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [weakself loadNewwithid:[dic objectForKey:@"id"] index:i+1];
            }];
            [view5 addSubview:_tableview5];
            [pageViews addObject:view5];
        }
    }
    return pageViews;
}
- (IBAction)severAction:(id)sender {
    SeverChatViewController *vc = [[SeverChatViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark --UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _tableview1) {
        return dataarr1.count;
    }else if(tableView == _tableview2){
        return dataarr2.count;

    }else if(tableView == _tableview3){
        return dataarr3.count;

    }else if(tableView == _tableview4){
        return dataarr4.count;

    }else{
        return dataarr5.count;

    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InfoMationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infocell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([InfoMationTableViewCell class]) owner:self options:nil]objectAtIndex:0];
    }
    NSDictionary *dic;
    if (tableView == _tableview1) {
        dic = dataarr1[indexPath.section];
    }else if (tableView == _tableview2){
        dic = dataarr2[indexPath.section];
    }else if (tableView == _tableview3){
        dic = dataarr3[indexPath.section];
    }else if (tableView == _tableview4){
        dic = dataarr4[indexPath.section];
    }else if (tableView == _tableview5){
        dic = dataarr5[indexPath.section];
    }
    cell.title.text = [dic objectForKey:@"infomationtitle"];
    cell.timelable.text = [NSString stringWithFormat:@"%@    %ld评论",[dic objectForKey:@"createtime"],[[dic objectForKey:@"readcounts"]integerValue]];
    NSURL *url = [NSURL URLWithString:[dic objectForKey:@"picurl"]];
    [cell.imgview sd_setImageWithURL:url];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic;
    if (tableView == _tableview1) {
        dic = dataarr1[indexPath.section];
    }else if (tableView == _tableview2){
        dic = dataarr2[indexPath.section];
    }else if (tableView == _tableview3){
        dic = dataarr3[indexPath.section];
    }else if (tableView == _tableview4){
        dic = dataarr4[indexPath.section];
    }else if (tableView == _tableview5){
        dic = dataarr5[indexPath.section];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    InfoMationInfoViewController *vc = [[InfoMationInfoViewController alloc]init];
    vc.Id = [dic objectForKey:@"id"];
    [self.navigationController pushViewController:vc animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
}
@end
