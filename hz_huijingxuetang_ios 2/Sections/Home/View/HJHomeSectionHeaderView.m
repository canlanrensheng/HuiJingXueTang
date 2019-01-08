//
//  HJHomeSectionHeaderView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/26.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJHomeSectionHeaderView.h"

@implementation HJHomeSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self configSubViews];
    }
    return self;
}

- (void)configSubViews {
    self.backgroundColor = white_color;
    self.opaque = YES;
    
    //限时特惠
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = HEXColor(@"#22476B");
    lineView.opaque = YES;
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kWidth(10.0));
        make.size.mas_equalTo(CGSizeMake(kWidth(2.0), kHeight(14)));
        make.centerY.equalTo(self.contentView);
    }];
    
    UILabel *timeKillLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",MediumFont(font(15)),HEXColor(@"#22476B"));
        label.numberOfLines = 0;
        timeKillLabel.opaque = YES;
        [label sizeToFit];
    }];
    [self.contentView addSubview:timeKillLabel];
    [timeKillLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lineView);
        make.left.equalTo(lineView.mas_right).offset(kWidth(5.0));
    }];
    self.titleTextLabel = timeKillLabel;
    
    //更多按钮
    UIButton *moreBtn = [UIButton creatButton:^(UIButton *button) {
        button.ljTitle_font_titleColor_state(@"",H15,white_color,0);
        [button setBackgroundImage:V_IMAGE(@"更多") forState:UIControlStateNormal];
        button.opaque = YES;
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            //            @strongify(self);
            [self.backSubject sendNext:@""];
        }];
    }];
    [self.contentView addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lineView);
        make.right.equalTo(self.contentView).offset(-kWidth(10.0));
    }];
    self.moreBtn = moreBtn;
}

- (RACSubject *)backSubject {
    if (!_backSubject){
        _backSubject = [[RACSubject alloc] init];
    }
    return _backSubject;
}

@end
