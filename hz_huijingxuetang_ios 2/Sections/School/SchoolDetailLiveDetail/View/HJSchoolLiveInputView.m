//
//  HJSchoolLiveInputView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/26.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSchoolLiveInputView.h"

@implementation HJSchoolLiveInputView

- (void)hj_configSubViews {
    self.backgroundColor = white_color;

    self.sendButton = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"发送",MediumFont(font(13)),white_color,0);
        button.backgroundColor = HEXColor(@"#22476B");
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if(_inputTextField.text.length <= 0){
                _inputTextField.text = @"";
            }
            [self.backSubject sendNext:_inputTextField.text];
        }];
    }];
    [self addSubview:self.sendButton];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-kWidth(10.0));
        make.size.mas_equalTo(CGSizeMake(kWidth(50), kHeight(28)));
    }];
    
    [self.sendButton clipWithCornerRadius:kHeight(2.5) borderColor:nil borderWidth:0];
    
    _inputTextField = [[UITextField alloc]init];
    _inputTextField.backgroundColor = HEXColor(@"#F1F1F1");
//    _inputTextField.delegate = self;
    _inputTextField.font = MediumFont(font(11));
    _inputTextField.placeholder = @"说点什么吧~";
    UIView * leftPhoneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth(10), kHeight(28))];
    _inputTextField.leftView = leftPhoneView;
    _inputTextField.leftViewMode = UITextFieldViewModeAlways;
    _inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _inputTextField.returnKeyType = UIReturnKeySearch;
//    [_inputTextField becomeFirstResponder];
    [_inputTextField addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventAllEditingEvents];
    [self addSubview:_inputTextField];
    [_inputTextField clipWithCornerRadius:kHeight(2.5) borderColor:nil borderWidth:0];
    [_inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.height.mas_equalTo(kHeight(28));
        make.left.equalTo(self).offset(kWidth(10));
        make.right.equalTo(self.sendButton.mas_left).offset(-kWidth(10));
    }];
}

- (void)valueChanged:(UITextField *)textField{
    //搜索内容改变的时候动态地请求数据源
    if(textField.text.length > 0) {
       
    } else {
       
    }
}

- (RACSubject *)backSubject {
    if(!_backSubject) {
        _backSubject = [[RACSubject alloc] init];
    }
    return _backSubject;
}


@end
