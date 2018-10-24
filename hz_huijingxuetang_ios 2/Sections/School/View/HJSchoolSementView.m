//
//  HJSchoolSementView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/23.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSchoolSementView.h"

@interface HJSchoolSementView ()

@property (nonatomic,strong) UIButton *classButton;
@property (nonatomic,strong) UIButton *liveButton;

@property (nonatomic,strong) UIButton *lastSelectButton;
@property (nonatomic,strong) UIView *lineView;

@end

@implementation HJSchoolSementView

- (void)hj_configSubViews {
    self.backgroundColor = HEXColor(@"#141E2F");
    self.lastSelectButton = self.classButton;
    self.classButton.frame = CGRectMake(0, 0, Screen_Width / 2, self.bounds.size.height);
    [self addSubview:self.classButton];
    self.liveButton.frame = CGRectMake(Screen_Width / 2, 0, Screen_Width / 2, self.bounds.size.height);
    [self addSubview:self.liveButton];
    
    self.lineView.frame = CGRectMake(0, self.bounds.size.height - kHeight(3.0), Screen_Width / 2 , kHeight(3.0));
    [self addSubview:self.lineView];
    
    self.lineView.centerX = self.lastSelectButton.centerX;
    
}

- (UIButton *)classButton{
    if(!_classButton){
        _classButton = [UIButton creatButton:^(UIButton *button) {
            button.ljTitle_font_titleColor_state(@"课程",MediumFont(font(15)),white_color,0);
            @weakify(self);
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self);
                self.lastSelectButton = button;
                self.lineView.centerX = self.lastSelectButton.centerX;
                [self.clickSubject sendNext:@(0)];
            }];
        }];
    }
    return _classButton;
}

- (UIButton *)liveButton{
    if(!_liveButton){
        _liveButton = [UIButton creatButton:^(UIButton *button) {
            button.ljTitle_font_titleColor_state(@"直播",MediumFont(font(15)),white_color,0);
            @weakify(self);
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self);
                self.lastSelectButton = button;
                self.lineView.centerX = self.lastSelectButton.centerX;
                [self.clickSubject sendNext:@(1)];
            }];
        }];
    }
    return _liveButton;
}

- (UIView *)lineView {
    if(!_lineView){
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HEXColor(@"#FAD466");
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