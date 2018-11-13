//
//  HJTeachBestDetailNoCommentCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/12.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJTeachBestDetailNoCommentCell.h"

@implementation HJTeachBestDetailNoCommentCell

- (void)hj_configSubViews {
    self.backgroundColor = white_color;
    UIImageView *liveImageV = [[UIImageView alloc] init];
    liveImageV.image = V_IMAGE(@"暂无评论");
    [self addSubview:liveImageV];
    [liveImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(kHeight(23.0));
        make.size.mas_equalTo(CGSizeMake(kWidth(100), kHeight(100)));
    }];
    
    UILabel *timeKillLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"快来写点评论吧！",MediumFont(font(13)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:timeKillLabel];
    [timeKillLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(liveImageV);
        make.top.equalTo(liveImageV.mas_bottom).offset(15);
        make.height.mas_equalTo(kHeight(12));
    }];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = Background_Color;
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(kHeight(10.0));
    }];
}

@end
