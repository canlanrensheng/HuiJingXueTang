//
//  LoginViewController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/2/8.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "LoginViewController.h"
#import <NIMSDK/NIMSDK.h>

static NSString *UserName = @"UserName";

@interface LoginViewController ()

@property (nonatomic,strong) UIButton *closeButton;
@property (nonatomic,strong) UILabel *loginLabel;
@property (nonatomic,strong) UITextField *phoneTf;
@property (nonatomic,strong) UIButton *codeBtn;

@end

@implementation LoginViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CGFLOAT_MIN * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
}

- (void)hj_configSubViews {
    //关闭按钮
    _closeButton = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"关闭",MediumFont(font(13)),white_color,0);
        [button setImage:V_IMAGE(@"close") forState:UIControlStateNormal];
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self backBtnClicked];
        }];
    }];
    [self.view addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kStatusBarHeight + kHeight(15));
        make.left.equalTo(self.view).offset(kWidth(10));
        make.width.height.mas_equalTo(CGSizeMake(kWidth(15), kWidth(15)));
    }];
    
    //登陆文本
    self.loginLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"登录/注册",MediumFont(font(25)),[UIColor colorWithHexString:@"#333333"]);
        label.numberOfLines = 0;
    }];
    [self.view addSubview:self.loginLabel];
    [self.loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kWidth(10));
        make.top.offset(kHeight(79));
    }];
    
    //电话号码的文本输入
    self.phoneTf =  ({
        UITextField *tmpTF = [[UITextField alloc] init];
        tmpTF.font = MediumFont(font(15));
        tmpTF.textColor = [UIColor colorWithHexString:@"#333333"];
        tmpTF.borderStyle = UITextBorderStyleNone;
        tmpTF.placeholder = @"手机号";
        tmpTF.keyboardType = UIKeyboardTypeNumberPad;
        tmpTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        tmpTF;
    });
    [self.view addSubview:self.phoneTf];
    [self.phoneTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kWidth(10));
        make.right.equalTo(self.view).offset(-kWidth(10));
        make.height.mas_equalTo(kHeight(40));
        make.top.equalTo(self.loginLabel.mas_bottom).offset(kHeight(80));
    }];
    
    //分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EAEAEA"];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.phoneTf);
        make.top.equalTo(self.phoneTf.mas_bottom);
        make.height.mas_equalTo(kHeight(0.5));
    }];
    
    
    //获取验证码
    _codeBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"获取验证码",MediumFont(font(13)),white_color,0);
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self getCode];
        }];
    }];

    _codeBtn.layer.shadowColor = [UIColor colorWithRed:34/255.0 green:71/255.0 blue:107/255.0 alpha:0.25].CGColor;
    _codeBtn.layer.shadowOffset = CGSizeMake(0,kHeight(8.0));
    _codeBtn.layer.shadowOpacity = 1;
    _codeBtn.layer.shadowRadius = kHeight(15.0);
    _codeBtn.layer.cornerRadius = kHeight(5.0);
    _codeBtn.clipsToBounds = YES;

    @weakify(self);
    [self.phoneTf.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
//        @strongify(self);
        if (x.length >= 11) {
            if (x.length > 11) {
                self.phoneTf.text = [x substringWithRange:NSMakeRange(0, 11)];
            }
            [_codeBtn setBackgroundColor:[UIColor colorWithRed:34/255.0 green:71/255.0 blue:107/255.0 alpha:1]];
            _codeBtn.userInteractionEnabled = YES;
        } else {
            [_codeBtn setBackgroundColor:[UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1]];
            _codeBtn.userInteractionEnabled = NO;
        }
    }];
    
    [self.view addSubview:_codeBtn];
    [_codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(kHeight(30));
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(kWidth(Screen_Width - kWidth(20.0)));
        make.height.mas_equalTo(kHeight(40.0));
    }];
    
    
    // 密码登陆
    UIButton *forgetPasswordBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"密码登录",MediumFont(font(13)),HEXColor(@"#1D3043"),0);
//        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//            @strongify(self);
            
            // 验证码登陆
            [DCURLRouter pushURLString:@"route://passwordLoginVC" animated:YES];
        }];
    }];
    [self.view addSubview:forgetPasswordBtn];
    [forgetPasswordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_codeBtn.mas_bottom).offset(kHeight(25));
        make.right.equalTo(_codeBtn);
        make.height.mas_equalTo(kHeight(13));
    }];

    //登陆注册协议
    UILabel *loginProtolLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"登录注册即代表您已经同意",MediumFont(font(11)),[UIColor colorWithHexString:@"#333333"]);
    }];
    [self.view addSubview:loginProtolLabel];
    [loginProtolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(forgetPasswordBtn.mas_bottom).offset(kHeight(19));
        make.height.mas_equalTo(kHeight(11));
        make.centerX.equalTo(self.view).offset(-kWidth(50));
    }];

    //协议按钮
    UIButton *protolBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"《慧鲸学堂用户协议条款》",MediumFont(font(11)),HEXColor(@"#1D3043"),0);
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);

        }];
    }];
    [self.view addSubview:protolBtn];
    [protolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(loginProtolLabel);
        make.centerY.equalTo(loginProtolLabel);
        make.left.equalTo(loginProtolLabel.mas_right);
    }];
}

- (void)getCode{
//    if (!self.phoneTf.text.length) {
//        return SVshowInfo(@"请输入手机号");
//    }
//    if (![self.phoneTf.text validateMobile]){
//        return SVshowInfo(@"手机号码格式错误");
//    }
    NSDictionary *paraDict = @{@"phone":self.phoneTf.text};
    [DCURLRouter pushURLString:@"route://inputCodeVC" query:paraDict animated:YES];
}

//- (void)viewDidLoad {
//    [super viewDidLoad];
////    self.navigationItem.title = @"登录";
//    self.view.backgroundColor = white_color;
//    
//    
//    UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [releaseButton setImage:[UIImage imageNamed:@"67_"] forState:normal];
//    [releaseButton addTarget:self action:@selector(releaseInfo) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
//    self.navigationItem.rightBarButtonItem = releaseButtonItem;
//    
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backBtn setImage:[UIImage imageNamed:@"back_n"] forState:UIControlStateNormal];
//    [backBtn setImage:[UIImage imageNamed:@"back_p"] forState:UIControlStateHighlighted];
//    
//    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    backBtn.frame = CGRectMake(-20, 0, 25, 40);
//    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = item;
//    
//    
//    UIImageView *topimg = [[UIImageView alloc]initWithFrame:CGRectMake(kW/2 - 75*SW, 50*SW, 150*SW, 150*SW)];
//    topimg.image = [UIImage imageNamed:@"250x250"];
//    [self.view addSubview:topimg];
//    
//    UILabel *toplab = [[UILabel alloc]initWithFrame:CGRectMake(20*SW,topimg.maxY + 50*SW, 40*SW, 50*SW)];
//    toplab.text = @"手机";
//    toplab.font = TextFont;
//    [self.view addSubview:toplab];
//    
//    textf = [[UITextField alloc]initWithFrame:CGRectMake(toplab.maxX +10*SW, topimg.maxY + 50*SW, kW - 90*SW, 50*SW)];
//    textf.placeholder = @"请输入手机号";
//    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:UserName];
//    if (UserName.length){
//        textf.text = phone;
//    }
//    textf.clearButtonMode = UITextFieldViewModeWhileEditing;
//    textf.font = TextFont;
//    [self.view addSubview:textf];
//    
//    UIView *ln = [[UIView alloc]initWithFrame:CGRectMake(15*SW, textf.maxY-0.5, kW-30*SW, 1)];
//    ln.backgroundColor = LnColor;
//    [self.view addSubview:ln];
//    
//    UILabel *pwdlab = [[UILabel alloc]initWithFrame:CGRectMake(20*SW,toplab.maxY , 40*SW, 50*SW)];
//    pwdlab.text = @"密码";
//    pwdlab.font = TextFont;
//    [self.view addSubview:pwdlab];
//    
//    pwdtextf = [[UITextField alloc]initWithFrame:CGRectMake(pwdlab.maxX +10*SW, toplab.maxY, kW - 90*SW, 50*SW)];
//    pwdtextf.placeholder = @"请输入密码";
//    pwdtextf.secureTextEntry = YES;
//    pwdtextf.font = TextFont;
//    pwdtextf.clearButtonMode = UITextFieldViewModeWhileEditing;
//    [self.view addSubview:pwdtextf];
//    UIView *ln1 = [[UIView alloc]initWithFrame:CGRectMake(15*SW, pwdtextf.maxY-0.5, kW-30*SW, 1)];
//    ln1.backgroundColor = LnColor;
//    [self.view addSubview:ln1];
//    
//    
//    UIButton *codebtn = [[UIButton alloc]initWithFrame:CGRectMake(20*SW, ln1.maxY, 140*SW, 40*SW)];
//    [codebtn addTarget:self action:@selector(codeAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:codebtn];
//    
//    UILabel *codelab = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 140*SW, 40*SW)];
//    codelab.text = @"手机验证码登录";
//    codelab.font = TextFont;
//    codelab.textColor = NavAndBtnColor;
//    [codebtn addSubview:codelab];
//    
//    UIButton *forgetbtn = [[UIButton alloc]initWithFrame:CGRectMake(textf.maxX - 100*SW, ln1.maxY, 100*SW, 40*SW)];
//    [forgetbtn addTarget:self action:@selector(forgetAction) forControlEvents:UIControlEventTouchUpInside];
//
//    [self.view addSubview:forgetbtn];
//    
//    UILabel *forgetlab = [[UILabel alloc]initWithFrame:CGRectMake(0,0,100*SW, 40*SW)];
//    forgetlab.textAlignment =2;
//    forgetlab.text = @"忘记密码？";
//    forgetlab.font = TextFont;
//
//    [forgetbtn addSubview:forgetlab];
//    
//    UIButton *btn1 = [[UIButton alloc]init];
//    btn1.frame = CGRectMake( 20*SW, forgetbtn.maxY +120*SW, kW-40*SW, 50*SW);
//    btn1.backgroundColor = NavAndBtnColor;
//    btn1.layer.cornerRadius = 5*SW;
//    btn1.layer.masksToBounds = YES;
//    [btn1 addTarget:self action:@selector(loginaction) forControlEvents:UIControlEventTouchUpInside];
//    [btn1 setTitle:@"登录" forState:UIControlStateNormal];
//    [self.view addSubview:btn1];
//    
//    UIButton *registtbtn = [[UIButton alloc]initWithFrame:CGRectMake(kW/2+20*SW,btn1.maxY,100*SW, 40*SW)];
//    [self.view addSubview:registtbtn];
//    UILabel *regislab1 = [[UILabel alloc]initWithFrame:registtbtn.bounds];
//    regislab1.textAlignment =0;
//    regislab1.text = @"立即注册";
//    regislab1.font = TextFont;
//    regislab1.textColor= NavAndBtnColor;
//    [registtbtn addTarget:self action:@selector(registaction) forControlEvents:UIControlEventTouchUpInside];
//
//    [registtbtn addSubview:regislab1];
//    
//    UILabel *regislab = [[UILabel alloc]initWithFrame:CGRectMake(kW/2-80*SW,btn1.maxY,100*SW, 40*SW)];
//    regislab.textAlignment =2;
//    regislab.text = @"还没有账号？";
//    regislab.font = TextFont;
//    
//    [self.view addSubview:regislab];
//    
//    //添加手势
//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
//    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
//    tapGestureRecognizer.cancelsTouchesInView = NO;
//    //将触摸事件添加到当前view
//    [self.view addGestureRecognizer:tapGestureRecognizer];
//    
//}
//
//
//
//-(void)keyboardHide{
//    [textf endEditing:YES];
//    [pwdtextf endEditing:YES];
//}
//
//-(void)registaction{
//    RegistViewController *vc = [[RegistViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//}
//
//-(void)forgetAction{
//    ForgetPWDViewController *vc = [[ForgetPWDViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//}
//
//-(void)releaseInfo{
//    
//}
//
- (void)passwordLoginAction{
//    CordLoginViewController *vc = [[CordLoginViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
    [DCURLRouter pushURLString:@"route://passwordLoginVC" animated:YES];
}
//
//-(void)loginaction{
//    if (!textf.text.length) {
//        return SVshowInfo(@"请输入手机号");
//    }
//    if (!pwdtextf.text.length) {
//        return SVshowInfo(@"请输入密码");
//    }
//    [YJAPPNetwork LoginPwdWithPhonenum:textf.text code:pwdtextf.text success:^(NSDictionary *responseObject) {
//        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
//        if (code == 200) {
//            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
//            NSDictionary *dic = [responseObject objectForKey:@"data"];
//            [[NSUserDefaults standardUserDefaults] setObject:textf.text forKey:UserName];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            [APPUserDataIofo writeAccessToken:[dic objectForKey:@"accesstoken"]];
//            [APPUserDataIofo getUserID:[dic objectForKey:@"userid"]];
//
//            [self.navigationController popViewControllerAnimated:YES];
//            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//        }else{
//            [ConventionJudge NetCode:code vc:self type:@"1"];
//        }
//    } failure:^(NSString *error) {
//        SVshowInfo(netError);
//    }];
//}
//
- (void)backBtnClicked {
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
