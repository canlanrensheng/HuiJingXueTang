//
//  HJBaseClassDetailGroupCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/25.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJBaseClassDetailGroupCell.h"

@implementation HJBaseClassDetailGroupCell

- (void)hj_configSubViews {
    UILabel *teacherInfoLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"入群学更多",BoldFont(font(15)),HEXColor(@"#22476B"));
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:teacherInfoLabel];
    [teacherInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kHeight(20.0));
        make.height.mas_equalTo(kHeight(14));
        make.left.equalTo(self).offset(kWidth(10.0));
    }];
    
    UIButton *moreBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"",H15,white_color,0);
        [button setBackgroundImage:V_IMAGE(@"前进箭头") forState:UIControlStateNormal];
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            
        }];
    }];
    [self addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(teacherInfoLabel);
        make.right.equalTo(self).offset(-kWidth(11.0));
    }];
    
    //头像
    UIImageView *iconImageV = [[UIImageView alloc] init];
    iconImageV.image = V_IMAGE(@"占位图");
    iconImageV.backgroundColor = Background_Color;
    [self addSubview:iconImageV];
    [iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(10.0));
        make.top.equalTo(teacherInfoLabel.mas_bottom).offset(kHeight(15.0));
        make.width.height.mas_equalTo(kHeight(40));
    }];
    [iconImageV clipWithCornerRadius:kHeight(20.0) borderColor:nil borderWidth:0];
    
    //描述
    UILabel *desLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"三板斧战法学习交流群",BoldFont(font(11)),HEXColor(@"#333333"));
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:desLabel];
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconImageV);
        make.left.equalTo(iconImageV.mas_right).offset(kWidth(10.0));
        make.right.equalTo(self).offset(-kWidth(10.0));
    }];
}

@end
