//
//  HJStuntJudgeToolView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/27.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJStuntJudgeToolView.h"

#define count 3
#define Height kHeight(40.0)
@interface HJStuntJudgeToolView ()

@property (nonatomic,strong) UIButton *classButton;


@end

@implementation HJStuntJudgeToolView

- (void)hj_configSubViews {
    self.backgroundColor = white_color;
    
    self.classButton.frame = CGRectMake(0, 0, Screen_Width / count, Height);
    [self addSubview:self.classButton];
    
    self.liveButton.frame = CGRectMake(Screen_Width / count, 0, Screen_Width / count, Height);
    [self addSubview:self.liveButton];
    
    [self.liveButton addSubview:self.repleyedRedLabel];
    [self.repleyedRedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kWidth(15), kHeight(15)));
        make.centerX.equalTo(self.liveButton).offset(kWidth(25));
        make.centerY.equalTo(self.liveButton).offset(-kHeight(9.0));
    }];
    
    self.evaluationButton.frame = CGRectMake(Screen_Width / count * 2, 0, Screen_Width / count, Height);
    [self addSubview:self.evaluationButton];
    
    self.lineView.frame = CGRectMake(0, Height - kHeight(2.0 + 4.0), kWidth(20.0) , kHeight(2.0));
    [self addSubview:self.lineView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, Height - kHeight(1.0), Screen_Width , kHeight(1.0))];
    bottomView.backgroundColor = HEXColor(@"#EAEAEA");
    [self addSubview:bottomView];
    
    self.classButton.titleLabel.font = BoldFont(font(15));
    [self.classButton setTitleColor:HEXColor(@"#22476B") forState:UIControlStateNormal];
    self.lastSelectButton = self.classButton;
    self.lineView.centerX = self.lastSelectButton.centerX;
    
}

- (UILabel *)repleyedRedLabel {
    if(!_repleyedRedLabel) {
        _repleyedRedLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(@"0",MediumFont(font(11)),white_color);
            [label clipWithCornerRadius:kHeight(7.5) borderColor:nil borderWidth:0];
            label.textAlignment = TextAlignmentCenter;
            label.backgroundColor = HEXColor(@"#FF0000");
            label.numberOfLines = 0;
            [label sizeToFit];
        }];
        _repleyedRedLabel.hidden = YES;
    }
    return _repleyedRedLabel;
}

- (UIButton *)classButton{
    if(!_classButton){
        _classButton = [UIButton creatButton:^(UIButton *button) {
            button.ljTitle_font_titleColor_state(@"推荐",MediumFont(font(15)),HEXColor(@"#333333"),0);
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
            button.ljTitle_font_titleColor_state(@"已回复",MediumFont(font(15)),HEXColor(@"#333333"),0);
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

- (UIButton *)evaluationButton{
    if(!_evaluationButton){
        _evaluationButton = [UIButton creatButton:^(UIButton *button) {
            button.ljTitle_font_titleColor_state(@"待回复",MediumFont(font(15)),HEXColor(@"#333333"),0);
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
    return _evaluationButton;
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


- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    if(selectIndex == 0) {
        [self.lastSelectButton setTitleColor:HEXColor(@"#333333") forState:UIControlStateNormal];
        [self.classButton setTitleColor:HEXColor(@"#22476B") forState:UIControlStateNormal];
        self.lastSelectButton = self.classButton;
        self.lineView.centerX = self.lastSelectButton.centerX;
    } else if (selectIndex == 1) {
        [self.lastSelectButton setTitleColor:HEXColor(@"#333333") forState:UIControlStateNormal];
        [self.liveButton setTitleColor:HEXColor(@"#22476B") forState:UIControlStateNormal];
        self.lastSelectButton = self.liveButton;
        self.lineView.centerX = self.lastSelectButton.centerX;
    } else {
        [self.lastSelectButton setTitleColor:HEXColor(@"#333333") forState:UIControlStateNormal];
        [self.evaluationButton setTitleColor:HEXColor(@"#22476B") forState:UIControlStateNormal];
        self.lastSelectButton = self.evaluationButton;
        self.lineView.centerX = self.lastSelectButton.centerX;
    }
}

@end
