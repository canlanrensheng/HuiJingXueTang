//
//  HJMyInfoOutLoginCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/16.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJMyInfoOutLoginCell.h"

@interface HJMyInfoOutLoginCell()

@property (nonatomic,strong) UILabel *outLoginLabel;

@end

@implementation HJMyInfoOutLoginCell

- (void)hj_configSubViews {
    UILabel *outLoginLabel= [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"退出登录",MediumFont(font(15)),HEXColor(@"#22476B"));
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:outLoginLabel];
    [outLoginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}


@end
