//
//  HJSchoolSearchView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/23.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSchoolSearchView.h"


@interface HJSchoolSearchView ()<UITextFieldDelegate>

@property (nonatomic,strong) UIImageView *iconImageView;


@property (nonatomic,strong) UIButton *searchBtn;

@end

@implementation HJSchoolSearchView



- (void)hj_configSubViews{
    self.userInteractionEnabled = YES;
    [self clipWithCornerRadius:kHeight(2.5) borderColor:nil borderWidth:0];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self addGestureRecognizer:tap];
    
    self.backgroundColor = white_color;
    
    [self addSubview:self.iconImageView];
    [self addSubview:self.placeLabel];

    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(kWidth(10));
        make.width.height.mas_equalTo(kHeight(12.0));
    }];
    
    [self.placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(self);
        make.left.equalTo(self.iconImageView.mas_right).offset(kWidth(6.0));
        make.right.equalTo(self);
        make.height.equalTo(self);
    }];
}


- (void)tx_bindViewModel {
    
}

- (RACSubject *)searchSubject {
    if (!_searchSubject) {
        _searchSubject = [RACSubject subject];
    }
    return _searchSubject;
}

- (UIImageView *)iconImageView {
    if(!_iconImageView){
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = V_IMAGE(@"搜索");
    }
    return _iconImageView;
}

- (UILabel *)placeLabel {
    if (!_placeLabel) {
        _placeLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(@"搜索/老师/课程",MediumFont(font(11.0)),HEXColor(@"#CCCCCC"));
            label.numberOfLines = 0;
            [label sizeToFit];
        }];
    }
    return _placeLabel;
}



- (void)tapClick {
    [self.searchSubject sendNext:@(0)];
}

@end
