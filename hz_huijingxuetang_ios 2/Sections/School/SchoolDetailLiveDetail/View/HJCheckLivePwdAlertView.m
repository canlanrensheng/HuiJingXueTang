//
//  HJCheckLivePwdAlertView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/30.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJCheckLivePwdAlertView.h"

#define MYCOLOR(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define PX (SWIDTH / 1242)

@interface HJCheckLivePwdAlertView()<UITextFieldDelegate>{
    
    
}

@property (nonatomic,strong)  UIView *alertView;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UITextField * phoneTf;

@property (nonatomic,copy) NSString *liveId;
@property (nonatomic,copy) NSString *teacherId;

@end

@implementation HJCheckLivePwdAlertView




- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //背景图
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sureBtnClick)];
        [_bgView addGestureRecognizer:tap];
        _bgView.userInteractionEnabled = YES;
        _bgView.backgroundColor = MYCOLOR(0, 0, 0, 0.6);
        [self addSubview:_bgView];
        
        //弹出视图
        UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(kWidth(38), (Screen_Height - kHeight(200)) / 2, Screen_Width - kWidth(76), kHeight(200))];
        alertView.centerY = _bgView.centerY;
        UITapGestureRecognizer * alertTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alertTapClick)];
        alertView.userInteractionEnabled = YES;
        [alertView addGestureRecognizer:alertTap];
        [alertView setBackgroundColor:white_color];
        alertView.layer.cornerRadius = kHeight(5.0);
        alertView.clipsToBounds = YES;
        [_bgView addSubview:alertView];
        
        _alertView.centerY = _bgView.centerY;
        CGRect rec = alertView.frame;
        rec.origin.x = (Screen_Width - rec.size.width) / 2;
        alertView.frame = rec;
        
        //标题
        UILabel *messageLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(@"请输入房间密码",BoldFont(font(15)),HEXColor(@"#333333"));
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 0;
            [label sizeToFit];
        }];
        [alertView addSubview:messageLabel];
        [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(alertView).offset(kHeight(16));
            make.centerX.equalTo(alertView);
            make.height.mas_equalTo(kHeight(14));
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = Line_Color;
        [alertView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(messageLabel.mas_bottom).offset(kHeight(16.0));
            make.left.right.equalTo(alertView);
            make.height.mas_equalTo(kHeight(0.5));
        }];
        
        //输入的类型
        _phoneTf = [[UITextField alloc] init];
        _phoneTf.textColor = [UIColor blackColor];
        _phoneTf.borderStyle = UITextBorderStyleNone;
        _phoneTf.font = MediumFont(font(15));
        _phoneTf.clearButtonMode = UITextFieldViewModeNever;
        _phoneTf.delegate = self;
//        NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
//        NSString *infoPwd = [defa objectForKey:@"InfoPwd"];
//        if(infoPwd.length > 0){
//            _phoneTf.text = infoPwd;
//        }
        _phoneTf.placeholder = @"";
        _phoneTf.tintColor = HEXColor(@"#2B4E71");
        _phoneTf.textAlignment = NSTextAlignmentCenter;
        _phoneTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _phoneTf.keyboardType = UIKeyboardTypeDefault;
        [alertView addSubview:_phoneTf];
        [_phoneTf mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(lineView.mas_bottom).offset(kHeight(50));
            make.top.equalTo(alertView.mas_centerY).offset(-kHeight(15.5));
            make.centerX.equalTo(alertView);
            make.left.equalTo(alertView).offset(kWidth(50));
            make.right.equalTo(alertView).offset(-kWidth(50));
            make.height.mas_equalTo(@(kHeight(25)));
        }];
        
        //分割线
        UIView *bottomLineView = [[UIView alloc] init];
        bottomLineView.backgroundColor = Line_Color;
        [alertView addSubview:bottomLineView];
        [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.phoneTf.mas_bottom).offset(kHeight(5.0));
            make.left.equalTo(alertView).offset(kWidth(50));
            make.right.equalTo(alertView).offset(-kWidth(50));
            make.height.mas_equalTo(1);
        }];
        
        CGFloat buttonWidth = (Screen_Width - kWidth(76)) / 2;
        //取消按钮
        UIButton *cancleBtn = [UIButton creatButton:^(UIButton *button) {
            button.ljTitle_font_titleColor_state(@"取消",MediumFont(font(13)),white_color,0);
            button.backgroundColor = RGBA(0, 0, 0, 0.2);
            @weakify(self);
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self);
                [self removeFromSuperview];
            }];
        }];
        [alertView addSubview:cancleBtn];
        [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kHeight(45.0));
            make.left.equalTo(alertView);
            make.width.mas_equalTo(buttonWidth);
            make.bottom.equalTo(alertView);
        }];
        
        //确定按钮
        UIButton *sureBtn = [UIButton creatButton:^(UIButton *button) {
            button.ljTitle_font_titleColor_state(@"确定",MediumFont(font(13)),white_color,0);
            button.backgroundColor = HEXColor(@"#2B4E71");
            @weakify(self);
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self);
                if(self.phoneTf.text.length <= 0){
                    ShowMessage(@"请输入密码");
                    return;
                }
                [[HJCheckLivePwdTool shareInstance] checkLivePwdWithPwd:self.phoneTf.text courseId:self.liveId success:^(BOOL isSetPwd){
                    if(!isSetPwd) {
                        ShowMessage(@"密码错误");
                        return;
                    }
                    NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
                    [defa setObject:self.phoneTf.text forKey:[NSString stringWithFormat:@"liveRoomPwd%@",self.teacherId.length > 0 ? self.teacherId : @""]];
                    [defa synchronize];

                    if(self.bindBlock){
                        self.bindBlock(self.phoneTf.text);
                    }
                    [self removeFromSuperview];
                } error:^{
                    
                }];
            }];
        }];
        [alertView addSubview:sureBtn];
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kHeight(45.0));
            make.bottom.equalTo(alertView);
            make.right.equalTo(alertView);
            make.width.mas_equalTo(buttonWidth);
        }];
        
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        _alertView = alertView;
    }
    return self;
}

- (void)textFieldWithText:(UITextField *)textField{
    if(textField == _phoneTf){
    }
}

- (HJCheckLivePwdAlertView * )initWithLiveId:(NSString *)liveId teacherId:(NSString *)teacherId BindBlock:(void(^)(NSString *pwd))bindBlock {
    self.liveId = liveId;
    self.teacherId = teacherId;
    _bindBlock = bindBlock;
    HJCheckLivePwdAlertView *alretView = [self initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    return alretView;
}

- (void)show{
    NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
    NSString *liveRoomPwd = [defa objectForKey:[NSString stringWithFormat:@"liveRoomPwd%@",self.teacherId.length > 0 ? self.teacherId : @""]];
    if(liveRoomPwd.length > 0) {
        [[HJCheckLivePwdTool shareInstance] checkLivePwdWithPwd:liveRoomPwd courseId:self.liveId success:^(BOOL isSetPwd){
            if(!isSetPwd) {
                [[UIApplication sharedApplication].keyWindow addSubview:self];
                _alertView.centerY = _bgView.centerY;
                CGRect rec = _alertView.frame;
                rec.origin.x = (Screen_Width - rec.size.width) / 2;
                _alertView.frame = rec;
                return;
            }
            if(self.bindBlock){
                self.bindBlock(liveRoomPwd);
            }
            [self removeFromSuperview];
        } error:^{
            
        }];
    } else {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        _alertView.centerY = _bgView.centerY;
        CGRect rec = _alertView.frame;
        rec.origin.x = (Screen_Width - rec.size.width) / 2;
        _alertView.frame = rec;
    }
}

- (void)dismisss {
    [self removeFromSuperview];
}

- (void)alertTapClick{
    
}

- (void)sureBtnClick{
    [self removeFromSuperview];
}

- (void)dismissView{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rec = self.alertView.frame;
        rec.origin.x = -(rec.size.width);
        self.alertView.frame = rec;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification *)noty{
    NSDictionary * dic = noty.userInfo;
    NSTimeInterval time = [[dic objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSValue * value = [dic objectForKey: UIKeyboardFrameEndUserInfoKey];
    CGRect rect;
    [value getValue:&rect];
    [UIView animateWithDuration:time animations:^{
        CGRect rec = self.alertView.frame;
        rec.origin.y = [UIScreen mainScreen].bounds.size.height - rec.size.height - rect.size.height;
        self.alertView.frame = rec;
    }];
}

#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)noty {
    NSDictionary * dic = noty.userInfo;
    NSTimeInterval time = [[dic objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSValue * value = [dic objectForKey: UIKeyboardFrameEndUserInfoKey];
    CGRect rect;
    [value getValue:&rect];
    [UIView animateWithDuration:time animations:^{
        _alertView.centerY = _bgView.centerY;
        CGRect rec = _alertView.frame;
        rec.origin.x = (Screen_Width - rec.size.width) / 2;
        _alertView.frame = rec;
    }];
}

@end



