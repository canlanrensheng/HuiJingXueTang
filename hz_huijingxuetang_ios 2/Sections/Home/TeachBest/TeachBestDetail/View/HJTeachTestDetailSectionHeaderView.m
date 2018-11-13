//
//  HJTeachTestDetailSectionHeaderView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/5.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJTeachTestDetailSectionHeaderView.h"

@implementation HJTeachTestDetailSectionHeaderView

//- (void)setFrame:(CGRect)frame {
//    frame.size.height -= 10;
//    [super setFrame:frame];
//}


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        self.backgroundColor =Background_Color;
        
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = white_color;
        [self addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(self).offset(kHeight(23));
        }];
        
        UILabel *timeKillLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(@"热门评论",BoldFont(font(17)),HEXColor(@"#EA4F1F"));
            label.numberOfLines = 0;
            [label sizeToFit];
        }];
        [backView addSubview:timeKillLabel];
        [timeKillLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(backView);
        }];
    
        //左边的试图
        UIImageView *liveImageV = [[UIImageView alloc] init];
        liveImageV.image = V_IMAGE(@"评论装饰图形");
        [backView addSubview:liveImageV];
        [liveImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(backView);
        }];
        
    }
    return self;
}

@end
