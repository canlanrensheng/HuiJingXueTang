//
//  MyCardViewController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/2/6.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "MyCardViewController.h"
#import "HACursor.h"
#import "MeCardTableViewCell.h"

@interface MyCardViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) UITableView *tableview1;
@property (nonatomic, strong) UITableView *tableview2;

@end

@implementation MyCardViewController
{
    HACursor*cursor;
    NSArray *dataarr1;
    NSArray *dataarr2;
    NSInteger page1;
    NSInteger page2;
    NSString *totalPage1;
    NSString *totalPage2;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的卡券";
    self.view.backgroundColor = ALLViewBgColor;
    [self pageview];
    [self loaddata:@"1"];
    
    
}

-(void)loaddata:(NSString *)type{

    [YJAPPNetwork MycardWithAccessToken:[APPUserDataIofo AccessToken] type:type success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            if ([type integerValue]==1) {
                dataarr1 = [NSArray array];
                dataarr1 = [responseObject objectForKey:@"data"];
                [_tableview1 reloadData];
                [self loaddata:@"2"];
            }else{
                dataarr2 = [NSArray array];
                dataarr2 = [responseObject objectForKey:@"data"];
                [_tableview2 reloadData];

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
    [_titleArray addObject:@"体验券"];
    [_titleArray addObject:@"代金券"];

    cursor = [[HACursor alloc]init];
    cursor.itemTitleBtnWidth=kW/2;
    cursor.frame = CGRectMake(0, 0, kW, 45);
    cursor.scrollNavBar.linecoler = NavAndBtnColor;
    cursor.titles =_titleArray;
    cursor.pageViews = [self createPageViews];
    cursor.backgroundColor= CWHITE;
    //设置根滚动视图的高度
    cursor.rootScrollViewHeight = kH -45-64;
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
            _tableview1 = [[UITableView alloc]init];
//            _tableview1.frame = CGRectMake(0, 0, kW, self.view.frame.size.height-64);
            _tableview1.delegate = self;
            _tableview1.dataSource = self;
            _tableview1.separatorStyle = UITableViewCellSeparatorStyleNone;
            _tableview1.backgroundColor = CWHITE;

            [pageViews addObject:_tableview1];

        }else if(i==1){
            _tableview2 = [[UITableView alloc]init];
//            _tableview2.frame = CGRectMake(0, 0, kW, self.view.frame.size.height-64);
            _tableview2.delegate = self;
            _tableview2.dataSource = self;
            _tableview2.separatorStyle = UITableViewCellSeparatorStyleNone;
            _tableview2.backgroundColor = CWHITE;
            [pageViews addObject:_tableview2];

        }
    }
    return pageViews;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ( tableView == _tableview1) {
        return  dataarr1.count;
    }else{
        return  dataarr2.count;

    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MeCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mecardcell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([MeCardTableViewCell class]) owner:self options:nil]objectAtIndex:0];
    }
    NSDictionary *dic;
    if (tableView == _tableview1) {
        dic = dataarr1[indexPath.section];
    }else{
        dic = dataarr2[indexPath.section];
    }
    cell.btn.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.btn.layer.borderColor = [NavAndBtnColor CGColor];
    cell.btn.layer.borderWidth = 0.5;
    cell.btn.layer.cornerRadius = 5;
    cell.btn.layer.masksToBounds = YES;
    cell.timelb.font = TextsmlFont;
    cell.datelab.font = TextsmlFont;
    cell.cardname.text = [dic objectForKey:@"cpname"];
    cell.datelab.text = [NSString stringWithFormat:@"服务期限：%@天",[dic objectForKey:@"validity"]];
    cell.timelb.text = [NSString stringWithFormat:@"有效期至：%@",[dic objectForKey:@"expire"]];
    cell.rplb.text = [NSString stringWithFormat:@"%ld元",[[dic objectForKey:@"price"]integerValue]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
@end
