//
//  CordLoginViewController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/2/8.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "CordLoginViewController.h"
//#import "RegistViewController.h"
#import "MePageViewController.h"
#import <NIMSDK/NIMSDK.h>
@interface CordLoginViewController ()

@end

@implementation CordLoginViewController
{
    UITextField *textf;
    UITextField *pwdtextf;
    UIButton *grtcodebtn;
    NSTimer *timer;
    NSInteger countdown;
}

-(void)dealloc{
    [timer invalidate];
    timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"验证码登录";
    self.view.backgroundColor = ALLViewBgColor;
    UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [releaseButton setImage:[UIImage imageNamed:@"67_"] forState:normal];
    [releaseButton addTarget:self action:@selector(releaseInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;
    
    UIImageView *topimg = [[UIImageView alloc]initWithFrame:CGRectMake(kW/2 - 75*SW, 50*SW, 150*SW, 150*SW)];
    topimg.image = [UIImage imageNamed:@"250x250"];
    [self.view addSubview:topimg];
    
    UILabel *toplab = [[UILabel alloc]initWithFrame:CGRectMake(20*SW,topimg.maxY + 50*SW, 40*SW, 50*SW)];
    toplab.text = @"手机";
    toplab.font = TextFont;
    [self.view addSubview:toplab];
    
    textf = [[UITextField alloc]initWithFrame:CGRectMake(toplab.maxX +20*SW, topimg.maxY + 50*SW, kW - 90*SW, 50*SW)];
    textf.placeholder = @"请输入手机号";
    textf.font = TextFont;
    [self.view addSubview:textf];
    
    UIView *ln = [[UIView alloc]initWithFrame:CGRectMake(15*SW, textf.maxY-0.5, kW-30*SW, 1)];
    ln.backgroundColor = LnColor;
    [self.view addSubview:ln];
    
    UILabel *pwdlab = [[UILabel alloc]initWithFrame:CGRectMake(20*SW,toplab.maxY+10*SW , 55*SW, 50*SW)];
    pwdlab.text = @"验证码";
    pwdlab.font = TextFont;

    [self.view addSubview:pwdlab];
    
    pwdtextf = [[UITextField alloc]initWithFrame:CGRectMake(pwdlab.maxX +5*SW, toplab.maxY+10*SW, kW - 185*SW, 50*SW)];
    pwdtextf.placeholder = @"请输入验证码";
    pwdtextf.font = TextFont;
    [self.view addSubview:pwdtextf];
    UIView *ln1 = [[UIView alloc]initWithFrame:CGRectMake(15*SW, pwdtextf.maxY-0.5, kW-30*SW, 1)];
    ln1.backgroundColor = LnColor;
    [self.view addSubview:ln1];
    
    
    UIButton *codebtn = [[UIButton alloc]initWithFrame:CGRectMake(20*SW, ln1.maxY, 140*SW, 40*SW)];
    [codebtn addTarget:self action:@selector(codeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:codebtn];
    
    UILabel *codelab = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 140*SW, 40*SW)];
    codelab.text = @"手机密码登录";
    codelab.font = TextFont;
    codelab.textColor = NavAndBtnColor;
    [codebtn addSubview:codelab];
    
    grtcodebtn = [[UIButton alloc]initWithFrame:CGRectMake(kW - 120*SW, ln.maxY+20*SW, 110*SW, 30*SW)];
    [grtcodebtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [grtcodebtn setTitleColor:NavAndBtnColor forState:UIControlStateNormal];
    [grtcodebtn setTitleColor:TextColor forState:UIControlStateSelected];
    grtcodebtn.layer.cornerRadius = 5;
    grtcodebtn.layer.masksToBounds = YES;
    grtcodebtn.layer.borderWidth = 1;
    grtcodebtn.titleLabel.font = TextFont;
    grtcodebtn.layer.borderColor = [NavAndBtnColor CGColor];
    [grtcodebtn addTarget:self action:@selector(getcode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:grtcodebtn];
    

    
    UIButton *btn1 = [[UIButton alloc]init];
    btn1.frame = CGRectMake( 20*SW, codebtn.maxY +120*SW, kW-40*SW, 50*SW);
    btn1.backgroundColor = NavAndBtnColor;
    btn1.layer.cornerRadius = 5*SW;
    btn1.layer.masksToBounds = YES;
    [btn1 addTarget:self action:@selector(loginaction) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitle:@"登录" forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    
    UIButton *registtbtn = [[UIButton alloc]initWithFrame:CGRectMake(kW/2+20*SW,btn1.maxY,100*SW, 40*SW)];
        [registtbtn addTarget:self action:@selector(registaction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registtbtn];
    UILabel *regislab1 = [[UILabel alloc]initWithFrame:registtbtn.bounds];
    regislab1.textAlignment =0;
    regislab1.text = @"立即注册";
    regislab1.font = TextFont;
    regislab1.textColor = NavAndBtnColor;
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
    [self.view endEditing:YES];
}

-(void)releaseInfo{
    
}
-(void)registaction{
//    RegistViewController *vc = [[RegistViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
}
-(void)codeAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)loginaction{
    if (!textf.text.length) {
        return ShowError(@"请输入手机号");
    }
    if (!pwdtextf.text.length) {
        return ShowError(@"请输入验证码");
    }
    ShowHint(@"");
    [YJAPPNetwork LoginPwdWithPhonenum:textf.text code:pwdtextf.text success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
//            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            ShowSuccess(@"登陆成功");
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            [APPUserDataIofo writeAccessToken:[dic objectForKey:@"accesstoken"]];
            [APPUserDataIofo getUserID:[dic objectForKey:@"userid"]];
            [APPUserDataIofo getAccess:textf.text];

            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[MePageViewController class]]) {
                    MePageViewController *home =(MePageViewController *)controller;
                    [self.navigationController popToViewController:home animated:YES];
                }
            }
            
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        ShowError(netError);
    }];
}

-(void)getcode{
    if (!textf.text.length) {
        return ShowError(@"请输入手机号");
    }
    [YJAPPNetwork GetCodeLoginWithPhonenum:textf.text success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            [SVProgressHUD showSuccessWithStatus:@"获取成功"];
            grtcodebtn.selected = YES;
            grtcodebtn.layer.borderColor = [TextColor CGColor];
            grtcodebtn.userInteractionEnabled = NO;
            countdown = 60;

            [grtcodebtn setTitle:[NSString stringWithFormat:@"重新发送(%ld)",countdown] forState:UIControlStateNormal];
            timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(countdown) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];

        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        ShowError(netError);
    }];
}

-(void)countdown{
    countdown--;
    [grtcodebtn setTitle:[NSString stringWithFormat:@"重新发送(%ld)",countdown] forState:UIControlStateNormal];
    if (countdown == 0) {
        [timer invalidate];
        timer = nil;
        grtcodebtn.selected = NO;
        grtcodebtn.layer.borderColor = [NavAndBtnColor CGColor];
        grtcodebtn.userInteractionEnabled = YES;
        [grtcodebtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        countdown = 60;
        
    }
}
@end
