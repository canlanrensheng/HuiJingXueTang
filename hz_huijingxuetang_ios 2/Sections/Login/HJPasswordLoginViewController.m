//
//  HJPasswordLoginViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/19.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJPasswordLoginViewController.h"
#import "ForgetPWDViewController.h"
#import "HJForgetPwdNavigationController.h"
#import "CustomTabbarController.h"
static NSString *UserName = @"UserName";

@interface HJPasswordLoginViewController ()

@property (nonatomic,strong) UIButton *closeButton;
@property (nonatomic,strong) UILabel *loginLabel;
@property (nonatomic,strong) UITextField *phoneTf;
@property (nonatomic,strong) UITextField *pwdTf;
@property (nonatomic,strong) UIButton *codeBtn;

@end

@implementation HJPasswordLoginViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CGFLOAT_MIN * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:NavAndBtnColor] forBarMetrics:UIBarMetricsDefault];
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
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [DCURLRouter popViewControllerAnimated:YES];
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
        label.ljTitle_font_textColor(@"密码登陆",MediumFont(font(25)),[UIColor colorWithHexString:@"#333333"]);
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
    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:UserName];
    if (phone.length){
        self.phoneTf.text = phone;
    }
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
    
    //验证码
    self.pwdTf =  ({
        UITextField *tmpTF = [[UITextField alloc] init];
        tmpTF.font = MediumFont(font(15));
        tmpTF.textColor = [UIColor colorWithHexString:@"#333333"];
        tmpTF.borderStyle = UITextBorderStyleNone;
        tmpTF.placeholder = @"登陆密码";
        tmpTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        tmpTF.secureTextEntry = YES;
        tmpTF;
    });
    [self.view addSubview:self.pwdTf];
    [self.pwdTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kWidth(10));
        make.right.equalTo(self.view).offset(-kWidth(10 + 20));
        make.height.mas_equalTo(kHeight(40));
        make.top.equalTo(lineView.mas_bottom).offset(kHeight(15));
    }];
    
    @weakify(self);
    [self.pwdTf.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        //        @strongify(self);
        if (x.length >= 8 && x.length <= 16) {
            if (x.length > 16) {
                self.pwdTf.text = [x substringWithRange:NSMakeRange(0, 16)];
            }
            
            if (self.phoneTf.text.length >= 11) {
                [_codeBtn setBackgroundColor:[UIColor colorWithRed:34/255.0 green:71/255.0 blue:107/255.0 alpha:1]];
                _codeBtn.userInteractionEnabled = YES;
            } else {
                [_codeBtn setBackgroundColor:[UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1]];
                _codeBtn.userInteractionEnabled = NO;
            }
            
        }
        else {
            [_codeBtn setBackgroundColor:[UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1]];
            _codeBtn.userInteractionEnabled = NO;
        }
    }];
    
    //保密的按钮
    UIButton *secertBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"",MediumFont(font(13)),white_color,0);
        [button setBackgroundImage:V_IMAGE(@"显示密码") forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            button.selected = !button.selected;
            if (button.selected) {
                self.pwdTf.secureTextEntry = NO;
                [button setBackgroundImage:V_IMAGE(@"隐藏密码") forState:UIControlStateNormal];
                [button mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.view).offset(-kWidth(10));
                    make.centerY.equalTo(self.pwdTf).offset(kHeight(3.0));
                    make.width.mas_equalTo(kWidth(16.0));
                    make.height.mas_equalTo(kHeight(12.0));
                }];
            } else {
                self.pwdTf.secureTextEntry = YES;
                [button setBackgroundImage:V_IMAGE(@"显示密码") forState:UIControlStateNormal];
                [button mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.view).offset(-kWidth(10));
                    make.centerY.equalTo(self.pwdTf).offset(kHeight(3.0));
                    make.width.mas_equalTo(kWidth(16.0));
                    make.height.mas_equalTo(kHeight(6.0));
                }];
            }
        }];
    }];
    
    [self.view addSubview:secertBtn];
    [secertBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-kWidth(10));
        make.centerY.equalTo(self.pwdTf).offset(kHeight(3.0));
        make.width.mas_equalTo(kWidth(16.0));
        make.height.mas_equalTo(kHeight(12.0));
    }];
    
    //pwd分割线
    UIView *pwdLineView = [[UIView alloc] init];
    pwdLineView.backgroundColor = [UIColor colorWithHexString:@"#EAEAEA"];
    [self.view addSubview:pwdLineView];
    [pwdLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.phoneTf);
        make.top.equalTo(self.pwdTf.mas_bottom);
        make.height.mas_equalTo(kHeight(0.5));
    }];
    
    
    //获取验证码
    _codeBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"登陆",MediumFont(font(13)),white_color,0);
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self loginaction];
        }];
    }];
    
    _codeBtn.layer.shadowColor = [UIColor colorWithRed:34/255.0 green:71/255.0 blue:107/255.0 alpha:0.25].CGColor;
    _codeBtn.layer.shadowOffset = CGSizeMake(0,kHeight(8.0));
    _codeBtn.layer.shadowOpacity = 1;
    _codeBtn.layer.shadowRadius = kHeight(15.0);
    _codeBtn.layer.cornerRadius = kHeight(5.0);
    _codeBtn.clipsToBounds = YES;
    
    [self.phoneTf.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        if (x.length >= 11) {
            if (x.length > 11) {
                self.phoneTf.text = [x substringWithRange:NSMakeRange(0, 11)];
            }
            
            if ([self validatePassWord:self.pwdTf.text]){
                [_codeBtn setBackgroundColor:[UIColor colorWithRed:34/255.0 green:71/255.0 blue:107/255.0 alpha:1]];
                _codeBtn.userInteractionEnabled = YES;
            } else {
                [_codeBtn setBackgroundColor:[UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1]];
                _codeBtn.userInteractionEnabled = NO;
            }
           
        }
        else {
            [_codeBtn setBackgroundColor:[UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1]];
            _codeBtn.userInteractionEnabled = NO;
        }
    }];
    
    [self.view addSubview:_codeBtn];
    [_codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pwdLineView.mas_bottom).offset(kHeight(30));
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(kWidth(Screen_Width - kWidth(20.0)));
        make.height.mas_equalTo(kHeight(40.0));
    }];
    
    
    // 忘记密码
    UIButton *forgetPasswordBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"忘记密码?",MediumFont(font(13)),HEXColor(@"#1D3043"),0);
        //        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            ForgetPWDViewController *vc = [[ForgetPWDViewController alloc]init];
//            HJForgetPwdNavigationController *nav = [[HJForgetPwdNavigationController alloc] initWithRootViewController:vc];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }];
    [self.view addSubview:forgetPasswordBtn];
    [forgetPasswordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_codeBtn.mas_bottom).offset(kHeight(25));
        make.left.equalTo(_codeBtn);
        make.height.mas_equalTo(kHeight(13));
    }];

    //忘记密码
    UIButton *codeLoginBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"验证码登陆/注册",MediumFont(font(13)),HEXColor(@"#1D3043"),0);
        //        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [DCURLRouter popViewControllerAnimated:YES];
        }];
    }];
    [self.view addSubview:codeLoginBtn];
    [codeLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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
//        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//            @strongify(self);

        }];
    }];
    [self.view addSubview:protolBtn];
    [protolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(loginProtolLabel);
        make.centerY.equalTo(loginProtolLabel);
        make.left.equalTo(loginProtolLabel.mas_right);
    }];
    
}


-(void)loginaction{
    if (!self.phoneTf.text.length) {
        return ShowError(@"请输入手机号");
    }
    if(![self validatePassWord:self.pwdTf.text]) {
        return ShowError(@"请输入8~16位数字、字母或符号组合");
    }
    
    ShowHint(@"");
//    [MBProgressHUD showHUD:VisibleViewController().view];
    [YJAPPNetwork LoginPwdWithPhonenum:self.phoneTf.text code:self.pwdTf.text success:^(NSDictionary *responseObject) {
        hideHud();
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
//            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            ShowSuccess(@"登陆成功");
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            [[NSUserDefaults standardUserDefaults] setObject:self.phoneTf.text forKey:UserName];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [APPUserDataIofo writeAccessToken:[dic objectForKey:@"accesstoken"]];
            [APPUserDataIofo getUserID:[dic objectForKey:@"userid"]];

            CustomTabbarController *customTabbar = [[CustomTabbarController alloc]init];
            [UIApplication sharedApplication].keyWindow.rootViewController = customTabbar;
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
//        SVshowInfo(netError);
        ShowError(netError);
    }];
}



- (BOOL)validatePassWord:(NSString *)passwordStr{
    NSString *MOBILE = @"^[A-Za-z0-9]{8,16}+$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:passwordStr];
}


@end
