//
//  BaseLoadingTitleView.m
//  BM
//
//  Created by txooo on 17/7/28.
//  Copyright © 2017年 张金山. All rights reserved.
//

#import "BaseLoadingTitleView.h"

@interface BaseLoadingTitleView ()

@property (nonatomic,strong) UIActivityIndicatorView *activityView;

@end

@implementation BaseLoadingTitleView

- (void)updateConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.height.centerY.mas_equalTo(self);
    }];
    [self.activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.equalTo(self.titleLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.centerX = Screen_Width/2;
    if (self.titleLabel.bounds.size.width == 0) {
        [self.activityView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
        }];
    }
}

- (void)tx_configSubViews {
    self.frame = CGRectMake(0, 0, Screen_Width, kTopBarHeight);
    [self addSubview:self.titleLabel];
    [self addSubview:self.activityView];
    [self updateConstraintsIfNeeded];
}

- (UIActivityIndicatorView *)activityView {
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_activityView startAnimating];
    }
    return _activityView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = UIColor.whiteColor;
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

@end
