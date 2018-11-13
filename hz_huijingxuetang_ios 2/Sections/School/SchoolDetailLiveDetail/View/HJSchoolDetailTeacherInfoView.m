//
//  HJSchoolDetailTeacherInfoView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/26.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSchoolDetailTeacherInfoView.h"
#import "HJPicAndTextButton.h"

@implementation HJSchoolDetailTeacherInfoView

- (void)hj_configSubViews {
    self.backgroundColor = white_color;
    
    UIImageView *iconImageV = [[UIImageView alloc] init];
    iconImageV.image = V_IMAGE(@"默认头像");
    iconImageV.backgroundColor = Background_Color;
    [self addSubview:iconImageV];
    [iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(10.0));
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(kHeight(40));
    }];
    [iconImageV clipWithCornerRadius:kHeight(20.0) borderColor:nil borderWidth:0];
    //昵称
    UILabel *nameLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"何晶莹",BoldFont(font(13)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageV).offset(kHeight(5.0));
        make.height.mas_equalTo(kHeight(13));
        make.left.equalTo(iconImageV.mas_right).offset(kWidth(10.0));
    }];
    
    //描述
    UILabel *desLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"量化从优，峰回路转，天下股评早知道。",MediumFont(font(11)),HEXColor(@"#666666"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:desLabel];
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(kHeight(7.0));
        make.height.mas_equalTo(kHeight(13));
        make.left.equalTo(iconImageV.mas_right).offset(kWidth(10.0));
    }];
    
    //关注的按钮
    HJPicAndTextButton *careButton = [HJPicAndTextButton buttonWithType:UIButtonTypeCustom withSpace:kHeight(5.0)];
    careButton.buttonStyle = ButtonImageTop;
    [careButton setImage:V_IMAGE(@"已关注") forState:UIControlStateNormal];
    [careButton setTitle:@"关注" forState:UIControlStateNormal];
    [careButton setTitleColor:HEXColor(@"#e3763d") forState:UIControlStateNormal];
    [careButton setTitleColor:HEXColor(@"#999999") forState:UIControlStateSelected];
    careButton.titleLabel.font = MediumFont(font(10));
    [careButton addTarget:self action:@selector(carBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:careButton];
    [careButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kWidth(50), kHeight(60)));
        make.right.equalTo(self).offset(-kWidth(10.0));
    }];
    
    //分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = Background_Color;
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(kHeight(5.0));
    }];
}

- (void)carBtnClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    if(btn.selected) {
        [btn setImage:V_IMAGE(@"未关注") forState:UIControlStateNormal];
        [btn setTitle:@"已关注" forState:UIControlStateNormal];
    } else {
        [btn setImage:V_IMAGE(@"已关注") forState:UIControlStateNormal];
        [btn setTitle:@"关注" forState:UIControlStateNormal];
    }
}

@end
