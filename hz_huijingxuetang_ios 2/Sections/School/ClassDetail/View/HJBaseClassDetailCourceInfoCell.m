//
//  HJBaseClassDetailCourceInfoCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/25.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJBaseClassDetailCourceInfoCell.h"

@implementation HJBaseClassDetailCourceInfoCell

- (void)hj_configSubViews {
    UILabel *teacherInfoLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"课程简介",BoldFont(font(15)),HEXColor(@"#22476B"));
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
    
    //描述
    UILabel *desLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"笑是俞春的标签，他为人亲和、授课风趣，但行事却非常务实、稳健。技术派出身的他，深入证券行业11年，曾任职证券咨询公司和券商，私",MediumFont(font(11)),HEXColor(@"#666666"));
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:desLabel];
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(teacherInfoLabel.mas_bottom).offset(kHeight(14.0));
        make.left.equalTo(self).offset(kWidth(10.0));
        make.right.equalTo(self).offset(-kWidth(10.0));
    }];
}

@end
