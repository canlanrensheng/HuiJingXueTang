//
//  HJSearchResultListCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/26.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSearchResultListCell.h"

@implementation HJSearchResultListCell

- (void)hj_configSubViews {
    self.searchResultLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"三板斧战法",BoldFont(font(13)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 1.0;
        [label sizeToFit];
    }];
    [self addSubview:self.searchResultLabel];
    [self.searchResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(kWidth(20.0));
        make.height.mas_equalTo(kHeight(40.0));
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = HEXColor(@"#EAEAEA");
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).offset(-kHeight(0.5));
        make.left.right.equalTo(self);
        make.height.mas_offset(kHeight(1.0));
    }];
}

@end
