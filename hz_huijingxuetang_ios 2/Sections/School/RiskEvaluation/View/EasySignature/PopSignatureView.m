//
//  PopSignatureView.m
//  EsayHandwritingSignature
//
//  Created by Liangk on 2017/11/9.
//  Copyright © 2017年 liang. All rights reserved.
//

#import "PopSignatureView.h"
#import "EasySignatureView.h"

#define ScreenWidth  [UIScreen mainScreen].bounds.size.width  //  设备的宽度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height //   设备的高度
#define RGB(__R, __G, __B) [UIColor colorWithRed:(__R) / 255.0f green:(__G) / 255.0f blue:(__B) / 255.0f alpha:1.0]
#define ACTIONSHEET_BACKGROUNDCOLOR             [UIColor colorWithRed:106/255.00f green:106/255.00f blue:106/255.00f alpha:0.8]

#define WINDOW_COLOR                            [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]

#define SignatureViewHeight ((ScreenWidth*(350))/(375))

@interface PopSignatureView () <SignatureViewDelegate> {
    UIView* _mainView;
    UIButton* _maskView;
    EasySignatureView *signatureView;
    UIButton *btn3;
}

@property (nonatomic,strong) UIView *backGroundView;
@property (nonatomic,strong) UILabel *signPlaceHoderLabel;
@property (nonatomic,strong) UIButton *reSignBtn;
@property (nonatomic,strong) UIButton *submmitBtn;

@end

@implementation PopSignatureView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.frame =CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = WINDOW_COLOR;
        self.userInteractionEnabled = YES;
        
        
        [self setupView];
        
    }
    return self;
}

//- (id)initWithMainView:(UIView*)mainView
//{
//    self = [super init];
//    if(self)
//    {
//        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//        self.userInteractionEnabled = YES;
//        _mainView = mainView;
//        [self setupView];
//    }
//    return self;
//}

- (void)showInView:(UIView *)view
{
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
}


- (void)setupView
{
    //蒙板背景
    _maskView = [UIButton buttonWithType:UIButtonTypeCustom];
    _maskView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    _maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    _maskView.userInteractionEnabled = YES;
    [_maskView addTarget:self action:@selector(onTapMaskView:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_maskView];
    
    //背景
    self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
    self.backGroundView.backgroundColor = [UIColor whiteColor];
    self.backGroundView.userInteractionEnabled = YES;
    [_maskView addSubview:self.backGroundView];
    [self.backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_maskView);
        make.left.equalTo(_maskView).offset(kWidth(10));
        make.right.equalTo(_maskView).offset(-kWidth(10.0));
        make.height.mas_equalTo(kHeight(350));
    }];
    [self.backGroundView clipWithCornerRadius:kHeight(5.0) borderColor:nil borderWidth:0];
    
    //重新签名的操作
    UIButton *reSignBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@" 重新签字",MediumFont(font(11)),HEXColor(@"#999999"),0);
        [button setImage:V_IMAGE(@"重置按钮") forState:UIControlStateNormal];
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self onClear];
        }];
    }];
    reSignBtn.hidden = YES;
    [self.backGroundView addSubview:reSignBtn];
    [reSignBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backGroundView);
        make.bottom.equalTo(self.backGroundView).offset(-kWidth(20.0));
    }];
    
    self.reSignBtn = reSignBtn;
    
    signatureView = [[EasySignatureView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - kWidth(20), kHeight(350 - 20 - 20))];
    signatureView.backgroundColor = white_color;
    signatureView.delegate = self;
    signatureView.showMessage = @"";
    [self.backGroundView addSubview:signatureView];
    
    [signatureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.backGroundView);
        make.bottom.equalTo(reSignBtn.mas_top);
    }];
    
    UILabel *signPlaceHoderLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"请在此处签名",MediumFont(font(11)),HEXColor(@"#CCCCCC"));
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:signPlaceHoderLabel];
    [signPlaceHoderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.backGroundView);
    }];
    self.signPlaceHoderLabel = signPlaceHoderLabel;
    
    //提交的按钮
    UIButton *submmitBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"确认提交",MediumFont(font(13)),white_color,0);
        button.backgroundColor = HEXColor(@"#ec9373");
        button.userInteractionEnabled = NO;
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self okAction];
        }];
    }];
    [_maskView addSubview:submmitBtn];
    [submmitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backGroundView);
        make.left.right.equalTo(self.backGroundView);
        make.height.mas_equalTo(kHeight(40));
        make.top.equalTo(self.backGroundView.mas_bottom).offset(kHeight(35));
    }];
    
    self.submmitBtn = submmitBtn;
    
    [submmitBtn clipWithCornerRadius:kHeight(5.0) borderColor:nil borderWidth:0];

}

//产生手写动作
- (void)onSignatureWriteAction {
    self.signPlaceHoderLabel.hidden = YES;
    self.reSignBtn.hidden = NO;
    [self.submmitBtn setBackgroundColor:HEXColor(@"#FF4400")];
    self.submmitBtn.userInteractionEnabled = YES;
}

- (void)cancelAction {
    [self hide];
}

- (void)show {
    [UIView animateWithDuration:0.5 animations:^{
        UIWindow* window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
    }];
}


- (void)hide {
    [self removeFromSuperview];
}


- (void)onTapMaskView:(id)sender {
    [self hide];
}


//清除
- (void)onClear {
    [signatureView clear];
    self.signPlaceHoderLabel.hidden = NO;
    self.reSignBtn.hidden = YES;
    [self.submmitBtn setBackgroundColor:HEXColor(@"#ec9373")];
    self.submmitBtn.userInteractionEnabled = NO;
}


- (void)okAction
{
     [signatureView sure];
    if(signatureView.SignatureImg)
    {
        NSLog(@"haveImage");
        self.hidden = YES;
        [self hide];
        if (self.delegate != nil &&[self.delegate respondsToSelector:@selector(onSubmitBtn:)]) {
            [self.delegate onSubmitBtn:signatureView.SignatureImg];
        }
    }
    else
    {
        NSLog(@"NoImage");
    }

}


@end
