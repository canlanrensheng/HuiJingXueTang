//
//  ForlbViewController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/1/23.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "ForlbViewController.h"
#import "SeverChatViewController.h"
@interface ForlbViewController ()

@end

@implementation ForlbViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kW/2 - kW/4, 180*SW, self.view.width/2, 45*SW)];
    label.text = @"如果你无法简洁的表达你的意思，说明你还不够了解她。";
    label.font = FONT(17);
    label.textAlignment = 1;
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
    CGSize constraint =CGSizeMake(kW/2,50*SW);
    //该方法iOS7.0以后已更新
    CGSize size = [label.text sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    //其实UILineBreakModeWordWrap和NSLineBreakByWordWrapping是一个意思
    //根据文字重设label的宽高，x y随意
    [label setFrame:CGRectMake(kW/2 - kW/4, 180+64*SW, size.width, size.height)];
    [self.view addSubview:label];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)severAction:(id)sender {
    SeverChatViewController *vc = [[SeverChatViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)popbtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
