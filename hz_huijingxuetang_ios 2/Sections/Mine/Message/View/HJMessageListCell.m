//
//  HJMessageListCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/8.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJMessageListCell.h"

@implementation HJMessageListCell

- (void)hj_configSubViews {
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIImageView *liveImageV = [[UIImageView alloc] init];
    liveImageV.image = V_IMAGE(@"占位图");
    [self addSubview:liveImageV];
    [liveImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(10));
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kWidth(40), kHeight(40)));
    }];
    [liveImageV clipWithCornerRadius:kHeight(20.0) borderColor:nil borderWidth:0.0];
    
    //标题
    UILabel *titleTextLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"直播通知",MediumFont(font(13)),HEXColor(@"#333333"));
        label.textAlignment = TextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:titleTextLabel];
    [titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(liveImageV).offset(kHeight(4.0));
        make.left.equalTo(liveImageV.mas_right).offset(kWidth(11.0));
        make.height.mas_equalTo(kHeight(13));
    }];
    
    //描述
    UILabel *desTextLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"俞春老师正在直播",MediumFont(font(11)),HEXColor(@"#999999"));
        label.textAlignment = TextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:desTextLabel];
    [desTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleTextLabel.mas_bottom).offset(kHeight(9.0));
        make.left.equalTo(titleTextLabel);
        make.height.mas_equalTo(kHeight(11));
    }];
    
    //红色的按钮
    UILabel *redBotLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"0",MediumFont(font(11)),white_color);
        [label clipWithCornerRadius:kHeight(7.5) borderColor:nil borderWidth:0];
        label.textAlignment = TextAlignmentCenter;
        label.backgroundColor = HEXColor(@"#FF0000");
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:redBotLabel];
    [redBotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kWidth(15), kHeight(15)));
        make.right.equalTo(self).offset(-kWidth(15));
        make.centerY.equalTo(self);
    }];
}

@end
