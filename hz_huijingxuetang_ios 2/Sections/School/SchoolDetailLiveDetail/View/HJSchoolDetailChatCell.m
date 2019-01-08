//
//  HJSchoolDetailChatCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/26.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSchoolDetailChatCell.h"

@implementation HJSchoolDetailChatCell

- (void)hj_configSubViews {
    self.backgroundColor = Background_Color;

    //昵称
    UILabel *nameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",MediumFont(font(13)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kHeight(5.0));
        make.left.equalTo(self).offset(kWidth(10.0));
        make.right.equalTo(self).offset(-kWidth(10.0));
    }];
    
    self.nameLabel = nameLabel;
    
}


@end
