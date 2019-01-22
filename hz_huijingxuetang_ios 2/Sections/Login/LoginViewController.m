//
//  LoginViewController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/2/8.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "LoginViewController.h"
//#import <NIMSDK/NIMSDK.h>
#import "BaseOtherWebViewController.h"


static NSString *UserName = @"UserName";

#import <WXApi.h>
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
    
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
    self.fd_interactivePopDisabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    self.fd_interactivePopDisabled = NO;

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
//            NSString *isLoginOut = self.params[@"isLoginOut"];
//            NSString *isFromMineVC = self.params[@"isFromMineVC"];
//            if(isLoginOut) {
//                [self.tabBarController setSelectedIndex:0];
//                [self.navigationController popToRootViewControllerAnimated:YES];
//            } else if (isFromMineVC) {
//                [self.tabBarController setSelectedIndex:0];
//                [self.navigationController popToRootViewControllerAnimated:YES];
//            }else{
//                [self backBtnClicked];
//            }
            [UserInfoSingleObject shareInstance].isLogined = NO;
    
            [self.tabBarController setSelectedIndex:0];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }];
    [self.view addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kStatusBarHeight + kHeight(15));
        make.left.equalTo(self.view).offset(kWidth(10));
        make.width.height.mas_equalTo(CGSizeMake(kWidth(22), kWidth(22)));
    }];
    
    //登陆文本
    self.loginLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"登录/注册",MediumFont(font(25)),[UIColor colorWithHexString:@"#333333"]);
        label.numberOfLines = 0;
    }];
    [self.view addSubview:self.loginLabel];
    [self.loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kWidth(10));
        make.top.equalTo(_closeButton.mas_bottom).offset(kHeight(26.0));
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
//        make.width.mas_equalTo(kWidth(Screen_Width - kWidth(20.0)));
        make.left.equalTo(self.view).offset(kWidth(10.0));
        make.right.equalTo(self.view).offset(-kWidth(10));
        make.height.mas_equalTo(kHeight(40.0));
    }];
    
    
    // 密码登陆
    UIButton *forgetPasswordBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"密码登录",MediumFont(font(13)),HEXColor(@"#22476B"),0);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
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
    
    UIView *loginProtolView = [[UIView alloc] init];
    loginProtolView.backgroundColor = clear_color;
    [self.view addSubview:loginProtolView];
    
    [loginProtolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(forgetPasswordBtn.mas_bottom).offset(kHeight(19));
        make.height.mas_equalTo(kHeight(11));
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(kWidth(59));
        make.right.equalTo(self.view).offset(-kWidth(59.0));
    }];

    //登陆注册协议
    UILabel *loginProtolLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"登录注册即代表您已经同意",MediumFont(font(11)),[UIColor colorWithHexString:@"#333333"]);
        label.textAlignment = NSTextAlignmentLeft;
    }];
    [loginProtolView addSubview:loginProtolLabel];
    [loginProtolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(forgetPasswordBtn.mas_bottom).offset(kHeight(19));
        make.height.mas_equalTo(kHeight(11));
//        make.centerX.equalTo(self.view).offset(-kWidth(50));
        make.centerY.equalTo(loginProtolView);
        make.left.equalTo(loginProtolView);
    }];

    //协议按钮
    UIButton *protolBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"《慧鲸学堂用户协议条款》",MediumFont(font(11)),HEXColor(@"#22476B"),0);
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            BaseOtherWebViewController *loginProtolVC = [[BaseOtherWebViewController alloc] init];
            loginProtolVC.webTitle = @"慧鲸学堂服务协议";
            loginProtolVC.urlStr = @"https://www.huijingschool.com/company/protocol.html";
            [self.navigationController pushViewController:loginProtolVC animated:YES];
        }];
    }];
    [loginProtolView addSubview:protolBtn];
    [protolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(loginProtolLabel);
        make.centerY.equalTo(loginProtolLabel);
        make.left.equalTo(loginProtolLabel.mas_right);
    }];
    
    if(MaJia) {
        loginProtolLabel.hidden = YES;
        protolBtn.hidden = YES;
    } else {
        loginProtolLabel.hidden = NO;
        protolBtn.hidden = NO;
    }
}

- (void)getCode{
    if (!self.phoneTf.text.length) {
        ShowMessage(@"请输入手机号");
        return;
    }
    if (![self.phoneTf.text validateMobile]){
        ShowMessage(@"手机号码格式错误");
        return;
    }
    NSDictionary *paraDict = @{@"phone":self.phoneTf.text};
    [DCURLRouter pushURLString:@"route://inputCodeVC" query:paraDict animated:YES];
}


- (void)passwordLoginAction{
    [DCURLRouter pushURLString:@"route://passwordLoginVC" animated:YES];
}

- (void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
