//
//  HJAddAccountMessageCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/23.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJAddAccountMessageCell.h"
#import "HJAddAccountViewModel.h"

@interface HJAddAccountMessageCell ()

@property (nonatomic,strong) HJAddAccountViewModel *viewModel;

@end

@implementation HJAddAccountMessageCell


- (void)hj_configSubViews {
    UILabel *messageTextLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"账户名",MediumFont(font(15)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:messageTextLabel];
    [messageTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(kWidth(10.0));
        make.height.mas_equalTo(kHeight(15));
        make.width.mas_equalTo(kHeight(45));
    }];
    
    self.messageTextLabel = messageTextLabel;
    
    //输入框
    UITextField *messageTf =  ({
        UITextField *tmpTF = [[UITextField alloc] init];
        tmpTF.backgroundColor = white_color;
        tmpTF.font = MediumFont(font(13));
        tmpTF.textColor = [UIColor colorWithHexString:@"#333333"];
        tmpTF.borderStyle = UITextBorderStyleNone;
        tmpTF.placeholder = @"请输入手机号";
        tmpTF.keyboardType = UIKeyboardTypeNumberPad;
        tmpTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        tmpTF;
    });
    [self addSubview:messageTf];
    [messageTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(messageTextLabel.mas_right).offset(kWidth(25));
        make.right.equalTo(self).offset(-kWidth(10));
        make.height.mas_equalTo(kHeight(45));
        make.top.equalTo(self);
    }];
    
    self.messageTf = messageTf;
    [self.messageTf addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setViewModel:(BaseViewModel *)viewModel indexPath:(NSIndexPath *)indexPath {
    self.viewModel = (HJAddAccountViewModel *)viewModel;
    self.messageTf.tag = indexPath.row;
    if (indexPath.row == 0) {
        self.messageTf.text =  self.viewModel.accountname;
    } else if (indexPath.row == 1) {
        self.messageTf.text =  self.viewModel.phoneNum;
    } else {
        self.messageTf.text =  self.viewModel.name;
    }
    
}

- (void)textFieldWithText:(UITextField *)textField{
    if(textField.tag == 0){
        self.viewModel.accountname = self.messageTf.text;
    }
    if(textField.tag == 1){
        self.viewModel.phoneNum = self.messageTf.text;
    }
    if(textField.tag == 2){
        self.viewModel.name = self.messageTf.text;
    }
}

@end
