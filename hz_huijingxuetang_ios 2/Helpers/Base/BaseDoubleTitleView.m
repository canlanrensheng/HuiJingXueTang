//
//  BaseDoubleTitleView.m
//  BM
//
//  Created by txooo on 17/7/28.
//  Copyright © 2017年 张金山. All rights reserved.
//

#import "BaseDoubleTitleView.h"

@interface BaseDoubleTitleView ()

@end

@implementation BaseDoubleTitleView

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    self.centerY = VisibleViewController().navigationController.navigationBar.centerY;
    CGRect titleLabelFrame = self.titleLabel.frame;
    titleLabelFrame.size.width = MIN(CGRectGetWidth(self.titleLabel.frame), CGRectGetWidth(self.frame));
    titleLabelFrame.size.height = kHeight(17);
    titleLabelFrame.origin.x = CGRectGetWidth(self.frame) / 2 - CGRectGetWidth(titleLabelFrame) / 2;
    titleLabelFrame.origin.y = kHeight(10);
    self.titleLabel.frame = titleLabelFrame;
    
    CGRect subtitleLabelFrame = self.subtitleLabel.frame;
    subtitleLabelFrame.size.width = MIN(CGRectGetWidth(self.subtitleLabel.frame), CGRectGetWidth(self.frame));
    subtitleLabelFrame.origin.x = CGRectGetWidth(self.frame) / 2 - CGRectGetWidth(subtitleLabelFrame) / 2;
//    subtitleLabelFrame.origin.y = CGRectGetHeight(self.frame) - 4 - CGRectGetHeight(self.subtitleLabel.frame);
    subtitleLabelFrame.origin.y = CGRectGetMaxY(self.titleLabel.frame) + kHeight(3);
    subtitleLabelFrame.size.height = kHeight(10);
    self.subtitleLabel.frame = subtitleLabelFrame;
}

- (void)tx_configSubViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.subtitleLabel];
}

- (void)tx_bindViewModel {
    @weakify(self)
    RACSignal *titleLabelSignal = [RACObserve(self.titleLabel, text) doNext:^(id x) {
        @strongify(self)
        [self.titleLabel sizeToFit];
    }];
    
    RACSignal *subtitleLabelSignal = [RACObserve(self.subtitleLabel, text) doNext:^(id x) {
        @strongify(self)
        [self.subtitleLabel sizeToFit];
    }];
    
    [[RACSignal combineLatest:@[ titleLabelSignal, subtitleLabelSignal ]] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        self.frame = CGRectMake(0, 0, MAX(CGRectGetWidth(self.titleLabel.frame), CGRectGetWidth(self.subtitleLabel.frame)), kTopBarHeight);
    }];

}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = MediumFont(font(18));
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = UIColor.whiteColor;
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:font(10)];
        _subtitleLabel.textAlignment = NSTextAlignmentCenter;
        _subtitleLabel.textColor = UIColor.whiteColor;
    }
    return _subtitleLabel;
}

@end
