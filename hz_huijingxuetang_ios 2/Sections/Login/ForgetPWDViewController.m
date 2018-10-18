//
//  ForgetPWDViewController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/2/8.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "ForgetPWDViewController.h"

@interface ForgetPWDViewController ()

@end

@implementation ForgetPWDViewController
{
    UITextField *textf;
    UITextField *pwdtextf;
    UITextField *cordtextf;
    UIButton *grtcodebtn;
    NSTimer *timer;
    NSInteger countdown;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)dealloc{
    [timer invalidate];
    timer = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"忘记密码";
    self.view.backgroundColor = ALLViewBgColor;
    UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [releaseButton setImage:[UIImage imageNamed:@"67_"] forState:normal];
    [releaseButton addTarget:self action:@selector(releaseInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;
    
 
    
    UILabel *toplab = [[UILabel alloc]initWithFrame:CGRectMake(20*SW,20*SW, 40*SW, 50*SW)];
    toplab.text = @"手机";
    toplab.font = TextFont;
    [self.view addSubview:toplab];
    
    textf = [[UITextField alloc]initWithFrame:CGRectMake(toplab.maxX +20*SW,20*SW, kW - 90*SW, 50*SW)];
    textf.placeholder = @"请输入手机号";
    textf.font = TextFont;
    [self.view addSubview:textf];
    
    
    
    UIView *ln = [[UIView alloc]initWithFrame:CGRectMake(15*SW, textf.maxY-0.5, kW-30*SW, 1)];
    ln.backgroundColor = LnColor;
    [self.view addSubview:ln];
    
    
    UILabel *cordlab = [[UILabel alloc]initWithFrame:CGRectMake(20*SW,toplab.maxY+10*SW , 55*SW, 50*SW)];
    cordlab.text = @"验证码";
    cordlab.font = TextFont;
    [self.view addSubview:cordlab];
    
    cordtextf = [[UITextField alloc]initWithFrame:CGRectMake(cordlab.maxX +5*SW, toplab.maxY+10*SW, kW - 185*SW, 50*SW)];
    cordtextf.placeholder = @"请输入验证码";
    cordtextf.font = TextFont;
    [self.view addSubview:cordtextf];
    
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
    
    UIView *ln1 = [[UIView alloc]initWithFrame:CGRectMake(15*SW, cordtextf.maxY-0.5, kW-30*SW, 1)];
    ln1.backgroundColor = LnColor;
    [self.view addSubview:ln1];
    
    UILabel *pwdlab = [[UILabel alloc]initWithFrame:CGRectMake(20*SW,cordlab.maxY +10*SW, 40*SW, 50*SW)];
    pwdlab.text = @"密码";
    pwdlab.font = TextFont;
    [self.view addSubview:pwdlab];
    
    pwdtextf = [[UITextField alloc]initWithFrame:CGRectMake(pwdlab.maxX +20*SW, cordlab.maxY+10*SW, kW - 90*SW, 50*SW)];
    pwdtextf.placeholder = @"请输入6位以上密码";
    pwdtextf.secureTextEntry = YES;
    pwdtextf.font = TextFont;
    [self.view addSubview:pwdtextf];
    
    UIButton *changbtn = [[UIButton alloc]initWithFrame:CGRectMake(kW - 60*SW, ln1.maxY+10*SW, 50*SW, 50*SW)];
    [changbtn setImage:[UIImage imageNamed:@"53_"] forState:UIControlStateNormal];
    [changbtn setImage:[UIImage imageNamed:@"52_"] forState:UIControlStateSelected];

    [self.view addSubview:changbtn];
    
    
    
    UIView *ln3 = [[UIView alloc]initWithFrame:CGRectMake(15*SW, pwdtextf.maxY-0.5, kW-30*SW, 1)];
    ln3.backgroundColor = LnColor;
    [self.view addSubview:ln3];
    
  

    
    UIButton *btn1 = [[UIButton alloc]init];
    btn1.frame = CGRectMake( 20*SW, ln3.maxY +74*SW, kW-40*SW, 50*SW);
    btn1.backgroundColor = NavAndBtnColor;
    btn1.layer.cornerRadius = 5*SW;
    btn1.layer.masksToBounds = YES;
    [btn1 addTarget:self action:@selector(pwdaction) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitle:@"重置密码" forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    
    UIButton *registtbtn = [[UIButton alloc]initWithFrame:CGRectMake(kW/2,btn1.maxY,100*SW, 40*SW)];
    [self.view addSubview:registtbtn];

    
}
-(void)pwdaction{
    if (!textf.text.length) {
        return SVshowInfo(@"请输入手机号");
    }
    if (!pwdtextf.text.length) {
        return SVshowInfo(@"请输入密码");
    }
    if (!cordtextf.text.length) {
        return SVshowInfo(@"请输入验证码");
    }
    [YJAPPNetwork ForgetPWDWithPhonenum:textf.text code:cordtextf.text pwd:pwdtextf.text rpwd:pwdtextf.text success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            [SVProgressHUD showSuccessWithStatus:@"重置成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        SVshowInfo(netError);
    }];
}

-(void)releaseInfo{
    
}


-(void)getcode{
    if (!textf.text.length) {
        return SVshowInfo(@"请输入手机号");
    }
    [YJAPPNetwork GetCodeForgetWithPhonenum:textf.text success:^(NSDictionary *responseObject) {
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
        SVshowInfo(netError);
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
