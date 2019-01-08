//
//  HJSearchResultNoDataCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/20.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSearchResultNoDataCell.h"

@implementation HJSearchResultNoDataCell

- (void)hj_configSubViews {
    self.backgroundColor = Background_Color;
    UILabel *noSearchRecordLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"没有搜索到相关结果",MediumFont(font(13)),HEXColor(@"#666666"));
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:noSearchRecordLabel];
    [noSearchRecordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.mas_equalTo(kHeight(13.0));
    }];
}

@end
