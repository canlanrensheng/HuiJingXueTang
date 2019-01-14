//
//  HJStuntJudgeAddReplyViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/27.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJStuntJudgeAddReplyViewController.h"
#import "BMTextView.h"
#import "HJStuntJudgeViewModel.h"
@interface HJStuntJudgeAddReplyViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *stuntCodeTF;
@property (nonatomic,strong) BMTextView *textView;
@property (nonatomic,strong) HJStuntJudgeViewModel *viewModel;

@end

@implementation HJStuntJudgeAddReplyViewController

- (HJStuntJudgeViewModel *)viewModel {
    if(!_viewModel) {
        _viewModel = [[HJStuntJudgeViewModel alloc] init];
    }
    return _viewModel;
}

- (void)hj_setNavagation {
    self.title = @"诊股";
    self.view.backgroundColor = Background_Color;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"提交" font:MediumFont(font(15)) action:^(id sender) {
        if(self.stuntCodeTF.text.length <= 0) {
            ShowMessage(@"股票代码不能为空");
            return ;
        }
        if(self.textView.text.length <= 0) {
            ShowMessage(@"写下你的问题吧~");
            return ;
        }
        __weak typeof(self)weakSelf = self;
        self.viewModel.title = self.stuntCodeTF.text;
        self.viewModel.question = self.textView.text;
        [self.viewModel addStuntQuestionWithSuccess:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshWaitReplyListData" object:nil userInfo:nil];
            [DCURLRouter popViewControllerAnimated:YES];
        }];
        
    }];
}

- (void)hj_configSubViews {
    [self.view addSubview:self.stuntCodeTF];
    [self.stuntCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(kHeight(45));
    }];
    
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stuntCodeTF.mas_bottom).offset(kHeight(10.0));
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(kHeight(200));
    }];
}

- (UITextField *)stuntCodeTF {
    if (!_stuntCodeTF) {
        _stuntCodeTF = [[UITextField alloc]init];
        _stuntCodeTF.backgroundColor = white_color;
        _stuntCodeTF.delegate = self;
        _stuntCodeTF.placeholder = @"输入股票代码或名称";
        _stuntCodeTF.font = MediumFont(font(13));
        UIView *leftPhoneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth(10), kHeight(45))];
        _stuntCodeTF.leftView = leftPhoneView;
        _stuntCodeTF.leftViewMode = UITextFieldViewModeAlways;
        _stuntCodeTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
//        _stuntCodeTF.keyboardType = UIKeyboardTypeNumberPad;
        [_stuntCodeTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _stuntCodeTF;
}

- (BMTextView *)textView{
    if(!_textView){
        _textView = [[BMTextView alloc] init];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.placeholderColor = HEXColor(@"#CCCCCC");
        _textView.placeholder = @" 写下你的问题吧~";
//        _textView.maxLimitCount = 100;
        _textView.showLimitString = NO;
        _textView.font = MediumFont(font(13));
        [_textView clipWithCornerRadius:kHeight(8.0) borderColor:nil borderWidth:0];
    }
    return _textView;
}

- (void)textFieldDidChange:(UITextField *)textField {
    
}


@end
