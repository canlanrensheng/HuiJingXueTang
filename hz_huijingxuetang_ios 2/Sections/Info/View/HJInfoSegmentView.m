//
//  HJInfoSegmentView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/6.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJInfoSegmentView.h"

#define count 4
#define Height kHeight(40.0)
@interface HJInfoSegmentView ()

@property (nonatomic,strong) UIButton *lastSelectButton;
@property (nonatomic,strong) UIView *lineView;


@property (nonatomic,strong) UIButton *button3;
@property (nonatomic,strong) UIButton *button2;
@property (nonatomic,strong) UIButton *button1;
@property (nonatomic,strong) UIButton *button4;

@end

@implementation HJInfoSegmentView

- (void)hj_configSubViews {
    self.backgroundColor = white_color;
    
    self.button1.frame = CGRectMake(0, 0, Screen_Width / count, Height);
    [self addSubview:self.button1];
    
    self.button2.frame = CGRectMake(Screen_Width / count, 0, Screen_Width / count, Height);
    [self addSubview:self.button2];
    
    
    self.button3.frame = CGRectMake(Screen_Width / count * 2, 0, Screen_Width / count, Height);
    [self addSubview:self.button3];
    
    self.button4.frame = CGRectMake(Screen_Width / count * 3, 0, Screen_Width / count, Height);
    [self addSubview:self.button4];
    
    self.lineView.frame = CGRectMake(0, Height - kHeight(3.0 + 4.0), kWidth(20.0) , kHeight(3.0));
    [self addSubview:self.lineView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, Height - kHeight(1.0), Screen_Width , kHeight(1.0))];
    bottomView.backgroundColor = HEXColor(@"#EAEAEA");
    [self addSubview:bottomView];
    
    self.button1.titleLabel.font = BoldFont(font(15));
    [self.button1 setTitleColor:HEXColor(@"#22476B") forState:UIControlStateNormal];
    self.lastSelectButton = self.button1;
    self.lineView.centerX = self.lastSelectButton.centerX;
    
}

- (void)setNameArray:(NSMutableArray *)nameArray {
    _nameArray = nameArray;
    [self.button1 setTitle:nameArray.firstObject forState:UIControlStateNormal];
    [self.button2 setTitle:nameArray[1] forState:UIControlStateNormal];
    [self.button3 setTitle:nameArray[2] forState:UIControlStateNormal];
    [self.button4 setTitle:nameArray.lastObject forState:UIControlStateNormal];
}

- (UIButton *)button1{
    if(!_button1){
        _button1 = [UIButton creatButton:^(UIButton *button) {
            button.ljTitle_font_titleColor_state(@"财经早参",MediumFont(font(15)),HEXColor(@"#333333"),0);
            @weakify(self);
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self);
                [self.lastSelectButton setTitleColor:HEXColor(@"#333333") forState:UIControlStateNormal];
                [button setTitleColor:HEXColor(@"#22476B") forState:UIControlStateNormal];
                self.lastSelectButton = button;
                self.lineView.centerX = self.lastSelectButton.centerX;
                [self.clickSubject sendNext:@(0)];
            }];
        }];
    }
    return _button1;
}

- (UIButton *)button2{
    if(!_button2){
        _button2 = [UIButton creatButton:^(UIButton *button) {
            button.ljTitle_font_titleColor_state(@"战法模型",MediumFont(font(15)),HEXColor(@"#333333"),0);
            @weakify(self);
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self);
                [self.lastSelectButton setTitleColor:HEXColor(@"#333333") forState:UIControlStateNormal];
                [button setTitleColor:HEXColor(@"#22476B") forState:UIControlStateNormal];
                self.lastSelectButton = button;
                self.lineView.centerX = self.lastSelectButton.centerX;
                [self.clickSubject sendNext:@(1)];
            }];
        }];
    }
    return _button2;
}

- (UIButton *)button3{
    if(!_button3){
        _button3 = [UIButton creatButton:^(UIButton *button) {
            button.ljTitle_font_titleColor_state(@"教学跟踪",MediumFont(font(15)),HEXColor(@"#333333"),0);
            @weakify(self);
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self);
                [self.lastSelectButton setTitleColor:HEXColor(@"#333333") forState:UIControlStateNormal];
                [button setTitleColor:HEXColor(@"#22476B") forState:UIControlStateNormal];
                self.lastSelectButton = button;
                self.lineView.centerX = self.lastSelectButton.centerX;
                [self.clickSubject sendNext:@(2)];
            }];
        }];
    }
    return _button3;
}

- (UIButton *)button4{
    if(!_button4){
        _button4 = [UIButton creatButton:^(UIButton *button) {
            button.ljTitle_font_titleColor_state(@"大盘精解",MediumFont(font(15)),HEXColor(@"#333333"),0);
            @weakify(self);
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self);
                [self.lastSelectButton setTitleColor:HEXColor(@"#333333") forState:UIControlStateNormal];
                [button setTitleColor:HEXColor(@"#22476B") forState:UIControlStateNormal];
                self.lastSelectButton = button;
                self.lineView.centerX = self.lastSelectButton.centerX;
                [self.clickSubject sendNext:@(3)];
            }];
        }];
    }
    return _button4;
}

- (UIView *)lineView {
    if(!_lineView){
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HEXColor(@"#22476B");
        [_lineView clipWithCornerRadius:kHeight(1.5) borderColor:nil borderWidth:0];
    }
    return _lineView;
}

- (RACSubject *)clickSubject {
    if (!_clickSubject) {
        _clickSubject = [RACSubject subject];
    }
    return _clickSubject;
}


@end

