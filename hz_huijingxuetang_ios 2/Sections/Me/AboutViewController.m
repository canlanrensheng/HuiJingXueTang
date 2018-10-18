//
//  AboutViewController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/2/6.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "AboutViewController.h"
#import "DiscoverInfoViewController.h"
@interface AboutViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation AboutViewController
{
    NSArray *titlearr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于我们";
    self.view.backgroundColor = ALLViewBgColor;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kW, 200*SW)];
    view.backgroundColor = CWHITE;
    [self.view addSubview:view];
    
    UIImageView *topimg = [[UIImageView alloc]initWithFrame:CGRectMake(kW/2 - 75*SW, 30*SW, 150*SW, 150*SW)];
    topimg.image = [UIImage imageNamed:@"250x250"];
    [view addSubview:topimg];
    
    UIView *ln = [[UIView alloc]initWithFrame:CGRectMake(0, 200*SW-0.5, kW, 0.5)];
    ln.backgroundColor = LnColor;
    [view addSubview:ln];
    
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, topimg.maxY, kW, 44*3*SW-1)];
    tableview.dataSource = self;
    tableview.delegate = self;
    tableview.scrollEnabled = NO;
    [self.view addSubview:tableview];
    titlearr = @[@"服务协议",@"监督投诉",@"给我们鼓励"];
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, kH- SafeAreaTopHeight - 40*SW, kW, 40*SW)];
    label.text = @"杭州慧鲸科技有限公司";
    label.textAlignment = 1;
    label.textColor = TextColor;
    label.font = FONT(13);
    [self.view addSubview:label];
    
}


#pragma mark --<UITabBarDelegate,UITableViewDataSource>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.textLabel.text = titlearr[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44*SW;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        DiscoverInfoViewController *vc = [[DiscoverInfoViewController alloc]init];
        vc.name = @"服务协议";
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"本公司承诺不代客理财、不推荐股票、不承诺收益、如有发现违反上述规定、请拨打监督电话和投诉电话%@",self.phone] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"本公司承诺不代客理财、不推荐股票、不承诺收益、如有发现违反上述规定、请拨打监督电话和投诉电话%@",self.phone] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
@end
