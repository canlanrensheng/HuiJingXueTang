//
//  LoginViewController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/2/8.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "LoginViewController.h"
#import "CordLoginViewController.h"
#import "ForgetPWDViewController.h"
#import "RegistViewController.h"
#import <NIMSDK/NIMSDK.h>

static NSString *UserName = @"UserName";

@interface LoginViewController ()

@end

@implementation LoginViewController
{
    UITextField *textf;
    UITextField *pwdtextf;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    // 隐藏tabbar
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登录";
    self.view.backgroundColor = ALLViewBgColor;
    
    
    UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [releaseButton setImage:[UIImage imageNamed:@"67_"] forState:normal];
    [releaseButton addTarget:self action:@selector(releaseInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"back_n"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"back_p"] forState:UIControlStateHighlighted];
    
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(-20, 0, 25, 40);
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
    
    UIImageView *topimg = [[UIImageView alloc]initWithFrame:CGRectMake(kW/2 - 75*SW, 50*SW, 150*SW, 150*SW)];
    topimg.image = [UIImage imageNamed:@"250x250"];
    [self.view addSubview:topimg];
    
    UILabel *toplab = [[UILabel alloc]initWithFrame:CGRectMake(20*SW,topimg.maxY + 50*SW, 40*SW, 50*SW)];
    toplab.text = @"手机";
    toplab.font = TextFont;
    [self.view addSubview:toplab];
    
    textf = [[UITextField alloc]initWithFrame:CGRectMake(toplab.maxX +10*SW, topimg.maxY + 50*SW, kW - 90*SW, 50*SW)];
    textf.placeholder = @"请输入手机号";
    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:UserName];
    if (UserName.length){
        textf.text = phone;
    }
    textf.clearButtonMode = UITextFieldViewModeWhileEditing;
    textf.font = TextFont;
    [self.view addSubview:textf];
    
    UIView *ln = [[UIView alloc]initWithFrame:CGRectMake(15*SW, textf.maxY-0.5, kW-30*SW, 1)];
    ln.backgroundColor = LnColor;
    [self.view addSubview:ln];
    
    UILabel *pwdlab = [[UILabel alloc]initWithFrame:CGRectMake(20*SW,toplab.maxY , 40*SW, 50*SW)];
    pwdlab.text = @"密码";
    pwdlab.font = TextFont;
    [self.view addSubview:pwdlab];
    
    pwdtextf = [[UITextField alloc]initWithFrame:CGRectMake(pwdlab.maxX +10*SW, toplab.maxY, kW - 90*SW, 50*SW)];
    pwdtextf.placeholder = @"请输入密码";
    pwdtextf.secureTextEntry = YES;
    pwdtextf.font = TextFont;
    pwdtextf.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:pwdtextf];
    UIView *ln1 = [[UIView alloc]initWithFrame:CGRectMake(15*SW, pwdtextf.maxY-0.5, kW-30*SW, 1)];
    ln1.backgroundColor = LnColor;
    [self.view addSubview:ln1];
    
    
    UIButton *codebtn = [[UIButton alloc]initWithFrame:CGRectMake(20*SW, ln1.maxY, 140*SW, 40*SW)];
    [codebtn addTarget:self action:@selector(codeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:codebtn];
    
    UILabel *codelab = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 140*SW, 40*SW)];
    codelab.text = @"手机验证码登录";
    codelab.font = TextFont;
    codelab.textColor = NavAndBtnColor;
    [codebtn addSubview:codelab];
    
    UIButton *forgetbtn = [[UIButton alloc]initWithFrame:CGRectMake(textf.maxX - 100*SW, ln1.maxY, 100*SW, 40*SW)];
    [forgetbtn addTarget:self action:@selector(forgetAction) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:forgetbtn];
    
    UILabel *forgetlab = [[UILabel alloc]initWithFrame:CGRectMake(0,0,100*SW, 40*SW)];
    forgetlab.textAlignment =2;
    forgetlab.text = @"忘记密码？";
    forgetlab.font = TextFont;

    [forgetbtn addSubview:forgetlab];
    
    UIButton *btn1 = [[UIButton alloc]init];
    btn1.frame = CGRectMake( 20*SW, forgetbtn.maxY +120*SW, kW-40*SW, 50*SW);
    btn1.backgroundColor = NavAndBtnColor;
    btn1.layer.cornerRadius = 5*SW;
    btn1.layer.masksToBounds = YES;
    [btn1 addTarget:self action:@selector(loginaction) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitle:@"登录" forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    
    UIButton *registtbtn = [[UIButton alloc]initWithFrame:CGRectMake(kW/2+20*SW,btn1.maxY,100*SW, 40*SW)];
    [self.view addSubview:registtbtn];
    UILabel *regislab1 = [[UILabel alloc]initWithFrame:registtbtn.bounds];
    regislab1.textAlignment =0;
    regislab1.text = @"立即注册";
    regislab1.font = TextFont;
    regislab1.textColor= NavAndBtnColor;
    [registtbtn addTarget:self action:@selector(registaction) forControlEvents:UIControlEventTouchUpInside];

    [registtbtn addSubview:regislab1];
    
    UILabel *regislab = [[UILabel alloc]initWithFrame:CGRectMake(kW/2-80*SW,btn1.maxY,100*SW, 40*SW)];
    regislab.textAlignment =2;
    regislab.text = @"还没有账号？";
    regislab.font = TextFont;
    
    [self.view addSubview:regislab];
    
    //添加手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}



-(void)keyboardHide{
    [textf endEditing:YES];
    [pwdtextf endEditing:YES];
}

-(void)registaction{
    RegistViewController *vc = [[RegistViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)forgetAction{
    ForgetPWDViewController *vc = [[ForgetPWDViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)releaseInfo{
    
}

-(void)codeAction{
    CordLoginViewController *vc = [[CordLoginViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)loginaction{
    if (!textf.text.length) {
        return SVshowInfo(@"请输入手机号");
    }
    if (!pwdtextf.text.length) {
        return SVshowInfo(@"请输入密码");
    }
    [YJAPPNetwork LoginPwdWithPhonenum:textf.text code:pwdtextf.text success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            [[NSUserDefaults standardUserDefaults] setObject:textf.text forKey:UserName];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [APPUserDataIofo writeAccessToken:[dic objectForKey:@"accesstoken"]];
            [APPUserDataIofo getUserID:[dic objectForKey:@"userid"]];

            [self.navigationController popViewControllerAnimated:YES];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        SVshowInfo(netError);
    }];
}

-(void)backBtnClicked{
    if ([self.type integerValue] == 2) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"back" object:self];
        [self.navigationController popViewControllerAnimated:YES];

    }else if([self.type integerValue] == 1){
        NSInteger count = self.navigationController.viewControllers.count - 3;
        UIViewController *viewCtl = self.navigationController.viewControllers[count];
        
        //    ZYLog(@"[viewCtl class] %@",[viewCtl class]);
        [self.navigationController popToViewController:viewCtl animated:YES];
        
        
        for(int i = 0; i < self.navigationController.viewControllers.count; i++)
        {
            NSLog(@"%d,[vcHome class] %@",i,[self.navigationController.viewControllers[i] class]);
        }

    }else{
        [self.navigationController popViewControllerAnimated:YES];

    }
}
@end
