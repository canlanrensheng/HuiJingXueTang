//
//  HJSetPasswordViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/18.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSetPasswordViewController.h"

@interface HJSetPasswordViewController ()

@property (nonatomic,strong) UITextField *passwordTf;

@end

@implementation HJSetPasswordViewController



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CGFLOAT_MIN * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        UIViewController *vc = [self.navigationController.viewControllers lastObject];
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    
}

- (void)hj_configSubViews {
    //设置登录密码
    UILabel *setLoginPasswordLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"设置登录密码",MediumFont(font(25)),[UIColor colorWithHexString:@"#333333"]);
        label.numberOfLines = 0;
    }];
    [self.view addSubview:setLoginPasswordLabel];
    [setLoginPasswordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kWidth(10));
        make.top.offset(kHeight(79));
        make.height.mas_equalTo(kHeight(24.0));
    }];
    
    //8~16位数字、字母或符号组合
    UILabel *setPasswordFormatLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"8~16位数字、字母或符号组合",MediumFont(font(11)),[UIColor colorWithHexString:@"#999999"]);
        label.numberOfLines = 0;
    }];
    [self.view addSubview:setPasswordFormatLabel];
    [setPasswordFormatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kWidth(10));
        make.top.equalTo(setLoginPasswordLabel.mas_bottom).offset(kHeight(10));
        make.height.mas_equalTo(kHeight(11.0));
    }];
    
    //电话号码的文本输入
    self.passwordTf =  ({
        UITextField *tmpTF = [[UITextField alloc] init];
        tmpTF.font = MediumFont(font(15));
        tmpTF.textColor = [UIColor colorWithHexString:@"#333333"];
        tmpTF.borderStyle = UITextBorderStyleNone;
        tmpTF.placeholder = @"设置登陆密码";
//        tmpTF.keyboardType = UIKeyboardTypeNumberPad;
        tmpTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        tmpTF.secureTextEntry = YES;
        tmpTF;
    });
    [self.view addSubview:self.passwordTf];
    
    [self.passwordTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kWidth(10));
        make.right.equalTo(self.view).offset(-kWidth(10 + 20));
        make.height.mas_equalTo(kHeight(40));
        make.top.equalTo(setPasswordFormatLabel.mas_bottom).offset(kHeight(108));
    }];
    
    //保密的按钮
    UIButton *secertBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"确定",MediumFont(font(13)),white_color,0);
        [button setBackgroundImage:V_IMAGE(@"显示密码") forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            button.selected = !button.selected;
            if (button.selected) {
                self.passwordTf.secureTextEntry = NO;
                [button setBackgroundImage:V_IMAGE(@"隐藏密码") forState:UIControlStateNormal];
                [button mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.view).offset(-kWidth(10));
                    make.centerY.equalTo(self.passwordTf).offset(kHeight(3.0));
                    make.width.mas_equalTo(kWidth(16.0));
                    make.height.mas_equalTo(kHeight(12.0));
                }];
            } else {
                self.passwordTf.secureTextEntry = YES;
                [button setBackgroundImage:V_IMAGE(@"显示密码") forState:UIControlStateNormal];
                [button mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.view).offset(-kWidth(10));
                    make.centerY.equalTo(self.passwordTf).offset(kHeight(3.0));
                    make.width.mas_equalTo(kWidth(16.0));
                    make.height.mas_equalTo(kHeight(6.0));
                }];
            }
        }];
    }];
    
    [self.view addSubview:secertBtn];
    [secertBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-kWidth(10));
        make.centerY.equalTo(self.passwordTf).offset(kHeight(3.0));
        make.width.mas_equalTo(kWidth(16.0));
        make.height.mas_equalTo(kHeight(12.0));
    }];
    
    //分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#1D3043"];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.passwordTf);
        make.right.equalTo(self.view).offset(-kWidth(10));
        make.top.equalTo(self.passwordTf.mas_bottom);
        make.height.mas_equalTo(kHeight(1.0));
    }];
    
    
    //获取验证码
    UIButton *sureBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"确定",MediumFont(font(13)),white_color,0);
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self sureClick];
        }];
    }];
    
    
    sureBtn.layer.shadowColor = [UIColor colorWithRed:34/255.0 green:71/255.0 blue:107/255.0 alpha:0.25].CGColor;
    sureBtn.layer.shadowOffset = CGSizeMake(0,kHeight(8.0));
    sureBtn.layer.shadowOpacity = 1;
    sureBtn.layer.shadowRadius = kHeight(15.0);
    sureBtn.layer.cornerRadius = kHeight(5.0);
    sureBtn.clipsToBounds = YES;
    
    @weakify(self);
    [self.passwordTf.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        //        @strongify(self);
        if (x.length >= 8 && x.length <= 16) {
            if (x.length > 16) {
                self.passwordTf.text = [x substringWithRange:NSMakeRange(0, 16)];
            }
            [sureBtn setBackgroundColor:[UIColor colorWithRed:34/255.0 green:71/255.0 blue:107/255.0 alpha:1]];
            sureBtn.userInteractionEnabled = YES;
        } else {
            [sureBtn setBackgroundColor:[UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1]];
            sureBtn.userInteractionEnabled = NO;
        }
    }];
    
    [self.view addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(kHeight(30));
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(kWidth(Screen_Width - kWidth(20.0)));
        make.height.mas_equalTo(kHeight(40.0));
    }];
    
}

- (void)sureClick{
    if(![self validatePassWord:self.passwordTf.text]) {
        ShowError(@"请输入8~16位数字、字母或符号组合");
        return;
    }
    NSDictionary *para = self.params;
    NSDictionary *paraDict = @{ @"code" : para[@"code"], @"pwd" : self.passwordTf.text ,@"phone" : para[@"phone"]};
    [DCURLRouter pushURLString:@"route://inviteCodeVC" query:paraDict animated:YES];
}

- (BOOL)validatePassWord:(NSString *)passwordStr{
    NSString *MOBILE = @"^[A-Za-z0-9]{8,16}+$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:passwordStr];
}

@end
