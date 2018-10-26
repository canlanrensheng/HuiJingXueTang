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
    //主讲人job
    UILabel *jobLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"主讲人",MediumFont(font(10)),white_color);
        label.backgroundColor = HEXColor(@"#FF4400");
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [jobLabel clipWithCornerRadius:kHeight(2.5) borderColor:nil borderWidth:0];
    [self addSubview:jobLabel];
    [jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kHeight(10.0));
        make.left.equalTo(self).offset(kWidth(10.0));
        make.size.mas_equalTo(CGSizeMake(kWidth(40), kHeight(15)));
    }];
    
    //昵称
    UILabel *nameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"金建：这次直播到这里就结束了，下次同一时间与各 位不见不散",MediumFont(font(13)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(jobLabel);
        make.left.equalTo(jobLabel.mas_right).offset(kWidth(5.0));
        make.right.equalTo(self).offset(-kWidth(31.0));
    }];
    
}


@end
