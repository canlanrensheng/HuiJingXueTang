//
//  HJSchoolDetailAliveToolView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/26.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSchoolDetailAliveToolView.h"

#define count 2
#define Height kHeight(40.0)
@interface HJSchoolDetailAliveToolView ()

@property (nonatomic,strong) UIButton *classButton;
@property (nonatomic,strong) UIButton *liveButton;

@property (nonatomic,strong) UIButton *lastSelectButton;
@property (nonatomic,strong) UIView *lineView;

@end

@implementation HJSchoolDetailAliveToolView

- (void)hj_configSubViews {
    self.backgroundColor = white_color;
    
    self.classButton.frame = CGRectMake(0, 0, Screen_Width / count, Height);
    [self addSubview:self.classButton];
    
    self.liveButton.frame = CGRectMake(Screen_Width / count, 0, Screen_Width / count, Height);
    [self addSubview:self.liveButton];
    
    self.lineView.frame = CGRectMake(0, Height - kHeight(3.0 + 4.0), kWidth(20.0) , kHeight(3.0));
    [self addSubview:self.lineView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, Height - kHeight(1.0), Screen_Width , kHeight(1.0))];
    bottomView.backgroundColor = HEXColor(@"#EAEAEA");
    [self addSubview:bottomView];
    
    self.classButton.titleLabel.font = BoldFont(font(15));
    [self.classButton setTitleColor:HEXColor(@"#22476B") forState:UIControlStateNormal];
    self.lastSelectButton = self.classButton;
    self.lineView.centerX = self.lastSelectButton.centerX;
    
}

- (UIButton *)classButton{
    if(!_classButton){
        _classButton = [UIButton creatButton:^(UIButton *button) {
            button.ljTitle_font_titleColor_state(@"聊天",MediumFont(font(15)),HEXColor(@"#333333"),0);
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
    return _classButton;
}

- (UIButton *)liveButton{
    if(!_liveButton){
        _liveButton = [UIButton creatButton:^(UIButton *button) {
            button.ljTitle_font_titleColor_state(@"往期回顾",MediumFont(font(15)),HEXColor(@"#333333"),0);
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
    return _liveButton;
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

