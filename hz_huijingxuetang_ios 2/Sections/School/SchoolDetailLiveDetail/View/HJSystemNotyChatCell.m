//
//  HJSystemNotyChatCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/7.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSystemNotyChatCell.h"

@implementation HJSystemNotyChatCell


- (void)hj_configSubViews {
    //主讲人job
    UILabel *jobLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"系统通知",MediumFont(font(10)),white_color);
        label.backgroundColor = HEXColor(@"#22476B");
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [jobLabel clipWithCornerRadius:kHeight(2.5) borderColor:nil borderWidth:0];
    [self addSubview:jobLabel];
    [jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kHeight(5.0));
        make.left.equalTo(self).offset(kWidth(10.0));
        make.size.mas_equalTo(CGSizeMake(kWidth(50), kHeight(15)));
    }];
    
    //昵称
    UILabel *nameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",BoldFont(font(13)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(jobLabel);
        make.left.equalTo(self).offset(kWidth(10.0));
        make.right.equalTo(self).offset(-kWidth(10.0));
    }];
    
    self.nameLabel = nameLabel;
}
@end
