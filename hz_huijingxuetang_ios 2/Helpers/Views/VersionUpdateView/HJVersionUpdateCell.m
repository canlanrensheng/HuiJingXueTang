//
//  HJVersionUpdateCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/13.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJVersionUpdateCell.h"

@implementation HJVersionUpdateCell

- (void)hj_configSubViews {
    UILabel *versionContentLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"",MediumFont(font(11)),HEXColor(@"#666666"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:versionContentLabel];
    [versionContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.equalTo(self);
    }];
    
    self.versionContentLabel = versionContentLabel;
}


@end
