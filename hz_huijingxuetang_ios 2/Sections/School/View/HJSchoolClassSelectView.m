//
//  HJSchoolClassSelectView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/24.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSchoolClassSelectView.h"

@interface HJSchoolClassSelectView ()

@property (nonatomic,strong) UIView *leftView;
@property (nonatomic,strong) UIView *rightView;
@property (nonatomic,strong) UIButton *lastSelectBtn;
@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) UIView *rightButtonView;

@property (nonatomic,strong) UIButton *rightSelectbutton;

@end

@implementation HJSchoolClassSelectView

- (void)hj_configSubViews {
    [self createLeftView];
    [self createRightView];
}

- (void)createLeftView {
    UIView *leftView = [[UIView alloc] init];
    leftView.backgroundColor = HEXColor(@"#F9FBFF");
    [self addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.equalTo(self);
        make.width.mas_equalTo(kWidth(90));
    }];
    
    NSArray *titleArr = @[@"讲师分类",@"系列分类",@"价格分类"];
    CGFloat height = kHeight(40);
    for (int i = 0 ;i < 3;i ++) {
        UIButton *typeBtn = [UIButton creatButton:^(UIButton *button) {
            button.frame = CGRectMake(0, height * i, kWidth(90), height);
            button.ljTitle_font_titleColor_state(titleArr[i],MediumFont(font(13)),HEXColor(@"#333333"),0);
            [button setTitleColor:HEXColor(@"#333333") forState:UIControlStateNormal];
            [button setTitleColor:HEXColor(@"#22476B") forState:UIControlStateSelected];
            @weakify(self);
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self);
                self.lastSelectBtn.selected = NO;
                button.selected = YES;
                self.lastSelectBtn.titleLabel.font = MediumFont(font(13));
                button.titleLabel.font = MediumFont(font(13));
                self.lastSelectBtn = button;
                
                self.lineView.centerY = button.centerY;
            }];
        }];
        [leftView addSubview:typeBtn];
        
        if(i == 0) {
            self.lastSelectBtn = typeBtn;
            self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth(3.0), kHeight(30.0))];
            self.lineView.backgroundColor = HEXColor(@"#22476B");
            [leftView addSubview:self.lineView];
            self.lineView.centerY = typeBtn.centerY;
        }
    }
    
    //取消按钮
    UIButton *cancleBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"取消",MediumFont(font(13)),HEXColor(@"#22476B"),0);
        [button clipWithCornerRadius:kHeight(11.3) borderColor:HEXColor(@"#22476B") borderWidth:kHeight(1.0)];
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.backSubject sendNext:@(0)];
        }];
    }];
    [leftView addSubview:cancleBtn];
    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(leftView).offset(-kHeight(15.0));
        make.centerX.equalTo(leftView);
        make.size.mas_equalTo(CGSizeMake(kWidth(50), kHeight(23)));
    }];
    
    //重置按钮
    UIButton *resetBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"重置",MediumFont(font(13)),HEXColor(@"#22476B"),0);
        [button clipWithCornerRadius:kHeight(11.3) borderColor:HEXColor(@"#22476B") borderWidth:kHeight(1.0)];
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.backSubject sendNext:@(0)];
        }];
    }];
    [leftView addSubview:resetBtn];
    [resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cancleBtn.mas_top).offset(-kHeight(10.0));
        make.centerX.equalTo(leftView);
        make.size.mas_equalTo(CGSizeMake(kWidth(50), kHeight(23)));
    }];
    
    self.leftView = leftView;
}

- (void)createRightView {
    UIView *rightView = [[UIView alloc] init];
    rightView.backgroundColor = white_color;
    [self addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kHeight(20));
        make.bottom.equalTo(self);
        make.left.equalTo(self.leftView.mas_right);
        make.width.mas_equalTo(kWidth(90));
    }];
    
    self.rightView = rightView;
    
    [self reloadScrollViewWithImageArr:@[@"1",@"2",@"3",@"4",@"5"]];
    
    
}

- (void)reloadScrollViewWithImageArr:(NSArray *)assets{
    [[self.rightView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSUInteger assetCount = assets.count;
    CGFloat width = (Screen_Width - kWidth(90) - 4 * kWidth(10.0)) / 3;
    CGFloat height = kHeight(30);
    CGFloat padding = kWidth(10.0);
    for (NSInteger i = 0; i < assetCount; i++) {
        int lie = i % 3;
        int hang = (int)(i / 3);
        UIButton *itemBtn = [UIButton creatButton:^(UIButton *button) {
            button.ljTitle_font_titleColor_state(@"余春",MediumFont(font(13)),HEXColor(@"#999999"),0);
            [button setTitleColor:HEXColor(@"#999999") forState:UIControlStateNormal];
            [button setTitleColor:HEXColor(@"#22476B") forState:UIControlStateSelected];
            [button clipWithCornerRadius:kHeight(15.0) borderColor:HEXColor(@"#999999") borderWidth:kHeight(0.5)];
            button.frame = CGRectMake((width + padding) * lie, (height + padding) * hang, width, height);
            @weakify(self);
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self);
                self.rightSelectbutton.selected = NO;
                button.selected = YES;
                [self.rightSelectbutton clipWithCornerRadius:kHeight(15.0) borderColor:HEXColor(@"#999999") borderWidth:kHeight(0.5)];
                [button clipWithCornerRadius:kHeight(15.0) borderColor:HEXColor(@"#22476B") borderWidth:kHeight(0.5)];
                self.rightSelectbutton = button;
                
                [self.backSubject sendNext:@(1)];
            }];
        }];
        
        if(i == 0) {
            self.rightSelectbutton = itemBtn;
        }
        [self.rightView addSubview:itemBtn];
        
    }
}

- (RACSubject *)backSubject {
    if(!_backSubject) {
        _backSubject = [[RACSubject alloc] init];
    }
    return _backSubject;
}

@end
