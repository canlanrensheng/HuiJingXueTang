//
//  HJClassDetailBottomView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/25.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJClassDetailBottomView.h"

@implementation HJClassDetailBottomView

- (void)hj_configSubViews {
    UIButton *shopCarBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"加入购物车",MediumFont(font(15)),white_color,0);
        button.backgroundColor = HEXColor(@"#F3B02F");
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.backSubject sendNext:@(0)];
        }];
    }];
    [self addSubview:shopCarBtn];
    [shopCarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.top.bottom.equalTo(self);
        make.width.mas_equalTo(Screen_Width / 2);
    }];
    
    UIButton *buyBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"立即购买",MediumFont(font(15)),white_color,0);
        button.backgroundColor = HEXColor(@"#FF4400");
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.backSubject sendNext:@(1)];
        }];
    }];
    [self addSubview:buyBtn];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.top.bottom.equalTo(self);
        make.right.equalTo(self);
        make.width.mas_equalTo(Screen_Width / 2);
    }];
}

- (RACSubject *)backSubject {
    if(!_backSubject) {
        _backSubject = [[RACSubject alloc] init];
    }
    return _backSubject;
}

@end
