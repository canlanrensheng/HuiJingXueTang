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
        make.left.right.top.bottom.equalTo(self);
    }];
}

- (UIImageView *)helpImageView {
    if(!_helpImageView) {
        _helpImageView = [[UIImageView alloc] init];
    }
    return _helpImageView;
}

@end
