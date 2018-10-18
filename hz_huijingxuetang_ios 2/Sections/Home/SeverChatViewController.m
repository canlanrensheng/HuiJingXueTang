//
//  SeverChatViewController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/2/27.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "SeverChatViewController.h"
#import "MeTableViewCell.h"
#import "ReceiveTableViewCell.h"
@interface SeverChatViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(strong,nonatomic) UIView *bottomView;
@property(strong,nonatomic) UITextField *commentTextField;
@property(strong,nonatomic) UIButton *commentButton;
@end

@implementation SeverChatViewController
{
    UITableView *tableview;
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UIKeyboardWillShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UIKeyboardWillHideNotification" object:nil];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"客服服务";
    tableview  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kW, self.view.height - 64-45)];
    tableview.dataSource = self;
    tableview.delegate = self;
    [self.view addSubview:tableview];
    tableview.separatorStyle = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:@"UIKeyboardWillShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:@"UIKeyboardWillHideNotification" object:nil];
    [self setupButtomView];
}

//键盘的布局
- (void)setupButtomView{
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 45-64, CGRectGetWidth(self.view.frame), 45)];
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
    self.commentButton.userInteractionEnabled = NO;
    
    //    添加手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

//发送按钮的回调方法
- (void)commentButtonAction:(UIButton *)sender{
    
    //    commenttext = self.commentTextField.text;
    //取消第一响应者
    [self.commentTextField resignFirstResponder];
    
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *receiveID = @"receivecell";
    static NSString *sendID = @"sendcell";

    if (indexPath.row == 1) {
        MeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sendID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([MeTableViewCell class]) owner:self options:nil]objectAtIndex:0];
        }
        cell.iconimg.image = [UIImage imageNamed:@"客服服务_07"];
        cell.selectionStyle = 0;
        cell.chatlable.text = @"怎么申请退款";
        return cell;
    }else{
        ReceiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:receiveID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([ReceiveTableViewCell class]) owner:self options:nil]objectAtIndex:0];
        }
        cell.selectionStyle = 0;
        cell.iconimg.image = [UIImage imageNamed:@"客服服务_03"];
        cell.chatlable.text = @"亲有什么问题吗？";
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80*SW;
}
@end
