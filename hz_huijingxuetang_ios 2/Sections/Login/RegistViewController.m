//
//  RegistViewController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/2/8.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "RegistViewController.h"
#import "DiscoverInfoViewController.h"
@interface RegistViewController ()

@end

@implementation RegistViewController
{
    UITextField *textf;
    UITextField *pwdtextf;
    UITextField *invitetextf;
    UITextField *cordtextf;
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
    self.navigationItem.title = @"注册";
    self.view.backgroundColor = ALLViewBgColor;
    UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [releaseButton setImage:[UIImage imageNamed:@"67_"] forState:normal];
    [releaseButton addTarget:self action:@selector(releaseInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;
    
    UIImageView *topimg = [[UIImageView alloc]initWithFrame:CGRectMake(kW/2 - 75*SW, 50*SW, 150*SW, 150*SW)];
    topimg.image = [UIImage imageNamed:@"250x250"];
    [self.view addSubview:topimg];
    
    UILabel *toplab = [[UILabel alloc]initWithFrame:CGRectMake(20*SW,topimg.maxY+ 50*SW, 40*SW, 50*SW)];
    toplab.text = @"手机";
    toplab.font = TextFont;
    [self.view addSubview:toplab];
    
    textf = [[UITextField alloc]initWithFrame:CGRectMake(toplab.maxX +20*SW,topimg.maxY+ 50*SW, kW - 90*SW, 50*SW)];
    textf.placeholder = @"请输入手机号";
    textf.font = TextFont;
    textf.keyboardType = UIKeyboardTypeNumberPad;
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
    cordtextf.keyboardType = UIKeyboardTypeAlphabet;
    cordtextf.font = TextFont;
    [self.view addSubview:cordtextf];
    
    grtcodebtn = [[UIButton alloc]initWithFrame:CGRectMake(kW - 120*SW, ln.maxY+20*SW, 110*SW, 30*SW)];
    [grtcodebtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [grtcodebtn setTitleColor:NavAndBtnColor forState:UIControlStateNormal];
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
    pwdtextf.font = TextFont;
    pwdtextf.secureTextEntry = YES;
    cordtextf.keyboardType = UIKeyboardTypeAlphabet;
    [self.view addSubview:pwdtextf];
    
    UILabel *invitelab = [[UILabel alloc]initWithFrame:CGRectMake(20*SW,pwdtextf.maxY +10*SW, 55*SW, 50*SW)];
    invitelab.text = @"邀请码";
    invitelab.font = TextFont;
    [self.view addSubview:invitelab];
    
    invitetextf = [[UITextField alloc]initWithFrame:CGRectMake(invitelab.maxX +5*SW, pwdtextf.maxY+10*SW, kW - 90*SW, 50*SW)];
    invitetextf.placeholder = @"邀请码（选填）";
    invitetextf.font = TextFont;
    [self.view addSubview:invitetextf];
    
    UIView *ln2 = [[UIView alloc]initWithFrame:CGRectMake(15*SW, pwdtextf.maxY-0.5, kW-30*SW, 1)];
    ln2.backgroundColor = LnColor;
    [self.view addSubview:ln2];
    
    UIView *ln3 = [[UIView alloc]initWithFrame:CGRectMake(15*SW, invitelab.maxY-0.5, kW-30*SW, 1)];
    ln3.backgroundColor = LnColor;
    [self.view addSubview:ln3];
    
    
    UIButton *treatybtn = [[UIButton alloc]initWithFrame:CGRectMake(kW/2+20*SW,ln3.maxY+20*SW,100*SW, 40*SW)];
    [treatybtn addTarget:self action:@selector(treatybtnaction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:treatybtn];
    
    UILabel *treatylab1 = [[UILabel alloc]initWithFrame:treatybtn.bounds];
    treatylab1.textAlignment =0;
    treatylab1.text = @"APP使用协议";
    treatylab1.font = TextFont;
    treatylab1.textColor = NavAndBtnColor;
    [treatybtn addSubview:treatylab1];
    
    UILabel *treatylab = [[UILabel alloc]initWithFrame:CGRectMake(kW/2-100*SW,ln3.maxY+20*SW,120*SW, 40*SW)];
    treatylab.textAlignment =2;
    treatylab.text = @"我同意并遵守，";
    treatylab.font = TextFont;
    [self.view addSubview:treatylab];
    
    UIButton *agreebtn = [[UIButton alloc]initWithFrame:CGRectMake(treatylab.minX - 20*SW, ln3.maxY+20*SW, 40*SW, 40*SW)];
    [agreebtn addTarget:self action:@selector(agreebtnaction:) forControlEvents:UIControlEventTouchUpInside];

    [agreebtn setImage:[UIImage imageNamed:@"51_"] forState:UIControlStateNormal];
    [agreebtn setImage:[UIImage imageNamed:@"54_"] forState:UIControlStateSelected];
    [self.view addSubview:agreebtn];
    
    UIButton *btn1 = [[UIButton alloc]init];
    btn1.frame = CGRectMake( 40*SW, ln3.maxY +74*SW, kW-80*SW, 50*SW);
    btn1.backgroundColor = NavAndBtnColor;
    btn1.layer.cornerRadius = 5*SW;
    btn1.layer.masksToBounds = YES;
    [btn1 addTarget:self action:@selector(pwdaction) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitle:@"注册" forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    

    
    UIButton *registtbtn = [[UIButton alloc]initWithFrame:CGRectMake(kW/2,btn1.maxY,100*SW, 40*SW)];
    [registtbtn addTarget:self action:@selector(registaction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registtbtn];
    UILabel *regislab1 = [[UILabel alloc]initWithFrame:registtbtn.bounds];
    regislab1.textAlignment =0;
    regislab1.text = @"去登录";
    regislab1.font = TextFont;
    regislab1.textColor = NavAndBtnColor;
    [registtbtn addSubview:regislab1];
    
    UILabel *regislab = [[UILabel alloc]initWithFrame:CGRectMake(kW/2-100*SW,btn1.maxY,100*SW, 40*SW)];
    regislab.textAlignment =2;
    regislab.text = @"已有账号，";
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
//注册
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
    NSString *incode;
    if (!invitetextf.text.length) {
        incode = @"";
    }else{
        incode = invitetextf.text;

    }
    
    [YJAPPNetwork registWithPhonenum:textf.text pwd:pwdtextf.text code:cordtextf.text incode:incode success:^(NSDictionary *responseObject) {
        NSString *msg = [responseObject objectForKey:@"msg"];
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            [self.navigationController popViewControllerAnimated:YES];

            [SVProgressHUD showSuccessWithStatus:@"注册成功"];

            
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        SVshowInfo(netError);
    }];
}

-(void)releaseInfo{
    
}

-(void)agreebtnaction:(UIButton *)sender{
    sender.selected = !sender.selected;
}

//去登录
-(void)registaction{
    [self.navigationController popViewControllerAnimated:YES];
}




-(void)getcode{
    if (!textf.text.length) {
        return SVshowInfo(@"请输入手机号");
    }
    [YJAPPNetwork GetCodeWithPhonenum:textf.text success:^(NSDictionary *responseObject) {
        NSString *msg = [responseObject objectForKey:@"msg"];
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            
            [SVProgressHUD showSuccessWithStatus:@"成功获取验证码"];
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
//使用协议
-(void)treatybtnaction{
    DiscoverInfoViewController *vc = [[DiscoverInfoViewController alloc]init];
    vc.name = @"服务协议";
    [self.navigationController pushViewController:vc animated:YES];
}
@end
