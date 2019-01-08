//
//  HJInviteCodeViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/19.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJInviteCodeViewController.h"
#import "HJInviteCodeView.h"


@interface HJInviteCodeViewController ()

//是否已经完成
@property (nonatomic,assign) BOOL isFinished;

@end

@implementation HJInviteCodeViewController

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
    //跳过按钮
    UIButton *jumpBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"跳过",MediumFont(font(15)),HEXColor(@"#22476B"),0);
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            ShowHint(@"");
            NSDictionary *para = self.params;
            [YJAPPNetwork registWithPhonenum:para[@"phone"] pwd:para[@"pwd"] code:para[@"code"] incode:nil success:^(NSDictionary *responseObject) {
                hideHud();
                NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
                if (code == 200) {
                    NSDictionary *dic = [responseObject objectForKey:@"data"];
                    //                    DLog(@"返回饿数据是:%@",dic);
                    [UserInfoSingleObject shareInstance].isLogined = NO;
                    [APPUserDataIofo getUserPhone:para[@"phone"]];
                    [APPUserDataIofo writeOpenId:[para objectForKey:@"has_openid"]];
                    [APPUserDataIofo writeAccessToken:[dic objectForKey:@"accesstoken"]];
                    [APPUserDataIofo getUserID:[dic objectForKey:@"userid"]];
                    [APPUserDataIofo getEval:[NSString stringWithFormat:@"%@",[dic objectForKey:@"eval"]]];
                    //                    [DCURLRouter popViewControllerWithTimes:4 animated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:LoginGetUserInfoNotification object:nil userInfo:nil];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [DCURLRouter popToRootViewControllerAnimated:YES];
                    });
                    
                }else{
//                    [ConventionJudge NetCode:code vc:self type:@"1"];
                }
            } failure:^(NSString *error) {
                hideHud();
                ShowMessage(netError);
            }];

        }];
    }];
    [self.view addSubview:jumpBtn];
    [jumpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-kWidth(10.0));
        make.top.equalTo(self.view).offset(kStatusBarHeight + kHeight(14.0));
    }];
    
    //邀请码
    UILabel *inviteCodeLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"邀请码",MediumFont(font(25)),[UIColor colorWithHexString:@"#333333"]);
        label.numberOfLines = 0;
    }];
    [self.view addSubview:inviteCodeLabel];
    [inviteCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kWidth(10));
        make.top.offset(kHeight(59) + kStatusBarHeight);
        make.height.mas_equalTo(kHeight(24.0));
    }];
    
    
    CGFloat height = kHeight(31);
    UIView *textFieldView = [[UIView alloc] init];
    [self.view addSubview:textFieldView];
    textFieldView.backgroundColor = red_color;
    [textFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kWidth(25));
        make.top.equalTo(inviteCodeLabel.mas_bottom).offset(kHeight(kHeight(138)));
        make.height.mas_equalTo(height);
    }];
    
    
    HJInviteCodeView *codeInputView = [[HJInviteCodeView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width - kWidth(50), height)];
    
    codeInputView.num = 6;
//    __weak typeof(self)weakSelf = self;
    codeInputView.callBackBlock = ^(NSString *text) {
        if(text.length == 6 && self.isFinished == NO){
            self.isFinished = YES;
            NSDictionary *para = self.params;
            ShowHint(@"");
            [YJAPPNetwork registWithPhonenum:para[@"phone"] pwd:para[@"pwd"] code:para[@"code"] incode:text success:^(NSDictionary *responseObject) {
                hideHud();
                NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
                if (code == 200) {
                    NSDictionary *dic = [responseObject objectForKey:@"data"];
                    [UserInfoSingleObject shareInstance].isLogined = NO;
                    [APPUserDataIofo getUserPhone:para[@"phone"]];
                    [APPUserDataIofo writeOpenId:[para objectForKey:@"has_openid"]];
                    [APPUserDataIofo writeAccessToken:[dic objectForKey:@"accesstoken"]];
                    [APPUserDataIofo getUserID:[dic objectForKey:@"userid"]];
                    [APPUserDataIofo getEval:[NSString stringWithFormat:@"%@",[dic objectForKey:@"eval"]]];
//                    [DCURLRouter popViewControllerWithTimes:4 animated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:LoginGetUserInfoNotification object:nil userInfo:nil];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [DCURLRouter popToRootViewControllerAnimated:YES];
                    });
                    
                }else{
//                    [ConventionJudge NetCode:code vc:self type:@"1"];
                }
            } failure:^(NSString *error) {
//                SVshowInfo(netError);
                hideHud();
                ShowMessage(netError);
            }];
        }
        DLog(@"%@",text);
    };
    [codeInputView showPassword];
    [textFieldView addSubview:codeInputView];
    [codeInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.equalTo(textFieldView);
    }];
}



@end
