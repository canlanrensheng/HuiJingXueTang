//
//  HJSchoolLiveToolView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/24.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSchoolLiveToolView.h"

@interface HJSchoolLiveToolView ()

@property (nonatomic,strong) UIButton *lastSelectBtn;

@end

@implementation HJSchoolLiveToolView

- (void)hj_configSubViews {
    self.backgroundColor = white_color;
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [selectBtn setTitle:@"直播" forState:UIControlStateNormal];
    selectBtn.tag = 0;
    selectBtn.titleLabel.font = MediumFont(font(13.0));
    [selectBtn setTitleColor:HEXColor(@"#333333") forState:UIControlStateNormal];
    [selectBtn setTitleColor:HEXColor(@"#22476B") forState:UIControlStateSelected];
    [self addSubview:selectBtn];
    
    selectBtn.selected = YES;
    self.lastSelectBtn = selectBtn;
    
    UIButton *priceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [priceBtn setTitle:@"预告" forState:UIControlStateNormal];
    priceBtn.tag = 1;
    [priceBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [priceBtn setTitleColor:HEXColor(@"#333333") forState:UIControlStateNormal];
    [priceBtn setTitleColor:HEXColor(@"#22476B") forState:UIControlStateSelected];
    priceBtn.titleLabel.font = MediumFont(font(13.0));
    [self addSubview:priceBtn];
    
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.mas_equalTo(Screen_Width / 2);
    }];
    
    [priceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.left.equalTo(selectBtn.mas_right);
        make.width.mas_equalTo(selectBtn);
    }];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = HEXColor(@"#EAEAEA");
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(kHeight(0.5));
    }];
}

- (void)btnClick:(UIButton *)btn {
    self.lastSelectBtn.selected = NO;
    btn.selected = YES;
    self.lastSelectBtn.titleLabel.font = MediumFont(font(13));
    btn.titleLabel.font = MediumFont(font(13));
    self.lastSelectBtn = btn;
    if(btn.tag == 0) {
        
    }
    if (btn.tag == 1) {
        
    }
    
}
@end
