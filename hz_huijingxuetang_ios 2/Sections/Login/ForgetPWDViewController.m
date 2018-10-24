//
//  ForgetPWDViewController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/2/8.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "ForgetPWDViewController.h"
#import "HJLocalCodeView.h"
@interface ForgetPWDViewController ()

@property (nonatomic,strong) UITextField *phoneTf;
@property (nonatomic,strong) UITextField *picCodeTf;
@property (nonatomic,strong) UITextField *codeTf;
@property (nonatomic,strong) UIButton *getCodeBtn;

@property (nonatomic,strong) HJLocalCodeView *localCodeView;

@end

@implementation ForgetPWDViewController
{
//    UITextField *textf;
//    UITextField *pwdtextf;
//    UITextField *cordtextf;
//    UIButton *grtcodebtn;
    NSTimer *timer;
    NSInteger countdown;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:NavigationBar_Color] forBarMetrics:UIBarMetricsDefault];
}

-(void)dealloc{
    [timer invalidate];
    timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"忘记密码";
    self.view.backgroundColor = HEXColor(@"#F5F5F5");
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = white_color;
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(kHeight(45 * 3));
    }];
    
    //电话号码的文本输入
    self.phoneTf =  ({
        UITextField *tmpTF = [[UITextField alloc] init];
        tmpTF.backgroundColor = white_color;
        tmpTF.font = MediumFont(font(13));
        tmpTF.textColor = [UIColor colorWithHexString:@"#333333"];
        tmpTF.borderStyle = UITextBorderStyleNone;
        tmpTF.placeholder = @"请输入11位手机号";
        tmpTF.keyboardType = UIKeyboardTypeNumberPad;
        tmpTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        tmpTF;
    });
    [self.view addSubview:self.phoneTf];
    [self.phoneTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kWidth(10));
        make.right.equalTo(self.view).offset(-kWidth(10));
        make.height.mas_equalTo(kHeight(45));
        make.top.equalTo(self.view);
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
    
    //图片验证码
    HJLocalCodeView *codeView = [[HJLocalCodeView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - kWidth(100), kHeight(45), kWidth(100), kHeight(45)) andCharCount:4 andLineCount:4];
    [self.view addSubview:codeView];
    self.localCodeView = codeView;
    
//    __weak typeof(self) weakSelf = self;
    /// 返回验证码数字
    codeView.changeValidationCodeBlock = ^(void){
//        DLog(@"验证码被点击了：%@", codeView.charString);
    };
    
    //请输入图片验证码
    self.picCodeTf =  ({
        UITextField *tmpTF = [[UITextField alloc] init];
        tmpTF.font = MediumFont(font(13));
        tmpTF.backgroundColor = white_color;
        tmpTF.textColor = [UIColor colorWithHexString:@"#333333"];
        tmpTF.borderStyle = UITextBorderStyleNone;
        tmpTF.placeholder = @"请输入图片验证码";
        tmpTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        tmpTF;
    });
    [self.view addSubview:self.picCodeTf];
    [self.picCodeTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kWidth(10));
        make.right.equalTo(self.view).offset(-kWidth(100));
        make.height.mas_equalTo(kHeight(45));
        make.top.equalTo(lineView.mas_bottom);
    }];
    
    //分割线
    UIView *picCodeLineView = [[UIView alloc] init];
    picCodeLineView.backgroundColor = [UIColor colorWithHexString:@"#EAEAEA"];
    [self.view addSubview:picCodeLineView];
    [picCodeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.phoneTf);
        make.top.equalTo(self.picCodeTf.mas_bottom);
        make.height.mas_equalTo(kHeight(0.5));
    }];
    
    //获取验证码
    UIButton *getCodeBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"获取验证码",MediumFont(font(13)),HEXColor(@"#1D3043"),0);
        button.backgroundColor = white_color;
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self getCode];
        }];
    }];
    self.getCodeBtn = getCodeBtn;
    [self.view addSubview:getCodeBtn];
    [getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.top.equalTo(picCodeLineView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kWidth(100), kHeight(45.0)));
    }];
    
    //分割线
    UIView *codeLineView = [[UIView alloc] init];
    codeLineView.backgroundColor = [UIColor colorWithHexString:@"#EAEAEA"];
    [self.view addSubview:codeLineView];
    [codeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(getCodeBtn.mas_left);
        make.centerY.equalTo(getCodeBtn);
        make.width.mas_equalTo(kWidth(1.0));
    }];
    
    //输入验证码
    self.codeTf =  ({
        UITextField *tmpTF = [[UITextField alloc] init];
        tmpTF.font = MediumFont(font(13));
        tmpTF.backgroundColor = white_color;
        tmpTF.textColor = [UIColor colorWithHexString:@"#333333"];
        tmpTF.borderStyle = UITextBorderStyleNone;
        tmpTF.placeholder = @"输入验证码";
        tmpTF.keyboardType = UIKeyboardTypeNumberPad;
        tmpTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        tmpTF;
    });
    [self.view addSubview:self.codeTf];
    [self.codeTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kWidth(10));
        make.right.equalTo(self.view).offset(-kWidth(101));
        make.height.mas_equalTo(kHeight(45));
        make.top.equalTo(picCodeLineView.mas_bottom);
    }];
    
    //下一步按钮
    UIButton *nextBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"下一步",MediumFont(font(13)),white_color,0);
        [button setBackgroundColor:[UIColor colorWithRed:34/255.0 green:71/255.0 blue:107/255.0 alpha:1]];
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self nextClick];
        }];
    }];

    nextBtn.layer.shadowColor = [UIColor colorWithRed:34/255.0 green:71/255.0 blue:107/255.0 alpha:0.25].CGColor;
    nextBtn.layer.shadowOffset = CGSizeMake(0,kHeight(8.0));
    nextBtn.layer.shadowOpacity = 1;
    nextBtn.layer.shadowRadius = kHeight(15.0);
    nextBtn.layer.cornerRadius = kHeight(5.0);
    nextBtn.clipsToBounds = YES;
    
    
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeTf.mas_bottom).offset(kHeight(25.0));
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(kWidth(Screen_Width - kWidth(20.0)));
        make.height.mas_equalTo(kHeight(40.0));
    }];
}


//下一步操作
- (void)nextClick{
    if (!self.phoneTf.text.length) {
        return ShowError(@"请输入11位手机号");
    }
    if (!self.picCodeTf.text.length) {
        return ShowError(@"请输入图片验证码");
    }
    if (!self.codeTf.text.length) {
        return ShowError(@"请输入验证码");
    }
    NSDictionary *paraDict = @{@"code" : self.codeTf.text ,@"phone" : self.phoneTf.text};
    [DCURLRouter pushURLString:@"route://reSetPwdVC" query:paraDict animated:YES];
}

- (void)getCode{
    if (!self.phoneTf.text.length) {
        return ShowError(@"请输入11位手机号");
    }
    if (!self.picCodeTf.text.length) {
        return ShowError(@"请输入图片验证码");
    }
    if (![self.localCodeView.charString isEqualToString:self.picCodeTf.text]) {
        return ShowError(@"请输入正确的图片验证码");
    }
    [YJAPPNetwork GetCodeForgetWithPhonenum:self.phoneTf.text success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
//            [SVProgressHUD showSuccessWithStatus:@"验证码发送成功"];
            ShowMessage(@"验证码发送成功");
            _getCodeBtn.selected = YES;
            _getCodeBtn.layer.borderColor = [TextColor CGColor];
            _getCodeBtn.userInteractionEnabled = NO;
            countdown = 60;
            
            [_getCodeBtn setTitle:[NSString stringWithFormat:@"重新发送(%ld)",countdown] forState:UIControlStateNormal];
            timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(countdown) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        ShowError(netError);
    }];
}

- (void)countdown{
    countdown--;
    [_getCodeBtn setTitle:[NSString stringWithFormat:@"重新发送(%ld)",countdown] forState:UIControlStateNormal];
    if (countdown == 0) {
        [timer invalidate];
        timer = nil;
        _getCodeBtn.selected = NO;
        _getCodeBtn.layer.borderColor = [NavAndBtnColor CGColor];
        _getCodeBtn.userInteractionEnabled = YES;
        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        countdown = 60;
    }
}


@end
