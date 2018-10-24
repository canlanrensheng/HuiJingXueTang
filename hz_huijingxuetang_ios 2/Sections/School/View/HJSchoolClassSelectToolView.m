//
//  HJSchoolClassSelectToolView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/24.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSchoolClassSelectToolView.h"
#import "ScreenViewController.h"
@interface HJSchoolClassSelectToolView ()

@property (nonatomic,strong) UIButton *lastSelectBtn;

@end

@implementation HJSchoolClassSelectToolView

- (void)hj_configSubViews {
    self.backgroundColor = white_color;
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [selectBtn setTitle:@" 筛选" forState:UIControlStateNormal];
    selectBtn.tag = 0;
    selectBtn.titleLabel.font = MediumFont(font(13.0));
    [selectBtn setTitleColor:HEXColor(@"#333333") forState:UIControlStateNormal];
    [selectBtn setTitleColor:HEXColor(@"#22476B") forState:UIControlStateSelected];
    [selectBtn setImage:V_IMAGE(@"筛选") forState:UIControlStateNormal];
    [self addSubview:selectBtn];
    
    UIButton *priceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [priceBtn setTitle:@"价格" forState:UIControlStateNormal];
    priceBtn.tag = 1;
    [priceBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [priceBtn setTitleColor:HEXColor(@"#333333") forState:UIControlStateNormal];
    [priceBtn setTitleColor:HEXColor(@"#22476B") forState:UIControlStateSelected];
    priceBtn.titleLabel.font = MediumFont(font(13.0));
    [self addSubview:priceBtn];
    
    priceBtn.selected = YES;
    self.lastSelectBtn = priceBtn;
    
    
    UIButton *buyerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyerBtn setTitle:@"购买人数" forState:UIControlStateNormal];
    buyerBtn.tag = 2;
    [buyerBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [buyerBtn setTitleColor:HEXColor(@"#333333") forState:UIControlStateNormal];
    [buyerBtn setTitleColor:HEXColor(@"#22476B") forState:UIControlStateSelected];
    buyerBtn.titleLabel.font = MediumFont(font(13.0));
    [self addSubview:buyerBtn];
    
    //限时特惠
    UIButton *limitTeHuiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [limitTeHuiBtn setTitle:@"限时特惠" forState:UIControlStateNormal];
    limitTeHuiBtn.tag = 3;
    [limitTeHuiBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [limitTeHuiBtn setTitleColor:HEXColor(@"#333333") forState:UIControlStateNormal];
    [limitTeHuiBtn setTitleColor:HEXColor(@"#22476B") forState:UIControlStateSelected];
    limitTeHuiBtn.titleLabel.font = MediumFont(font(13.0));
    [self addSubview:limitTeHuiBtn];
    
    UIImageView *hotImageView = [UIImageView new];
    hotImageView.image = V_IMAGE(@"hot标签");
    [limitTeHuiBtn addSubview:hotImageView];
    [hotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kHeight(10.0));
        make.right.equalTo(self).offset(-kWidth(10.0));
    }];
    
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.mas_equalTo(Screen_Width / 4);
    }];
    
    [priceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.left.equalTo(selectBtn.mas_right);
        make.width.mas_equalTo(selectBtn);
    }];
    
    [buyerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.left.equalTo(priceBtn.mas_right);
        make.width.mas_equalTo(selectBtn);
    }];
    
    [limitTeHuiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.left.equalTo(buyerBtn.mas_right);
        make.width.mas_equalTo(selectBtn);
    }];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = HEXColor(@"#EAEAEA");
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(kHeight(1.0));
    }];
}

- (void)btnClick:(UIButton *)btn {
    self.lastSelectBtn.selected = NO;
    btn.selected = YES;
    self.lastSelectBtn.titleLabel.font = MediumFont(font(13));
    btn.titleLabel.font = MediumFont(font(13));
    self.lastSelectBtn = btn;
//    if(btn.tag == 0) {
//        ScreenViewController *vc = [[ScreenViewController alloc]init];
//        [VisibleViewController().navigationController pushViewController:vc animated:YES];
//    }
//    if (btn.tag == 1) {
//
//    }
//    if (btn.tag == 2) {
//
//    }
//    if (btn.tag == 3) {
//
//    }
    
    [self.clickSubject sendNext:@(btn.tag)];
}

- (RACSubject *)clickSubject {
    if (!_clickSubject) {
        _clickSubject = [RACSubject subject];
    }
    return _clickSubject;
}

@end
