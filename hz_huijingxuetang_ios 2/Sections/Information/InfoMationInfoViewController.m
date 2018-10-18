//
//  InfoMationInfoViewController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/2/1.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "InfoMationInfoViewController.h"
#import "AppraiseTableViewCell.h"
#import "FSTextView.h"
#import <MJRefresh.h>
@interface InfoMationInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableview1;
@property(strong,nonatomic) UIView *bottomView;
@property(strong,nonatomic) UITextField *commentTextField;
@property(strong,nonatomic) UIButton *commentButton;

@end

@implementation InfoMationInfoViewController
{
    UIButton *menbanview;
    UIView *giftview;
    NSMutableArray *btnarr;
    UILabel*label4;
    UIView *cardview;
    NSMutableArray *imgarr;
    NSDictionary *datadic;
    NSArray *commentarr;
    FSTextView *textview;
    UIScrollView *scrollview;
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UIKeyboardWillShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UIKeyboardWillHideNotification" object:nil];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"咨询详情";
    self.view.backgroundColor = CWHITE;
    [self loadInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:@"UIKeyboardWillShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:@"UIKeyboardWillHideNotification" object:nil];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"13_"] style:UIBarButtonItemStylePlain target:self action:@selector(releaseInfo)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kW, kH - SafeAreaTopHeight - 45)];
    scrollview.backgroundColor = ALLViewBgColor;
    scrollview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadInfo)];
    [self.view addSubview:scrollview];
    // Do any additional setup after loading the view.
}

//右边按钮
-(void)releaseInfo{
    
}

-(void)loadInfo{
    [YJAPPNetwork NewslistInfowithCoureId:_Id success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            datadic = [NSDictionary dictionary];
            datadic = [responseObject objectForKey:@"data"];
            [self loadcomment];
            SVDismiss;
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
    }];
}

-(void)loadcomment{
    [YJAPPNetwork NewsCommentwithCoureId:_Id page:@"" success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            
            SVDismiss;
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            commentarr = [NSArray array];
            commentarr = [dic objectForKey:@"commentlist"];
            [self getmainview];
            [scrollview.mj_header endRefreshing];
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
    }];
}

-(void)getmainview{
    for (UIView *view in scrollview.subviews) {
        if (view != scrollview.mj_header) {
            [view removeFromSuperview];
        }
    }
    
    UILabel *toplabel = [[UILabel alloc]initWithFrame:CGRectMake(15*SW, 15*SW, kW-30*SW, 20*SW)];
    toplabel.text = [datadic objectForKey:@"infomationtitle"];
    toplabel.textColor = TextNoColor;
    [scrollview addSubview:toplabel];
    
    UILabel *toplabel1 = [[UILabel alloc]initWithFrame:CGRectMake(15*SW,toplabel.maxY+ 5*SW, kW-30*SW, 30*SW)];
    toplabel1.text = [NSString stringWithFormat:@"%@  %@   阅读：%ld",[datadic objectForKey:@"singname"],[datadic objectForKey:@"createtime"],[[datadic objectForKey:@"readcounts"]integerValue]];
    toplabel1.textColor = TextColor;
    toplabel1.font = TextsmlFont;
    [scrollview addSubview:toplabel1];
    
    
    NSString * infoString =[NSString stringWithFormat:@"%@",[datadic objectForKey:@"content"]];
    UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectMake(15*SW, toplabel1.maxY+35*SW, kW - 30*SW, 300*SW)];
    [scrollview addSubview:webView];
    
    [webView loadHTMLString:infoString baseURL:nil];
    
    UILabel *titleview = [[UILabel alloc]initWithFrame:CGRectMake(0, webView.maxY+15*SW, kW, 35*SW)];
    titleview.backgroundColor = ALLViewBgColor;
    titleview.text = @"评论";
    titleview.textAlignment = 1;
    titleview.textColor = NavAndBtnColor;
    [scrollview addSubview:titleview];
    
    UIView *ln1view = [[UIView alloc]initWithFrame:CGRectMake(titleview.width/2-20*SW,titleview.maxY-4*SW, 40*SW, 2*SW)];
    ln1view.backgroundColor = NavAndBtnColor;
    [scrollview addSubview:ln1view];
    
    _tableview1 = [[UITableView alloc]initWithFrame:CGRectMake(0, titleview.maxY, kW,commentarr.count*105)];
    _tableview1.dataSource = self;
    _tableview1.delegate = self;
    _tableview1.backgroundColor = ALLViewBgColor;
    _tableview1.backgroundColor = CWHITE;
    _tableview1.separatorStyle = 0;
    _tableview1.scrollEnabled = NO;
    [scrollview addSubview:_tableview1];
    scrollview.contentSize = CGSizeMake(0, _tableview1.maxY);
    //    添加手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    [self setupButtomView];
}

-(void)huifuAction:(UIButton *)sender{
    NSInteger index = sender.tag - 9138;
    NSDictionary *dic = commentarr[index];

    menbanview = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kW,kH)];
    menbanview.backgroundColor = RGBA(0, 0, 0, 0.5);
    [self.navigationController.view addSubview:menbanview];
    
    UIView *huifuview = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kW, 175*SW)];
    huifuview.backgroundColor = CWHITE;
    [menbanview addSubview:huifuview];
    
    textview = [[FSTextView alloc]initWithFrame:CGRectMake(15*SW, 15*SW, kW - 30*SW, 100*SW)];
    textview.layer.borderWidth = 1;
    textview.layer.borderColor = [NavAndBtnColor CGColor];
    textview.placeholder = [NSString stringWithFormat:@"@“%@”",[dic objectForKey:@"nickname"]];
    textview.maxLength = 100;
    textview.textColor = TextColor;
    [huifuview addSubview:textview];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(kW/2 - 118.5*SW,textview.maxY+12.5*SW, 100*SW, 40*SW)];
    button.layer.borderWidth = 1;
    button.layer.borderColor = [NavAndBtnColor CGColor];
    button.layer.cornerRadius = 3;
    button.layer.masksToBounds = YES;
    [button setTitleColor:NavAndBtnColor forState:UIControlStateNormal];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(menbanHide) forControlEvents:UIControlEventTouchUpInside];
    [huifuview addSubview:button];
    
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake( kW/2 +18.5*SW,textview.maxY+12.5*SW, 100*SW, 40*SW)];
    button1.layer.cornerRadius = 3;
    button1.layer.masksToBounds = YES;
    button1.backgroundColor = NavAndBtnColor;
    [button1 setTitleColor:CWHITE forState:UIControlStateNormal];
    [button1 setTitle:@"发送" forState:UIControlStateNormal];
    button1.tag = 94324+index;
    [button1 addTarget:self action:@selector(huifu:) forControlEvents:UIControlEventTouchUpInside];
    [huifuview addSubview:button1];
}

-(void)huifu:(UIButton *)sender{
    NSInteger index = sender.tag - 94324;
    NSString *accesstoken = [APPUserDataIofo AccessToken];
    NSDictionary *dic = commentarr[index];
    if (!textview.text.length) {
        return SVshowInfo(@"请输入回复内容");
    }
    [YJAPPNetwork CommentwithCoureinfoid:_Id accesstoken:accesstoken commid:[dic objectForKey:@"commentid"] content:textview.text success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            SVDismiss;
            //取消第一响应者
            [textview resignFirstResponder];
            [menbanview removeFromSuperview];
            [self loadcomment];
        }else{
            if (code == 10) {
                [menbanview removeFromSuperview];
            }
            [ConventionJudge NetCode:code vc:self type:@"3"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
        
    }];
}

-(void)menbanHide{
    [self.view endEditing:YES];
    [menbanview removeFromSuperview];
}

#pragma mark --UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return commentarr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AppraiseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"appcell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([AppraiseTableViewCell class]) owner:self options:nil]objectAtIndex:0];
    }
    cell.star1.hidden = YES;
    cell.star2.hidden = YES;
    cell.star3.hidden = YES;
    cell.star4.hidden = YES;
    cell.star5.hidden = YES;
    cell.huifubtn.hidden = NO;
    NSDictionary *dic = commentarr[indexPath .section];
    NSURL *url = [NSURL URLWithString:[dic objectForKey:@"iconurl"]];
    [cell.iconimg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cell.timelb.text = [dic objectForKey:@"createtime"];
    cell.conlb.text = [dic objectForKey:@"commentcontent"];
    cell.conlb.font = FONT(15);
    cell.namelb.text = [dic objectForKey:@"nickname"];
    cell.timelb.font = TextsmlFont;
    cell.namelb.font = FONT(15);
    cell.timelb.textColor = TextNoColor;
    [cell.huifubtn setTitleColor:boderColor forState:UIControlStateNormal];
    cell.huifubtn.tag = 1567+indexPath.section;
    cell.huifubtn.layer.cornerRadius = 5*SW;
    cell.huifubtn.layer.masksToBounds = YES;
    cell.huifubtn.layer.borderWidth = 1;
    cell.huifubtn.layer.borderColor = [LnColor CGColor];
    cell.huifubtn.tag = 9138+indexPath.section;
    [cell.huifubtn addTarget:self action:@selector(huifuAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = commentarr[indexPath .section];
    NSString *con = [dic objectForKey:@"commentcontent"];
    CGFloat H = [UILabel getHeightByWidth:kW - 95 title:con font:FONT(15)];
    
    return 91+H;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}
//键盘的布局
- (void)setupButtomView{
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 45, CGRectGetWidth(self.view.frame), 45)];
    self.bottomView.backgroundColor = ALLViewBgColor;
    [self.view addSubview:self.bottomView];

    //添加textfield
    self.commentTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, self.view.frame.size.width - 100, 35)];
    self.commentTextField.backgroundColor = [UIColor whiteColor];
    self.commentTextField.layer.cornerRadius = 5;
    self.commentTextField.placeholder = @" 单行输入";
    [self.bottomView addSubview:self.commentTextField];
    //textField遵循协议
    self.commentTextField.delegate = self;
    //添加button
    self.commentButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.commentButton.frame = CGRectMake(self.view.frame.size.width - 80, 5, 70, 35);
    self.commentButton.backgroundColor = NavAndBtnColor;
    [self.commentButton setTitleColor:CWHITE forState:UIControlStateNormal];
    self.commentButton.layer.cornerRadius = 5;
    [self.commentButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.commentButton addTarget:self action:@selector(commentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.commentButton];
    //关闭button的用户交互
    self.commentButton.userInteractionEnabled = YES;
}




//键盘即将出现的时候
- (void)keyboardWillShow:(NSNotification *)sender{
    
    self.bottomView.hidden = NO;
    
    //    获取键盘的高度
    NSDictionary *userInfo = [sender userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    self.bottomView.transform = CGAffineTransformMakeTranslation(0, -height);
    
}

//键盘即将消失的时候
- (void)keyboardWillHidden:(NSNotification *)sender{
    self.bottomView.transform = CGAffineTransformIdentity;
}

-(void)keyboardHide{
    [self.commentTextField resignFirstResponder];
}
//发送按钮的回调方法
- (void)commentButtonAction:(UIButton *)sender{
    if (!self.commentTextField.text.length) {
        return SVshowInfo(@"请输入评论内容");
    }
    NSString *accesstoken = [APPUserDataIofo AccessToken];
//    commenttext = self.commentTextField.text;
    [YJAPPNetwork CommentwithCoureinfoid:_Id accesstoken:accesstoken commid:@"" content:_commentTextField.text success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            SVDismiss;
            self.commentTextField.text = @"";
            //取消第一响应者
            [self.commentTextField resignFirstResponder];
            [self loadcomment];
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
        
    }];
}
@end
