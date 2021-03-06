//
//  HJInputCodeViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/18.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJInputCodeViewController.h"
#import "HJPasswordView.h"
@interface HJInputCodeViewController ()

@property (nonatomic,strong) UIButton *getCodeButton;
@property (nonatomic, assign) NSInteger remainSeconds;

// 注册了按钮
@property (nonatomic,assign) BOOL isResister;

//是否已经完成
@property (nonatomic,assign) BOOL isFinished;

//关闭按钮
@property (nonatomic,strong) UIButton *closeButton;

@end

@implementation HJInputCodeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CGFLOAT_MIN * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    });
    //点击背景收回键盘
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
    self.fd_interactivePopDisabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //点击背景收回键盘
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    self.fd_interactivePopDisabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
}

- (void)hj_configSubViews {
    _closeButton = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"关闭",MediumFont(font(13)),white_color,0);
        [button setImage:V_IMAGE(@"close") forState:UIControlStateNormal];
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [DCURLRouter popViewControllerAnimated:YES];
        }];
    }];
    [self.view addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kStatusBarHeight + kHeight(15));
        make.left.equalTo(self.view).offset(kWidth(10));
        make.width.height.mas_equalTo(CGSizeMake(kWidth(22), kWidth(22)));
    }];
    //设置登录密码
    UILabel *setLoginPasswordLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"验证码",MediumFont(font(25)),[UIColor colorWithHexString:@"#333333"]);
        label.numberOfLines = 0;
    }];
    [self.view addSubview:setLoginPasswordLabel];
    [setLoginPasswordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(kWidth(10));
//        make.top.offset(kHeight(79));
        make.left.offset(kWidth(10));
        make.top.equalTo(_closeButton.mas_bottom).offset(kHeight(26.0));
    }];
    
    //8~16位数字、字母或符号组合
    UILabel *setPasswordFormatLabel = [UILabel creatLabel:^(UILabel *label) {
        NSDictionary *para = self.params;
        NSString *phone = para[@"phone"];
        if (phone.length) {
            NSString *str1 = [phone substringWithRange:NSMakeRange(0, 3)];
            NSString *str2 = [phone substringWithRange:NSMakeRange(3, 4)];
            NSString *str3 = [phone substringWithRange:NSMakeRange(7, 4)];
            label.ljTitle_font_textColor([NSString stringWithFormat:@"验证码已发送至%@ %@ %@",str1,str2,str3],MediumFont(font(11)),[UIColor colorWithHexString:@"#999999"]);
        }
        label.numberOfLines = 0;
    }];
    [self.view addSubview:setPasswordFormatLabel];
    [setPasswordFormatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kWidth(10));
        make.top.equalTo(setLoginPasswordLabel.mas_bottom).offset(kHeight(10));
    }];
    
    // 验证码背景试图
    CGFloat height = kHeight(31);
//    CGFloat width = kWidth(40);
//    CGFloat padding = kWidth(49.0);
    
    UIView *textFieldView = [[UIView alloc] init];
    [self.view addSubview:textFieldView];
    textFieldView.backgroundColor = red_color;
    [textFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kWidth(35));
        make.top.equalTo(setPasswordFormatLabel.mas_bottom).offset(kHeight(kHeight(120)));
        make.height.mas_equalTo(height);
    }];
    
    
    HJPasswordView *codeInputView = [[HJPasswordView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width - kWidth(70), height)];
    codeInputView.num = 6;
    codeInputView.callBackBlock = ^(NSString *text) {
        if(text.length == 6){
            NSDictionary *para = self.params;
            NSString *phone = para[@"phone"];
            //登陆
            
            if(self.isResister && self.isFinished == NO){
// 登陆
                self.isFinished = YES;
                ShowHint(@"");
                DLog(@"获取到的登陆的数据是:%@ %@",phone,text);
                [YJAPPNetwork LoginPwdWithPhonenum:phone code:text success:^(NSDictionary *responseObject) {
                    NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
                    
                    DLog(@"获取到的登陆成功的数据是:%@",responseObject);
                    if (code == 200) {

                        [UserInfoSingleObject shareInstance].isLogined = NO;
                        
                        NSDictionary *dic = [responseObject objectForKey:@"data"];
                        [APPUserDataIofo getUserPhone:phone];
                        [APPUserDataIofo writeOpenId:[dic objectForKey:@"has_openid"]];
                        [APPUserDataIofo writeAccessToken:[dic objectForKey:@"accesstoken"]];
                        [APPUserDataIofo getUserID:[dic objectForKey:@"userid"]];
                        [APPUserDataIofo getEval:[NSString stringWithFormat:@"%@",[dic objectForKey:@"eval"]]];
                        //刷新我的页面
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            self.tabBarController.selectedIndex = 0;
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        });
                    } else {
                        [ConventionJudge NetCode:code vc:self type:@"1"];
                    }
                } failure:^(NSString *error) {
                    ShowError(netError);
                }];
            } else {
                //注册跳转
                if(self.isFinished == NO) {
                    self.isFinished = YES;
                    NSDictionary *paraDict = @{@"code" : text , @"phone" : phone};
                    [DCURLRouter pushURLString:@"route://setPasswordVC" query:paraDict animated:YES];
                }
               
            }
        }
        DLog(@"%@",text);
    };
    [codeInputView showPassword];
    [textFieldView addSubview:codeInputView];
    [codeInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.equalTo(textFieldView);
    }];
    //获取验证码按钮
    UIButton * getCodeButton = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"",MediumFont(font(13)),HEXColor(@"#999999"),0);
    }];
    self.getCodeButton = getCodeButton;
    [self.view addSubview:getCodeButton];
    [getCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textFieldView.mas_bottom).offset(kHeight(25));
        make.centerX.equalTo(self.view);
    }];
    
    //开启定时器
    [self setTimer];
    self.remainSeconds = 60;

    @weakify(self);
    [[[[[[RACSignal interval:1
                 onScheduler:[RACScheduler mainThreadScheduler]] take:self.remainSeconds] startWith:@(1)] takeUntil:self.rac_willDeallocSignal] map:^id(NSDate* value) {
        @strongify(self);
        if (self.remainSeconds == 0) {
            [self.getCodeButton setTitle:@"重新获取" forState:UIControlStateNormal];
            [self.getCodeButton setTitleColor:HEXColor(@"#22476B") forState:UIControlStateNormal];
            return @YES;
        }else{
            [self.getCodeButton setTitle:[NSString stringWithFormat:@"%tuS后重新获取", self.remainSeconds--] forState:UIControlStateNormal];
            [self.getCodeButton setTitleColor:HEXColor(@"#999999") forState:UIControlStateNormal];
            return @NO;
        }
    }] subscribeNext:^(id x) {

    }];
}


- (void)setTimer{
    @weakify(self);
    RAC(self.getCodeButton, enabled) = [RACSignal
                                         combineLatest:@[RACObserve(self, remainSeconds)]
                                         reduce:^id(NSNumber* remain) {
                                             return@(remain.intValue == 0);
                                         }];
    [[self.getCodeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        
        self.remainSeconds = 60;
        
        NSDictionary *para = self.params;
        NSString *phone = para[@"phone"];
        if (self.isResister == 1) {
            //已经注册 发送登陆验证码
            [YJAPPNetwork GetCodeLoginWithPhonenum:phone success:^(NSDictionary *responseObject) {
                //登陆验证码
                NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
                if (code == 200) {
                    [[[[[[RACSignal interval:1
                                 onScheduler:[RACScheduler mainThreadScheduler]] take:self.remainSeconds] startWith:@(1)] takeUntil:self.rac_willDeallocSignal] map:^id(NSDate* value) {
                        @strongify(self);
                        if (self.remainSeconds == 0) {
                            [self.getCodeButton setTitle:@"重新获取" forState:UIControlStateNormal];
                            [self.getCodeButton setTitleColor:HEXColor(@"#22476B") forState:UIControlStateNormal];
                            return @YES;
                        }else{
                            [self.getCodeButton setTitle:[NSString stringWithFormat:@"%tuS后重新获取", self.remainSeconds--] forState:UIControlStateNormal];
                            [self.getCodeButton setTitleColor:HEXColor(@"#999999") forState:UIControlStateNormal];
                            return @NO;
                        }
                    }] subscribeNext:^(id x) {
                        
                    }];
                }else{
                    self.remainSeconds = 0;
//                    [ConventionJudge NetCode:code vc:self type:@"1"];
                }
            } failure:^(NSString *error) {
                self.remainSeconds = 0;
//                SVshowInfo(netError);
                ShowMessage(netError);
            }];
        } else {
            //没有注册 发送注册验证码
            [YJAPPNetwork GetCodeWithPhonenum:phone success:^(NSDictionary *responseObject) {
                //注册验证码
                NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
                if (code == 200) {
                    [[[[[[RACSignal interval:1
                                 onScheduler:[RACScheduler mainThreadScheduler]] take:self.remainSeconds] startWith:@(1)] takeUntil:self.rac_willDeallocSignal] map:^id(NSDate* value) {
                        @strongify(self);
                        if (self.remainSeconds == 0) {
                            [self.getCodeButton setTitle:@"重新获取" forState:UIControlStateNormal];
                            [self.getCodeButton setTitleColor:HEXColor(@"#22476B") forState:UIControlStateNormal];
                            return @YES;
                        }else{
                            [self.getCodeButton setTitle:[NSString stringWithFormat:@"%tuS后重新获取", self.remainSeconds--] forState:UIControlStateNormal];
                            [self.getCodeButton setTitleColor:HEXColor(@"#999999") forState:UIControlStateNormal];
                            return @NO;
                        }
                    }] subscribeNext:^(id x) {
                        
                    }];
                }else{
                    self.remainSeconds = 0;
//                    [ConventionJudge NetCode:code vc:self type:@"1"];
                }
            } failure:^(NSString *error) {
                self.remainSeconds = 0;
//                SVshowInfo(netError);
                ShowMessage(netError);
            }];
        }
        
    }];
}


//加载数据
- (void)hj_loadData {
    NSDictionary *para = self.params;
    NSString *phone = para[@"phone"];
    ShowHint(@"");
    [YJAPPNetwork checkReggedWithPhonenum:phone  success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        hideHud();
        if (code == 200) {
            self.isResister = [responseObject[@"data"] integerValue];
            [self sendCode];
        }else{
//            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        ShowError(netError);
    }];
}

- (void)sendCode {
    NSDictionary *para = self.params;
    NSString *phone = para[@"phone"];
    if (self.isResister == 1) {
//        已经注册 发送登陆验证码
        [YJAPPNetwork GetCodeLoginWithPhonenum:phone success:^(NSDictionary *responseObject) {
            //登陆验证码
            NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
            if (code == 200) {
                //发送成功
                ShowMessage(@"验证码发送成功");
//                [SVProgressHUD showInfoWithStatus:@"验证码发送成功"];
//                [MBProgressHUD  ];
            }else{
//                [ConventionJudge NetCode:code vc:self type:@"1"];
            }
        } failure:^(NSString *error) {
//            SVshowInfo(netError);
            ShowError(error);
        }];
    } else {
//        //没有注册 发送注册验证码
        [YJAPPNetwork GetCodeWithPhonenum:phone success:^(NSDictionary *responseObject) {
            //注册验证码
            NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
            if (code == 200) {
                ShowMessage(@"验证码发送成功");
            }else{
                [ConventionJudge NetCode:code vc:self type:@"1"];
            }
        } failure:^(NSString *error) {
//            SVshowInfo(netError);
            ShowError(error);
        }];
    }

}

@end
