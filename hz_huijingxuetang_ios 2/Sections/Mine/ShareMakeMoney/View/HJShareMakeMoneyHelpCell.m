//
//  HJShareMakeMoneyHelpCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/28.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJShareMakeMoneyHelpCell.h"

@implementation HJShareMakeMoneyHelpCell

- (void)hj_configSubViews {
    [self addSubview:self.helpImageView];
    [self.helpImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kHeight(28.0));
        make.bottom.equalTo(self);
        make.left.right.equalTo(self);
    }];
}

- (UIImageView *)helpImageView {
    if(!_helpImageView) {
        _helpImageView = [[UIImageView alloc] init];
        _helpImageView.userInteractionEnabled = YES;
    }
    return _helpImageView;
}

@end
