//
//  ModifyNameViewController.m
//  ITelematics
//
//  Created by Oma-002 on 2018/3/9.
//  Copyright © 2018年 com.lima. All rights reserved.
//

#import "ModifyNameViewController.h"
#import "AccountMessageViewModel.h"
@interface ModifyNameViewController ()

@property (nonatomic,strong) UITextField *userTF;
@property (nonatomic,strong) AccountMessageViewModel *viewModel;

@end

@implementation ModifyNameViewController

- (void)hj_configSubViews{
    WS(weakSelf);
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"完成" font:[UIFont boldSystemFontOfSize:16] action:^(id sender) {
        [weakSelf saveOperation];
    }];
    [self createTextField];
    self.view.backgroundColor = Background_Color;
}

- (void)saveOperation{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ShowHint(@"");
        [self.viewModel updateUserInfoWithMessage:self.userTF.text userInfoType:UserInfoTypeNickName success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                hideHud();
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    ShowMessage(@"修改成功");
                });
                
                if(self.userTF.text > 0){
                    [APPUserDataIofo getUserName:self.userTF.text];
                } else {
                    [APPUserDataIofo getUserName:@""];
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:UpdateUserInfoNotification object:nil userInfo:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            });
        }];
    });
}

- (void)createTextField{
    UIView *userView = [[UIView alloc] init];
    userView.backgroundColor = white_color;
    [self.view addSubview:userView];
    [userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.mas_offset(50);
    }];
    
    UITextField *userNameTF =  ({
        UITextField *tmpTF = [[UITextField alloc] init];
        tmpTF.font = MediumFont(font(15));
        tmpTF.textColor = RGB51;
        tmpTF.borderStyle = UITextBorderStyleNone;
        tmpTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        tmpTF;
    });
    [userView addSubview:userNameTF];
    [userNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userView).offset(10);
        make.right.equalTo(userView);
        make.top.bottom.equalTo(userView);
    }];
    self.userTF = userNameTF;
    
    if([APPUserDataIofo nikename].length > 0){
        self.userTF.text = [APPUserDataIofo nikename];
    } else {
        self.userTF.placeholder = @"请填写昵称";
    }
  
}

- (AccountMessageViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [[AccountMessageViewModel alloc] init];
    }
    return _viewModel;
}

@end
