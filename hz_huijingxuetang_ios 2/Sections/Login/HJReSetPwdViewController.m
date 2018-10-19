//
//  HJReSetPwdViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/19.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJReSetPwdViewController.h"

@interface HJReSetPwdViewController ()

@property (nonatomic,strong) UITextField *pwdTf;
@property (nonatomic,strong) UITextField *surePwdTf;

@end

@implementation HJReSetPwdViewController

- (void)hj_setNavagation{
    self.navigationItem.title = @"重置密码";
    self.view.backgroundColor = HEXColor(@"#F5F5F5");
}


- (void)hj_configSubViews {
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = white_color;
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(kHeight(45 * 2));
    }];
    
    //电话号码的文本输入
    self.pwdTf =  ({
        UITextField *tmpTF = [[UITextField alloc] init];
        tmpTF.backgroundColor = white_color;
        tmpTF.font = MediumFont(font(13));
        tmpTF.textColor = [UIColor colorWithHexString:@"#333333"];
        tmpTF.borderStyle = UITextBorderStyleNone;
        tmpTF.placeholder = @"请输入8~16位 数字、字母或符号组合";
        tmpTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        tmpTF;
    });
    [self.view addSubview:self.pwdTf];
    [self.pwdTf mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.left.right.equalTo(self.pwdTf);
        make.top.equalTo(self.pwdTf.mas_bottom);
        make.height.mas_equalTo(kHeight(0.5));
    }];
    
    //重复密码
    self.surePwdTf =  ({
        UITextField *tmpTF = [[UITextField alloc] init];
        tmpTF.backgroundColor = white_color;
        tmpTF.font = MediumFont(font(13));
        tmpTF.textColor = [UIColor colorWithHexString:@"#333333"];
        tmpTF.borderStyle = UITextBorderStyleNone;
        tmpTF.placeholder = @"重复密码";
        tmpTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        tmpTF;
    });
    [self.view addSubview:self.surePwdTf];
    [self.surePwdTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kWidth(10));
        make.right.equalTo(self.view).offset(-kWidth(10));
        make.height.mas_equalTo(kHeight(45));
        make.top.equalTo(lineView.mas_bottom);
    }];
    
    //完成按钮
    UIButton *nextBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"完成",MediumFont(font(13)),white_color,0);
        [button setBackgroundColor:[UIColor colorWithRed:34/255.0 green:71/255.0 blue:107/255.0 alpha:1]];
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self finishClick];
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
        make.top.equalTo(self.surePwdTf.mas_bottom).offset(kHeight(71.0));
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(kWidth(Screen_Width - kWidth(20.0)));
        make.height.mas_equalTo(kHeight(40.0));
    }];
}

- (void)finishClick{
    if (![self validatePassWord:self.pwdTf.text]) {
        return SVshowInfo(@"请输入8~16位 数字、字母或符号组合");
    } else if (!self.surePwdTf.text.length){
        return SVshowInfo(@"请输入重复密码");
    } else if (![self.pwdTf.text isEqualToString:self.surePwdTf.text]){
        return SVshowInfo(@"前后两次密码不相等");
    }
    //验证码
    NSDictionary *paraDict = self.params;
    DLog(@"获取到的传递的参数是:%@",paraDict);
    [YJAPPNetwork ForgetPWDWithPhonenum:paraDict[@"phone"] code:paraDict[@"code"] pwd:self.pwdTf.text rpwd:self.surePwdTf.text success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            [SVProgressHUD showSuccessWithStatus:@"密码重置成功"];
//            [self.navigationController popViewControllerAnimated:YES];
            [DCURLRouter popTwiceViewControllerAnimated:YES];
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        SVshowInfo(netError);
    }];
}


- (BOOL)validatePassWord:(NSString *)passwordStr{
    NSString *MOBILE = @"^[A-Za-z0-9]{8,16}+$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:passwordStr];
}



@end
